FROM python:3.5-slim
MAINTAINER JR Minnaar <jr.minnaar@gmail.com>

# Add a non-privilaged user
#RUN adduser --disabled-password --gecos '' --no-create-home webapp && \
#    chown -R webapp:webapp /app

#VOLUME /home/webapp/.cache/pip/:rw /home/webapp/.conda/envs/.pkgs/:rw

RUN pip install --upgrade pip virtualenv wheel && virtualenv /env && mkdir -p /app
#USER webapp
ENV HOME /app
WORKDIR /app
ENV PATH /env/bin:$PATH

#RUN pip install --upgrade wheel

COPY wheelhouse /wheelhouse
COPY requirements.txt $HOME/
RUN pip install --pre --no-index -f /wheelhouse -r requirements.txt
RUN rm -rf /wheelhouse

# COPY ./bin/docker-entrypoint.sh /home/webapp/docker-entrypoint.sh
