FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ENV PYTHONUNBUFFERED=1 

# SYSTEM
RUN apt-get update --yes --quiet && DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    software-properties-common \
    build-essential apt-utils \
    wget curl vim git ca-certificates kmod \
    nvidia-driver-525 \
 && rm -rf /var/lib/apt/lists/*

# PYTHON 3.10
RUN add-apt-repository --yes ppa:deadsnakes/ppa && apt-get update --yes --quiet
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    python3.10 \
    python3.10-dev \
    python3.10-distutils \
    python3.10-lib2to3 \
    python3.10-gdbm \
    python3.10-tk \
    pip


WORKDIR /root/h2o_llm_studio

COPY . .

RUN rm -rf /root/.cache/huggingface
RUN cp -r huggingface /root/.cache/

EXPOSE 10101 8000

RUN make setup

# ENTRYPOINT make wave

# ENTRYPOINT pipenv run python train.py -C examples/cfg_example_oasst1.py  
