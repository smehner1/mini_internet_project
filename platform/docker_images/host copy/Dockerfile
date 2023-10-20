FROM debian:buster
RUN apt-get update && apt-get install -y rsyslog locales iputils-ping traceroute \
  openssh-server vim tcpdump net-tools dnsutils iperf3 build-essential iperf git python3 python screen tmux
# Install cpanminus for bgpsimple

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


RUN apt-get install -y zlib1g
RUN apt-get install -y flow-tools
RUN apt-get install libz-dev


# install Harpoon Tool for Traffic generation
RUN apt-get install -y libexpat1
RUN apt-get install -y libexpat1-dev

RUN mkdir harpoon
RUN git clone https://github.com/jsommers/harpoon.git /harpoon
WORKDIR /harpoon
RUN ./configure
RUN make
RUN make selfconf
RUN make install

RUN rm cli/stats.py
RUN rm selfconf/harpoon_reconf.py

ADD stats.py /harpoon/cli/stats.py
ADD harpoon_reconf.py /harpoon/selfconf/harpoon_reconf.py
ADD run_client.sh /harpoon/run_client.sh
ADD run_server.sh /harpoon/run_server.sh

RUN mkdir -p /root/.ssh
RUN chmod +x /usr/sbin/docker-start
ENTRYPOINT ["/usr/sbin/docker-start"]
