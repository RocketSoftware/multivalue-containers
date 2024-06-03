FROM rockylinux/rockylinux:latest

ARG BUILD_URL=''

ENV UVHOME=/usr/uv
ENV PATH="${PATH}:${UVHOME}:${UVHOME}/bin"

RUN set -eux \
    && dnf -y update \
    && dnf install -y \
        cpio \
        ed \
        findutils.x86_64 \
        libnsl \
        ncurses \
        openssh-server \
        openssl \
        procps \
        sudo \
        unzip \
        vim \
        wget \
        which \
        diffutils \
    && dnf clean all \
    && ln -s /usr/lib64/libncurses.so.6 /usr/lib64/libncurses.so.5 \
    && ln -s /usr/lib64/libtinfo.so.6 /usr/lib64/libtinfo.so.5 \
    && echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    # Create group and users
    && echo 'root:root' | chpasswd \
    && groupadd -g 3000 u2_group \
    && useradd -u 4000 -l -m -g u2_group uvdb \
    && useradd -u 4001 -l -m -g u2_group qasit \
    && useradd -u 4002 -l -m -g u2_group uvsql \
    && useradd -u 4003 -l -m -g u2_group unidata \
    && useradd -u 4004 -l -m -g u2_group unidata2 \
    && useradd -u 4005 -l -m -g u2_group srcadm \
    && useradd -u 4006 -l -m -g u2_group qauser \
    && useradd -u 5000 -l -m -g u2_group -G wheel -p $(openssl passwd -1 no1wayQA) qa \
    && useradd -u 5001 -l -m -g u2_group -G wheel -p $(openssl passwd -1 u2dev) u2dev \
    && ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key \
    && mkdir /tmp_dir \
    && echo '/usr/uv/bin/uv' >> /home/u2dev/.bash_profile \
    && /usr/sbin/sshd

COPY *uv.sh /usr/local/bin/

HEALTHCHECK --interval=1m --start-period=5m CMD "check_uv.sh"

WORKDIR $UVHOME

EXPOSE 22 23 31438

ENTRYPOINT ["start_uv.sh"]