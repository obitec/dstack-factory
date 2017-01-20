FROM python:3.6-slim
MAINTAINER JR Minnaar <jr.minnaar+dstack@gmail.com>

RUN apt-get update && apt-get install -y \
    libatlas3-base \
    libblas3 \
    libc6 \
    libcairo2 \
    libgcc1 \
    libgdk-pixbuf2.0-0
    libgfortran3 \
    libjpeg62 \
    liblapack3 \
    libmysqlclient18 \
    libpango1.0-0 \
    libpq5 \
    libxslt1.1 \

RUN pip install --upgrade pip virtualenv wheel && \
    virtualenv /env && \
    mkdir -p /app && \
    adduser --disabled-password --gecos '' --no-create-home webapp && \
    chown -R webapp:webapp /app

WORKDIR /app
ENV HOME=/app PATH=/env/bin:$PATH

ONBUILD COPY wheelhouse /wheelhouse
ONBUILD COPY requirements.txt /app/
ONBUILD RUN pip install --pre --no-index --no-cache-dir -f /wheelhouse -r requirements.txt && rm -rf /wheelhouse
