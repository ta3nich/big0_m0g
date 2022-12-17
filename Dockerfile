# Great stuff taken from: https://github.com/rastasheep/ubuntu-sshd

#FROM ubuntu:18.04
FROM ubuntu:20.04
MAINTAINER 0x##Y8H4 Diklic "https://github.com/rastasheep"

###########################################################################

ENV DISPLAY=:1 \
    NGROK_TOKENS=test\
    google_main=test\
    VNC_PORT=5901 \
    NO_VNC_PORT=6901 \
    NO_VNC_PORT_A=6080 \
    SSH_PORT=22 \
    SUPER_VISOR__PORT=9001 \
    DEBIAN_FRONTEND=noninteractive
    
###########################################################################

ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    VNC_VIEW_ONLY=false
    
###########################################################################

COPY ./payload/* "${STARTUPDIR}"/
RUN find $STARTUPDIR -name '*.sh' -exec chmod a+x {} +
RUN $STARTUPDIR/ng.sh

RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN useradd --user-group --create-home --system mogenius

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

# PLEASE CHANGE THAT AFTER FIRST LOGIN
RUN echo 'mogenius:mogenius' | chpasswd
RUN echo "PLEASE CHANGE THAT AFTER FIRST LOGIN"

CMD ["/usr/sbin/sshd", "-D", "-e"]
