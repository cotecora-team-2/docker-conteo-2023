#!/bin/bash

set -e

## build ARGs
NCPUS=${NCPUS:--1}

function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install \
    libxml2-dev \
    libcairo2-dev \
    libgit2-dev \
    default-libmysqlclient-dev \
    libpq-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libssh2-1-dev \
    libxtst6 \
    libcurl4-openssl-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    unixodbc-dev

install2.r --error --skipinstalled -n $NCPUS \
    tidyverse \
    devtools \
    rmarkdown \
    BiocManager \
    vroom \
    gert

## dplyr database backends
install2.r --error --skipmissing --skipinstalled -n $NCPUS \
    dbplyr \
    DBI \
    dtplyr \
    nycflights13 \
    Lahman \
    RMariaDB \
    RSQLite \
    fst

## a bridge to far? -- brings in another 60 packages
# install2.r --error --skipinstalled -n $NCPUS tidymodels

 rm -rf /tmp/downloaded_packages
