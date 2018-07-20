FROM jetbrains/teamcity-server
MAINTAINER Vladimir Chirikov <vovanchig@gmail.com>

# Fix some issues with APT packages.
# See https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
RUN dpkg-divert --local --rename --add /usr/bin/ischroot && ln -sf /bin/true /usr/bin/ischroot

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
ENV TEAMCITY_LOGS /data/logs

# install net sdk
RUN apt-get update && apt-get install -y git mercurial

# use Moscow time
RUN ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    ln -fs /opt/teamcity/logs /data/logs


RUN    mkdir -p /data/teamcity_server/datadir \
    && mkdir -p /data/logs \
    && chmod -R 777 /data

WORKDIR /data

EXPOSE 8111
# volume
VOLUME ["/data"]

CMD ["/bin/bash", "/data/start.sh"]
