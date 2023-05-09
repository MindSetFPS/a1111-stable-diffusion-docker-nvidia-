#devel version to access nvcc
FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

RUN apt update -y && apt upgrade -y && apt install -y wget git python3 python3-venv sudo ffmpeg libgl1 libglib2.0-0 git-lfs pip libgoogle-perftools4 libtcmalloc-minimal4 sox ffmpeg libcairo2 libcairo2-dev

# add user
RUN useradd -m yourname && echo "yourname:yourname" | chpasswd && adduser yourname sudo

WORKDIR /home/yourname/

USER yourname

workdir /home/yourname/stable-diffusion-webui

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git .

# RUN PIP IN VIRTUAL ENVIROMENT
RUN python3 -m venv venv
RUN ./venv/bin/pip install wheel
RUN ./venv/bin/pip install svglib
RUN ./venv/bin/pip install -r requirements.txt
RUN ./venv/bin/pip install --upgrade fastapi==0.90.1

workdir /home/yourname/stable-diffusion-webui/models/Stable-diffusion

#You should have your stable diffusion models in the same directory this dockerfile
COPY ./stable-diffusion-v1-5 . 

workdir  /home/yourname/stable-diffusion-webui

RUN sudo -u yourname chmod -R 777 ./webui.sh

CMD ["./webui.sh", "--no-half", "--listen", "--enable-insecure-extension-access", "--disable-nan-check", "--xformers"]
