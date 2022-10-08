FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -q && \
    apt-get install -q -y --no-install-recommends \
    ca-certificates \
    software-properties-common \
    git \
    libglib2.0-0 \
    wget \
    llvm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget -O ~/miniconda.sh -q --show-progress --progress=bar:force https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh
ENV PATH=$CONDA_DIR/bin:$PATH

# install python 3.10 and pip
RUN conda install python=3.10 && conda install -c anaconda pip


RUN mkdir -p /root/.huggingface/

RUN conda install pytorch torchvision torchaudio cudatoolkit=11.6 -c pytorch -c conda-forge

WORKDIR /app

RUN echo "Cloning Project" && git clone https://github.com/ShivamShrirao/diffusers.git .

COPY convert_diffusers_to_sd.py /app/examples/dreambooth/
RUN chmod +x /app/examples/dreambooth/convert_diffusers_to_sd.py

WORKDIR /app/examples/dreambooth

COPY install.sh /app/examples/dreambooth/
RUN chmod +x /app/examples/dreambooth/install.sh

RUN pip install git+https://github.com/ShivamShrirao/diffusers.git && \
    pip install -U -r requirements.txt && \
    pip install bitsandbytes

ENTRYPOINT ["bash", "-c", "./install.sh"]
