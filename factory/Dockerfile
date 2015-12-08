#FROM ubuntu:15.10
FROM python:3.5-slim
MAINTAINER JR Minnaar <jr.minnaar@gmail.com> 

RUN apt-get -q update && apt-get install -y \
  build-essential pkg-config curl git mercurial vim tree htop \
  libpng-dev libjpeg-dev libpng12-dev \
  libfreetype6-dev \
  libcairo2 libpango1.0-0 libgdk-pixbuf2.0-0 \
  libatlas-dev libblas-dev liblapack-dev libfftw3-dev libffi-dev \
  libssl-dev \
  libxml2-dev libxslt1-dev \
  libpq-dev libmysqlclient-dev libhdf5-serial-dev \
  libcurl4-openssl-dev \
  zlib1g-dev \
  gfortran

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3.5 get-pip.py
RUN pip install --upgrade pip virtualenv

WORKDIR /app
RUN virtualenv /env

ENV PATH=/env/bin:$PATH

COPY docker-entrypoint.sh /docker-entrypoint.sh

CMD /docker-entrypoint.sh

#RUN pip install -U pip wheel cython
