FROM ubuntu:16.04
MAINTAINER Zhang Yanru <375092859@qq.com>

ARG BUILD_DATE

ENV \
    LANG=zh_CN.UTF-8 LANGUAGE=zh_CN:zh:en_US:en LC_ALL=zh_CN.UTF-8 TERM=xterm \
    #COLUMNS=158 \
    #LINES=44 \
    HISTTIMEFORMAT='%F %T '

COPY sources.list.xenial /etc/apt/sources.list 

# Setting locales And ZoneTime \
RUN \
    apt-get -yqq update && \
    apt-get -yqq install apt-utils apt-transport-https && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    ln -sf /bin/bash /bin/sh && \
    DEBIAN_FRONTEND=noninteractive apt-get -yqq install locales tzdata && \
    locale-gen zh_CN.UTF-8 && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=zh_CN.UTF-8 && \
    #echo "LANGUAGE=zh_CN.UTF-8" >> /etc/default/locale && \
    #echo "LC_ALL=zh_CN.UTF-8" >> /etc/default/locale && \
    echo 

LABEL \
      org.label-schema.description="Costom Ubuntu16.04 LTS" \
      org.label-schema.build-date="${BUILD_DATE}" 

# Install base pkgs \ 
RUN \
    apt-get -yqq update && \
    #apt-get -yqq install supervisor gcc dkms openssl libssl-dev libpcre3-dev libffi-dev monit vim openssh-server sudo cron curl python-pip wget logrotate tmux git sysstat gettext-base gosu && \
    apt-get -yqq --no-install-recommends install supervisor openssl libssl-dev libpcre3-dev monit cron curl tmux logrotate net-tools python-pip && \
    apt-get -yqq autoremove && \ 
    apt-get -yqq clean && \
    rm -rf /var/lib/apt/lists/* && \ 
    #pip -q install --upgrade pip && \
    # Setting a default user \
    #useradd -md /home/admin -s /bin/bash admin && \ 
    #echo 'admin:$6$GzmZlRcJ$PTEXNiMqtj3BJWLL27/vZQhUGX62rsITEBQDtACnGc8ZENzjhSClbqdn3Naufpewb9stJyevtNou85wBimtrF0' |chpasswd -e && \
    #echo "admin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-qssec-init-users && \
    #chmod 440 /etc/sudoers.d/90-init-users && \
    #mkdir /var/run/sshd && \
    #sed -i 's/Port 22/Port 2200/g' /etc/ssh/sshd_config && \
    #echo "export HISTTIMEFORMAT='%F %T '" >> /etc/profile && \
    # \
    sed -i '/# End of file/i* soft nofile 655300\n* hard nofile 1048576' /etc/security/limits.conf && \
    echo 'ulimit -n 1048576' >> /etc/profile && \
    mkdir -p /container-files/init/ 

VOLUME ["/mnt/data","/var/log/supervisor/"]

ADD  etc/ /etc

COPY docker-entrypoint.sh /usr/local/bin/ 
COPY container-files/ /container-files

EXPOSE 80 443 2200

ENTRYPOINT ["docker-entrypoint.sh"]
CMD []
