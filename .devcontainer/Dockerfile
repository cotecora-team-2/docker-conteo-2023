FROM rocker/r-ver:4.2.3

ENV S6_VERSION=v2.1.0.2
ENV DEFAULT_USER=r-user
ENV PANDOC_VERSION=default
ENV CTAN_REPO=https://www.texlive.info/tlnet-archive/2022/03/09/tlnet
ENV PATH=$PATH:/usr/local/texlive/bin/x86_64-linux
ENV QUARTO_VERSION=latest

# Options for setup script
ARG USERNAME=r-user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && apt-get -y install libzip-dev \
    && usermod -a -G staff ${USERNAME} \
    && apt-get -y install \
        python3-pip \
        libgit2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libxt-dev \
        libfontconfig1-dev \
        libcairo2-dev \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts \
    && python3 -m pip --no-cache-dir install radian \
    && install2.r --error --skipinstalled --ncpus -1 \
        devtools \
        languageserver \
        httpgd \
    && rm -rf /tmp/downloaded_packages

RUN export TAG=$(git ls-remote --tags --refs --sort='version:refname' https://github.com/ManuelHentschel/vscDebugger v\* | tail -n 1 | cut --delimiter='/' --fields=3) \
    && Rscript -e "remotes::install_git('https://github.com/ManuelHentschel/vscDebugger.git', ref = '"${TAG}"', dependencies = FALSE)"

# R Session watcher settings.
# See more details: https://github.com/REditorSupport/vscode-R/wiki/R-Session-watcher
RUN echo 'if (interactive() && Sys.getenv("TERM_PROGRAM") == "vscode") source(file.path(Sys.getenv("HOME"), ".vscode-R", "init.R"))' >>"${R_HOME}/etc/Rprofile.site"


RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y tzdata && cp /usr/share/zoneinfo/America/Mexico_City /etc/localtime && \
    echo "America/Mexico_City" > /etc/timezone 

COPY scripts /rocker_scripts

RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_tidyverse.sh
RUN /rocker_scripts/install_verse.sh
#RUN /rocker_scripts/install_quarto.sh

RUN install2.r --error checkmate posterior

RUN install2.r --repos https://mc-stan.org/r-packages/ --error cmdstanr 

RUN install2.r --error \
    logger patchwork 

USER r-user
WORKDIR /home/r-user
RUN Rscript /rocker_scripts/install_cmdstan.R

