dstack-factory
==============


Quick start
-----------

To install ``dstack-factory``, clone this repo and build the images:

.. code-block:: bash

   git clone git@github.com:obitec/dstack-factory.git
   cd dstack-factory
   docker-compose build factory

   # Optionally push to DockerHub:
   docker push obitec/dstack-factory:3.5

To build (or download) a wheel file, add it to a text file under ``recipes`` run the ``factory`` service:

.. code-block:: bash

   # Build or save the wheel package for django:
   echo "django==1.10.5" > recipes/requirements.txt
   docker-compose run --rm factory

By default, the ``factory`` service first builds and installs wheels for ``cython`` and ``numpy`` and then reads the ``recipe/requirements.txt`` file and builds wheels for each dependency (and their dependencies, all the way down). This default behaviour can be controlled by setting environmental variables, or a .env file (in the same directory as the ``docker-compose.yml`` file). The variables are:

- **CEXT**: Default = True. Installs cython and numpy if True.
- **BUILD_REQ**: Default = True. Installs dependencies from requirements.txt if True, otherwise use specified or existing wheel file(s) to build wheels.
- **RECIPE**: Default = "requirements". Set this value to project_name-version (e.g. django-1.10.5) to use a specific requirements file or wheel file.

Using the environmental variables, a better way to cache the django wheel file looks like this:

.. code-block:: bash

   echo "django==1.10.5" > recipes/django-1.10.5.txt
   export CEXT=False RECIPE=django-1.10.5 && docker-compose run --rm factory

After running this command, you should have all the necassary wheel files cached under ``wheelhouse``.

The next step is to  build a docker container with these dependencies pre-installed. If it is a public project and you want the container to also contain your application, make sure your application is listed in requirements.txt file and run:

.. code-block:: bash

   docker-compose build runtime

   # Optionally push to DockerHub:
   docker push obitec/dstack-runtime:3.5

   echo "django==1.10.5" > requirements.txt
   docker build -t obitec/django:1.10.5 .

Test the newly created image by running:

.. code-block:: bash

   docker run --rm obitec/django:1.10.5 django-admin

If this is a private application, and you want the final package to only be installed when running docker-compose up,
you have two options: ``Dockerfile-source`` and ``Dockerfile-wheel``. ``Dockerfile-source`` adds ``ONBUILD`` instructions for copying your application code from the ``${SRC_DIR}`` directory to ``/app``. ``Dockerfile-wheel`` copies and installs ``${WHEEL_FILE}``.

Using Dockerfile-source as example:

.. code-block:: bash

   docker build -f Dockerfile-source -t obitec/django:1.10.5-source .
   docker run --rm --user=webapp -v $PWD/test:/app obitec/django:1.10.5-source django-admin startproject demo
   cd test
   docker-compose up -d webapp_from_source
   docker exec -it test_webapp_from_source_1 python manage.py migrate

The benefit of having a docker image with all the dependecies (except the application itself) pre-installed is that you can use public infrastrucutre (like DockerHub) host this image. It also makes it easier to upgrade your production image if you only made changes to the code, and not the runtime (e.g. updating a dependency).


Python Support
--------------

The default Python version for ``factory`` and ``runtime`` is Python 3.5. Initial (untested) support for Python 3.6 has also been added and can be selected using the ``PY_VERSION`` docker build argument.


Contributing
------------

.. code-block:: bash

   # download latest source
   git clone git@github.com:obitec/dstack-factory.git
   cd dstack-factory

   # create and activate virtual python environment
   python3.6 -m venv venv
   source venv/bin/activate

   # install development dependencies
   pip install -e .[dev]


CLI usage
---------

.. code-block:: bash

   pip install dstack-factory
   factory dry demo
