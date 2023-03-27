#devel version to access nvcc
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 

RUN apt update -y && apt upgrade -y && apt install -y wget git python3 python3-venv sudo ffmpeg libgl1 libglib2.0-0 git-lfs pip

# add user
RUN useradd -m yourname && echo "yourname:yourname" | chpasswd && adduser yourname sudo

WORKDIR /home/yourname/

USER yourname

workdir /home/yourname/stable-diffusion-webui
# CMD wget https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh 
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git .

# workdir /home/yourname/stable-diffusion-webui/models/Stable-diffusion

# RUN PIP IN VIRTUAL ENVIROMENT
RUN python3 -m venv venv
RUN ./venv/bin/pip install -r requirements.txt
run ./venv/bin/pip install --upgrade fastapi==0.90.1

workdir /home/yourname/stable-diffusion-webui/models/Stable-diffusion

COPY ./stable-diffusion-v1-5 . 

#run git lfs install
#run git clone https://huggingface.co/runwayml/stable-diffusion-v1-5

workdir  /home/yourname/stable-diffusion-webui

# CMD ["python3", "launch.py"]
RUN sudo -u yourname chmod -R 777 ./webui.sh
# CMD ["sudo"  "-u" "yourname" "./webui.sh"]
CMD ["./webui.sh", "--no-half", "--listen", "--enable-insecure-extension-access", "--disable-nan-check", "--xformers"]
