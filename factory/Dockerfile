FROM ubuntu:15.10
MAINTAINER JR Minnaar <jr.minnaar@gmail.com> 

RUN apt-get -q update && apt-get install -y build-essential curl git mercurial libpng-dev freetype* libblas-dev liblapack-dev libatlas-base-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev libpq-dev libmysqlclient-dev libcurl4-openssl-dev libjpeg-dev zlib1g-dev libpng12-dev gfortran python3.5-dev

RUN apt-get install -y vim tree git htop

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3.5 get-pip.py
RUN pip install --upgrade pip virtualenv

WORKDIR /app
RUN virtualenv /env

ENV PIP_WHEEL_DIR=/wheelhouse
ENV WHEELHOUSE=/wheelhouse
ENV PIP_FIND_LINKS=/wheelhouse
ENV VIRTUAL_ENV=/env
ENV PATH=/env/bin:$PATH

RUN pip install --upgrade wheel
