# Flowd
# flowd is a small NetFlow collector
FROM debian:jessie
MAINTAINER Javier Prieto <info@jprietove.com>

LABEL Title="Flowd" \
      Description="flowd is a small NetFlow collector daemon capable of understanding Cisco NetFlow version 1, version 5 and version 9 packet formats. flowd supports filtering and tagging of received flows before they are stored on disk, using a filter syntax similar to the OpenBSD PF packet filter. The on-disk format is flexible in that it allows selection of which packet fields are recorded, so logs may be made very compact."

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y build-essential wget byacc

WORKDIR /root

RUN wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/flowd/flowd-0.9.1.tar.gz

RUN tar -xf flowd-0.9.1.tar.gz

WORKDIR /root/flowd-0.9.1

RUN ./configure && make && make install

RUN mkdir /var/empty && groupadd _flowd && useradd -g _flowd -c "flowd privsep" -d /var/empty _flowd

COPY flowd.conf /usr/local/etc/

VOLUME [ "/usr/local/etc/" ]
VOLUME [ "/var/log/flowd/" ]

ENTRYPOINT /usr/local/sbin/flowd -g


