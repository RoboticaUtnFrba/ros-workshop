FROM osrf/ros:melodic-desktop-bionic

LABEL maintainer="eborghiorue@frba.utn.edu.ar"

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common
RUN add-apt-repository universe
RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    git \
    libgl1-mesa-dev \
    netpbm=2:10.0-15.3build1 \
    python3 \
    python3-pip \
    x11-apps=7.7+6ubuntu1 \
    xorg \
    xvfb=2:1.19.6-1ubuntu4.8

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-melodic-common-tutorials \
    ros-melodic-ros-tutorials \
    && rm -rf /var/lib/apt/lists/*

# Jupyter ROS

# install npm first
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g n
RUN n stable

RUN pip3 install --upgrade pip

# install jupyter and configure
RUN pip3 install \
    bqplot \
    ipykernel \
    ipywidgets \
    jupyterlab \
    matplotlib \
    notebook \
    pyyaml

# Enable extensions in Jupyter Notebooks
RUN jupyter nbextension enable --py widgetsnbextension

RUN pip3 install jupyros
# To install the extension for jupyterlab, you also need to execute the following:
RUN jupyter labextension install jupyter-ros
# Build jupyterlab
RUN jupyter lab build

# https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_USER} ${HOME}

RUN apt-get install -y ros-melodic-teb-local-planner ros-melodic-turtlebot3-simulations
RUN mkdir -p ${HOME}/.ros
RUN chown -R ${NB_USER} ${HOME}/.ros

USER ${NB_USER}
WORKDIR ${HOME}

ENV DISPLAY=:99.0
ENV QT_QPA_PLATFORM=offscreen
RUN /usr/bin/Xorg -depth 16&
# modify the CMD and start a background server first
CMD ["jupyter", "lab", "--no-browser", "--ip", "0.0.0.0"]
