FROM ubuntu:22.04

RUN apt update && apt install -y curl git unzip sudo make gcc && apt clean -y
RUN useradd -m -G sudo -s /bin/bash kusti8 && echo "kusti8:password" | chpasswd

USER kusti8
COPY . /nvimrc
RUN cd /nvimrc && ./install.sh

WORKDIR /home/kusti8
CMD ["/bin/bash"]
