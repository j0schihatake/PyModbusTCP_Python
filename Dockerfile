# Dockerfile to deploy a llama-cpp container with conda-ready environments

#RUN docker pull continuumio/miniconda3:latest
# https://pymodbustcp.readthedocs.io/en/latest/examples/server.html

ARG TAG=latest
FROM continuumio/miniconda3:$TAG

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        git \
        locales \
        sudo \
        build-essential \
        dpkg-dev \
        ca-certificates \
        netbase\
        tzdata \
        nano \
        software-properties-common \
        python3-venv \
        python3-tk \
        pip \
        bash \
        ncdu \
        net-tools \
        wget \
        curl \
        psmisc \
        rsync \
        vim \
        unzip \
        htop \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

RUN groupadd --gid 1020 modbus-tcp-group
RUN useradd -rm -d /home/modbus-tcp-user -s /bin/bash -G users,sudo,modbus-tcp-group -u 1000 modbus-tcp-user

RUN echo 'modbus-tcp-user:admin' | chpasswd

# Установка modbus server:
RUN pip install pyModbusTCP

RUN mkdir /home/modbus-tcp-user/server

RUN cd /home/modbus-tcp-user/server

ADD ModbusServer.py /home/modbus-tcp-user/server/

# Устанавливаем начальную директорию
ENV HOME /home/modbus-tcp-user/server
WORKDIR ${HOME}

CMD python3 ./ModbusServer.py

# Запуск Сервера:

# запуск:
# docker build -t modbusserver .
# docker run -dit --name modbusserver -p 502:502 --gpus all --restart unless-stopped modbusserver:latest

# Debug
# docker container attach modbusserver
