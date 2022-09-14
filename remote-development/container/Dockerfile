FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN apt-get install -y less curl iputils-ping vim python3-pip nodejs npm
#RUN apt-get install -y less curl iputils-ping vim python3-pip nodejs npm build-essential libssl-dev libffi-dev python3-dev

RUN sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
&& sed -ri 's/^#StrictModes\s+.*/StrictModes no/' /etc/ssh/sshd_config \
&& sed -ri 's/#HostKey \/etc\/ssh\//HostKey \/etc\/ssh\/hostKeys\//g' /etc/ssh/sshd_config \
&& echo "PasswordAuthentication no" >> /etc/ssh/sshd_config \
&& echo "GatewayPorts yes" >> /etc/ssh/sshd_config

RUN rm /etc/ssh/ssh_host*

RUN ssh-keygen -A

EXPOSE 22

CMD ["/usr/sbin/sshd", "-De"]
