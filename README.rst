dstack-factory
==============

Factory to build wheel files for all the dependencies if a given wheel file or from a build requirements file.
Part of the dstack toolbelt to make it easier to manage and deploy python and django based projects.

Quick start
-----------

To install ``dstack-factory``, clone this repo:

.. code-block:: bash

   git clone git@github.com:obitec/dstack-factory.git
   cd dstack-factory
   docker-compose build factory
   
   # Optionally push to DockerHub:
   docker push obitec/dstack-factory:3.5
   
   # Build or save the wheel package for django:
   echo "django==1.10.5" > recipes/requirements.txt
   docker-compose run --rm factory

By default, the last command looks for a requirements.txt file and builds wheel files for each
dependency (and their dependencies, all the way down) including ``cython`` and ``numpy``. This default behaviour can be controlled by environmental variables, or a .env file (in the same directory as the docker-compose.yml file). The variables are:

- **CEXT**: Default = True. Installs cython and numpy if True.
- **BUILD_REQ**: Default = True. Installs dependencies from requirements.txt if true, otherwise use specified or existing wheel file(s) to build wheels.
- **RECIPE**: Default = "requirements". Set this value to project_name.version (e.g. superset-0.15.1) to use a specific requirements file or wheel file.

Using the environmental variables, a better way to build the container for running django looks like this:

.. code-block:: bash

   echo "django==1.10.5" > recipes/django-1.10.5.txt
   export CEXT=False RECIPE=django-1.10.5 && docker-compose run --rm factory

After running this command, you should have all the wheel files required to run your application. The next step is to
build a docker container with these dependencies pre-installed. If it is a public project and you want the container
to also contain your application code, make sure your application is listed in requirements.txt file and run:

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

