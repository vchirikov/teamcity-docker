FROM jetbrains/teamcity-minimal-agent:latest
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
ENV AGENT_NAME default_agent
ENV SERVER_URL http://tc.network:8111
# Configure Kestrel web server to bind to port 80 when present
ENV ASPNETCORE_URLS=http://+:80 \  
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps perfomance
    NUGET_XMLDOC_MODE=skip

RUN apt-get update && apt-get install -y \
        wget \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu-dev \
        liblttng-ust0 \
        libssl1.0.2 \
        libstdc++6 \
        zlib1g && \
    wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y dotnet-sdk-2.1 git mercurial

# use Moscow time
RUN ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN  mkdir -p /data/teamcity_agent/conf && \
     mkdir -p /data/buildagent && \
     mkdir -p /data/logs/ && \
     mkdir -p /opt/buildagent/logs/ && \
     chmod -R 777 /data

RUN ln -fs /opt/buildagent/logs/ /data/logs/ && \
    ln -fs /opt/buildagent/ /data/buildagent 

WORKDIR /data

# volume
VOLUME ["/data"]

CMD ["/bin/bash", "/data/start.sh"]
