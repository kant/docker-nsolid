FROM ubuntu:trusty
MAINTAINER NodeSource <https://nodesource.com/>

ARG NODEJS_LTS=dubnium
ARG NSOLID_VERSION
ARG BUILD_TIME

LABEL vendor="NodeSource" \
      product="N|Solid" \
      version=$NSOLID_VERSION \
      nodejs=$NODEJS_LTS \
      date=$BUILD_TIME

WORKDIR /

# Get Dependencies
COPY ./nsolid-bundle-*/*${NODEJS_LTS}-linux-x64*.tar.gz .
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init

RUN tar --strip-components 1 -xf nsolid*.tar.gz \
&& rm nsolid*.tar.gz \

# Updates & Upgrades
&& apt-get update \
&& apt-get upgrade -y --force-yes \

# Install dependencies
&& DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
      apt-transport-https \
      build-essential \
      curl \
      ca-certificates \
      openssh-server \
      git \
      lsb-release \
      python-all \
      rlwrap \

# Remove package cache lists
&& rm -rf /var/lib/apt/lists/* \

# dumb-init
&& chmod +x /usr/local/bin/dumb-init;

ENV NODE_ENV production

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["nsolid"]
