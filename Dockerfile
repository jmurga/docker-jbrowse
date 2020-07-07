# JBrowse
FROM nginx
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /usr/share/man/man1 /usr/share/man/man7

RUN apt-get -qq update --fix-missing
RUN apt-get --no-install-recommends -y install build-essential zlib1g-dev libxml2-dev libexpat-dev postgresql-client libpq-dev libpng-dev wget unzip perl-doc ca-certificates vim git less

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /conda/ && \
    rm ~/miniconda.sh

ENV PATH="/conda/bin:${PATH}"

RUN conda install -y --override-channels --channel iuc --channel conda-forge --channel bioconda --channel defaults jbrowse

RUN conda init bash
RUN conda config --set auto_activate_base false

RUN rm -rf /usr/share/nginx/html && ln -s /conda/opt/jbrowse/ /usr/share/nginx/html && \
    ln -s /jbrowse/data /conda/opt/jbrowse/data && \
    sed -i '/include += {dataRoot}\/tracks.conf/a include += {dataRoot}\/datasets.conf' /conda/opt/jbrowse/jbrowse.conf && \
    sed -i '/include += {dataRoot}\/tracks.conf/a include += {dataRoot}\/../datasets.conf' /conda/opt/jbrowse/jbrowse.conf

WORKDIR /conda/opt/jbrowse

ENV JBROWSE_SAMPLE_DATA=/conda/opt/jbrowse/sample_data
ENV JBROWSE_DATA=/conda/opt/jbrowse/data
ENV JBROWSE=/conda/opt/jbrowse
ENV DATA_DIR=/data

VOLUME /data
ADD docker-entrypoint.sh /root


# CMD ['/docker-entrypoint.sh']
