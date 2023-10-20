FROM phusion/baseimage:0.9.16

RUN touch /etc/default/locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
RUN echo "LANG=en_US.UTF-8" >> /etc/default/locale
RUN echo "LANGUAGE=en_US.UTF-8" >> /etc/default/locale

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "LANG=en_US.UTF-8" >> /etc/environment
RUN echo "LANGUAGE=en_US.UTF-8" >> /etc/environment

# Install dependencies
RUN apt-get update && apt-get install -y curl wget openvswitch-switch openvswitch-common \
     vim openssh-server inetutils-traceroute net-tools tcpdump quagga

RUN echo "export VTYSH_PAGER=more" >>  /etc/bash.bashrc
RUN echo "VTYSH_PAGER=more" >> /etc/environment

RUN mkdir -p /home/bgpdump/ribs
RUN mkdir -p /home/bgpdump/updates 
RUN mkdir -p /home/netflow
RUN chmod 777 -R /home/bgpdump/

RUN	touch /etc/quagga/bgpd.conf && \
	touch /etc/quagga/ospfd.conf && \
	touch /etc/quagga/vtysh.conf && \
	touch /etc/quagga/zebra.conf

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y  nfdump fprobe
COPY init-nf.sh /usr/sbin/init-nf.sh

# Add startup script and set it as entrypoint
ADD docker-start /usr/sbin/docker-start
COPY looking_glass.sh /home/.looking_glass.sh
RUN chmod +x /usr/sbin/docker-start
ENTRYPOINT ["/usr/sbin/docker-start"]
