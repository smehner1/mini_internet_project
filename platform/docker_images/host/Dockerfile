FROM debian:stretch

RUN sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list
RUN sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list 
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y rsyslog locales iputils-ping traceroute \
  openssh-server vim tcpdump net-tools dnsutils iperf3 build-essential iperf git screen tmux python3-pip
# Install cpanminus for bgpsimple

# RUN apt-get install -y python3.9

RUN apt update -y && apt upgrade -y && \
    apt-get install -y wget build-essential checkinstall  libreadline-gplv2-dev  libncursesw5-dev  libssl-dev  libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev && \
    cd /usr/src && \
    wget https://www.python.org/ftp/python/3.8.15/Python-3.8.15.tgz && \
    tar xzf Python-3.8.15.tgz && \
    cd Python-3.8.15 && \
    ./configure --enable-optimizations && \
    make install

# cpanminus and build-essential needed for this
# RUN cpanm Net::BGP

# Set locale
RUN sed -i -e 's/# \(en_US\.UTF-8 .*\)/\1/' /etc/locale.gen && \
  locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add startup script and set it as entrypoint
ADD docker-start /usr/sbin/docker-start

RUN apt-get install -y ufw
RUN apt-get install -y iptables

RUN apt-get install -y zlib1g
RUN apt-get install -y flow-tools
RUN apt-get install libz-dev


# install Harpoon Tool for Traffic generation
# RUN apt-get install -y libexpat1
# RUN apt-get install -y libexpat1-dev

# RUN mkdir harpoon
# RUN git clone https://github.com/jsommers/harpoon.git /harpoon
# WORKDIR /harpoon
# RUN ./configure
# RUN make
# RUN make selfconf
# RUN make install

# RUN rm cli/stats.py
# RUN rm selfconf/harpoon_reconf.py

RUN mkdir -p /home/host_files
RUN chmod 777 -R /home/host_files

# install needed python packages for scapy usage
RUN pip3 install pandas
RUN pip3 install netaddr
RUN pip3 install matplotlib
RUN pip3 install pyx
RUN pip3 install scapy

RUN mkdir -p /root/.ssh
RUN chmod +x /usr/sbin/docker-start
ENTRYPOINT ["/usr/sbin/docker-start"]
