# JBrowse
# FROM httpd
FROM debian:stable-slim
ENV DEBIAN_FRONTEND noninteractive

ENV JBROWSE_DATA=/jbrowse/data
ENV JBROWSE=/jbrowse/
ENV DATA_DIR=/data
ENV JBIN=/jbrowse/bin


RUN mkdir -p /usr/share/man/man1 /usr/share/man/man7

RUN apt-get -qq update --fix-missing
RUN apt-get --no-install-recommends -y install build-essential zlib1g-dev libxml2-dev libexpat-dev postgresql-client libpq-dev libpng-dev wget unzip perl-doc ca-certificates vim git less curl systemd apache2 php


RUN git clone https://github.com/gmod/jbrowse /jbrowse

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt-get install -y nodejs

RUN git clone https://github.com/bhofmei/jbplugin-hierarchicalcheckbox.git /jbrowse/plugins/HierarchicalCheckboxPlugin

RUN git clone https://github.com/awilkey/bookmarks-jbrowse.git /jbrowse/plugins/bookmarks

# ADD input/DownloadFasta /jbrowse/plugins/DownloadFasta
WORKDIR /jbrowse

RUN ./setup.sh
RUN ln -s /jbrowse/ /var/www/html/dest


VOLUME /data
ADD docker-entrypoint.sh /root/docker-entrypoint.sh 

