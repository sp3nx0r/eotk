# Development dockerfile for EOTK
# EOTK will be downloaded and setup ready-to-run without root privileges

# To build:
# docker build --tag eotk-image .

# To run:
# docker run -it --cap-drop=all --name eotk-container eotk-image

# credit:
# v1 Alex Haydock <alex@alexhaydock.co.uk>
# v2 Alec Muffett <alec.muffett@gmail.com>

FROM ghcr.io/nginxinc/nginx-prometheus-exporter:edge as nginx-prometheus-exporter

FROM ubuntu:jammy

LABEL maintainer "Alec Muffett <alec.muffett@gmail.com>"

ENV DEBIAN_FRONTEND=non-interactive
ENV TZ=Etc/UTC

ENV TOR_REPO https://deb.torproject.org/torproject.org>
ENV TOR_FINGERPRINT A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
ENV TOR_KEYURL $TOR_REPO/$TOR_FINGERPRINT.asc
ENV TOR_VERSION 0.4.7.8

ENV OPENRESTY_VERSION 1.21.4.1

ENV EOTK_REPO https://github.com/alecmuffett/eotk.git
ENV EOTK_HOME /opt/eotk

# no-one will ever convince me that this syntax is not an awful hack
RUN apt-get update \
    && apt-get install -y \
      apt-transport-https \
      build-essential \
      curl \
      dirmngr \
      dumb-init \
      git \
      gnupg2 \
      libevent-dev \
      libpcre3-dev \
      libssl-dev \
      # libssl3 superceded libssl1.1 in jammy
      libssl3 \
      make \
      nano \
      nginx-extras \
      perl \
      perl \
      python3 \
      python3-dev \
      python3-pip \
      socat \
      zlib1g-dev \
    && apt-get clean \
    && git clone $EOTK_REPO $EOTK_HOME \
    && useradd -u 1000 user --home-dir $EOTK_HOME --no-create-home --system \
    && chown -R user:user $EOTK_HOME \
    && echo 'export PATH="$EOTK_HOME:$PATH"' > $EOTK_HOME/.bashrc

# put in our own flavor for building
COPY opt.d/ $EOTK_HOME/opt.d
RUN $EOTK_HOME/opt.d/build-docker.sh

# add in prometheus exporter
COPY --from=nginx-prometheus-exporter /usr/bin/nginx-prometheus-exporter /usr/bin/nginx-prometheus-exporter

# do mkcert bullshit
RUN curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64" \
    && chmod +x mkcert-v*-linux-amd64 \
    && cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert \
    # && mkcert -install \
    && mkdir -p $EOTK_HOME/.local/share/mkcert
    # && cp /root/.local/share/mkcert/* $EOTK_HOME/.local/share/mkcert/
COPY secrets.d/rootCA* $EOTK_HOME/.local/share/mkcert/
# stores cert to ~/.local/share/mkcert/rootCA.pem

# put in our own flavor for configuration
COPY templates.d/ $EOTK_HOME/templates.d
COPY tools.d/ $EOTK_HOME/tools.d

# put in our own flavor of secrets
RUN mkdir -p ${EOTK_HOME}/secrets.d
COPY secrets.d/ ${EOTK_HOME}/secrets.d/
COPY reddit.tconf ${EOTK_HOME}/reddit.tconf

RUN chown -R user:user $EOTK_HOME

USER user

WORKDIR $EOTK_HOME

EXPOSE 8080
EXPOSE 9113

ENTRYPOINT [ "/usr/bin/dumb-init", "--"]
CMD tools.d/docker-entrypoint.sh
