FROM ubuntu:16.04

# Fix error "Please use a locale setting which supports utf-8."
# See https://wiki.yoctoproject.org/wiki/TipsAndTricks/ResolvingLocaleIssues
RUN DEBIAN_FRONTENV=noninteractive apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install locales && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/* && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# All the yocto required packages for development system from
# http://www.yoctoproject.org/docs/latest/mega-manual/mega-manual.html#required-packages-for-the-host-development-system
# and packages for tool wic
RUN DEBIAN_FRONTENV=noninteractive apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
        sudo gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio \
        python3 python3-pip python3-pexpect python3-git python3-jinja2 pylint3 xz-utils debianutils curl \
        iputils-ping libegl1-mesa libsdl1.2-dev xterm dosfstools mtools parted syslinux tree zip && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# Replace default dash shell to bash with support a source command
RUN rm /bin/sh && \
    ln -s bash /bin/sh

# Add non-root user for build yocto no permit build using root user
RUN id build 2>/dev/null || useradd --uid 424242 --create-home build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

COPY scripts/exec_at.sh scripts/entrypoint.sh /

WORKDIR /bitbake

VOLUME /bitbake

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["/bin/bash"]