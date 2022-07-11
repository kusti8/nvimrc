FROM ubuntu:22.04

RUN apt update && apt install -y curl git unzip sudo make gcc lsof g++ && apt clean -y
RUN useradd -m -G sudo -s /bin/bash kusti8 && echo "kusti8:password" | chpasswd
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER kusti8
COPY . /nvimrc
RUN cd /nvimrc && echo m | ./install.sh

WORKDIR /home/kusti8
CMD ["/bin/bash"]
