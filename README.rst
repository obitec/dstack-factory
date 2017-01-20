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
   docker-compose build wheel-factory
   docker-compose run --rm -p project_name wheel-factory

By default, the last command looks for a requirements.txt file and builds wheel files for each
dependency (and their dependencies, all the way down) including ``cython`` and ``numpy``.

This behaviour can be controlled by environmental variables, or an .env file. The variables are:

- **CEXT**: Default = True. Installs cython and numpy if True.
- **BUILD_REQ**: Default = True. Installs dependencies from requirements.txt if true, otherwise use existing wheel file to build wheels.
- **RECIPE**: Default = requirements. Set this value to project_name.version (e.g. superset.0.15.1) to use a specific requirements file or wheel file.

After running this command, you should have all the wheel files required to run your application. The next step is to
build a docker container with these dependencies pre-installed. If it is a public project and you want the container
to also contain your application code, make sure your application is listed in requirements.txt file and run:

.. code-block:: bash

   docker build -t obitec/superset:0.15.1 .


If this is a private application, and you want the final package to only be installed when running docker-compose up,
you have two options: ``Dockerfile-source`` and ``Dockerfile-wheel``:

.. code-block:: bash

   docker build -f Dockerfile-source -t obitec/superset:0.15.1-source .
   docker build -f Dockerfile-wheel -t obitec/superset:0.15.1-wheel .

Dockerfile-source adds ``ONBUILD`` instructions for copying your application code from the ``${SRC_DIR}`` directory to ``/app``
Dockerfile-wheel copies and installs ``${WHEEL_FILE}``.

*Replace "obitec", "superset" and "0.15.1" with your own DockerHub username/organisation, image name and image tag.*

With a docker image containing your code, you can then use it as in this example ``docker-compose.yml`` file:

.. code-block:: yaml

   version: "2"

   services:
     webapp_from_wheel:
       image: superset:0.15.1-wheel
       build:
         context: .
         args:
           - WHEEL_FILE=dist/superset.${VERSION}-py3-any-none.whl
         user: webapp
         command: superset runserver

     webapp_from_source:
       image: superset:0.15.1-source
       build:
         context: .
         args:
           - UID=${UID}
           - SRC_DIR=src/
         user: webapp
         command: python manage.py runserver
