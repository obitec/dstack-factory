.. dstack-factory documentation master file, created by
   sphinx-quickstart on Sun Jan 22 20:02:32 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to dstack-factory's documentation!
==========================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   quickstart

dstack-factory consists of two components: (1) ``factory`` and (2) ``runtime``.

``factory`` is a service that builds (or downloads) python wheels from a pip requirements file or from a wheel package uploaded to the wheelhouse. If a python package is already available as wheel package, it is cached. Otherwise the source is downloaded from pip, git or any other source supported by pip and compiled/packaged as a wheel file.

Examples of python packages that currently still need to be build are:
   - psycopg2
   - lxml
   - pycrypto
   - pillow
   - weasyprint (and it's dependencies)
   - anything hosted on GitHub, e.g. forks of python packages or unreleased versions

``runtime`` is a base docker image that contains all the necessary libraries to run most popular python packages with external dependencies. For example pandas, matplotlib, weasyprint, etc. all require non-python libraries.
In addition to the base runtime docker image, ``dstack-factory`` also provides three entry point Dockerfiles to support different workflows for building and deploying docker and python based applications.



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
