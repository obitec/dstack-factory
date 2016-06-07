FROM python:3.5-slim
MAINTAINER JR Minnaar <jr.minnaar@gmail.com>

RUN apt-get update && apt-get install -y \
    libatlas3-base libblas3 libc6 libgfortran3 liblapack3 libgcc1 libjpeg62 libpq5 \
    libxslt1.1 libcairo2 libpango1.0-0 libgdk-pixbuf2.0-0

RUN pip install --upgrade pip virtualenv wheel && virtualenv /env && mkdir -p /app

# Non privaged user
RUN adduser --disabled-password --gecos '' --no-create-home webapp && \
    chown -R webapp:webapp /app

WORKDIR /app
ENV HOME /app
ENV PATH /env/bin:$PATH

COPY wheelhouse /wheelhouse
COPY requirements.txt $HOME/
RUN pip install --pre --no-index -f /wheelhouse -r requirements.txt && rm -rf /wheelhouse
