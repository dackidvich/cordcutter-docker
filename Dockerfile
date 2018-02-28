FROM quantumobject/docker-baseimage:16.04

ENV HEADPHONES_DIR /opt/Headphones
ENV HEADPHONES_URL https://github.com/rembo10/headphones.git
ENV HEADPHONES_BRANCH master
ENV HEADPHONES_CONFIG /config/headphones
ENV HEADPHONES_PORT 8181

ENV LAZYLIB_DIR /opt/LazyLibrarian
ENV LAZYLIB_URL https://github.com/DobyTang/LazyLibrarian.git
ENV LAZYLIB_BRANCH master
ENV LAZYLIB_CONFIG /config/lazylibrarian
ENV LAZYLIB_PORT 5299

ENV MYLAR_DIR /opt/Mylar
ENV MYLAR_URL https://github.com/evilhero/mylar.git
ENV MYLAR_BRANCH master
ENV MYLAR_CONFIG /config/mylar
ENV MYLAR_PORT 8090

ENV COUCHPOTATO_DIR /opt/Couchpotato
ENV COUCHPOTATO_URL https://github.com/CouchPotato/CouchPotatoServer.git
ENV COUCHPOTATO_BRANCH master
ENV COUCHPOTATO_CONFIG /config/couchpotato
ENV COUCHPOTATO_PORT 5050

ENV SONARR_DIR /opt/Sonarr
ENV SONARR_BRANCH master
ENV SONARR_URL https://download.sonarr.tv/v2/${SONARR_BRANCH}/mono/NzbDrone.${SONARR_BRANCH}.tar.gz
ENV SONARR_CONFIG /config/sonarr
ENV SONARR_PORT 8989

ENV UNRAR_URL https://www.rarlab.com/rar/unrarsrc-5.5.8.tar.gz
ENV NZBGET_DIR /opt/nzbget
ENV NZBGET_CONFIG /config/nzbget
ENV NZBGET_PORT 6789

ENV TRANSMISSION_CONFIG /config/transmission
ENV TRANSMISSION_PEERPORT 51413
ENV TRANSMISSION_RPCPORT 9091

ENV JACKETT_DIR /opt/Jackett
ENV JACKETT_REPO Jackett
ENV JACKETT_CONFIG /config/jackett
ENV JACKETT_PORT 9117

ENV PYTHONIOENCODING=UTF-8
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

ENV HEADPHONES_PACKAGES shntool
ENV MYLAR_PACKAGES python-cheetah
ENV COUCHPOTATO_PACKAGES libxml2 python-libxslt1 python-lxml python-setuptools python-dev libffi-dev libssl-dev python-pip
ENV SONARR_PACKAGES mono-complete ca-certificates-mono mediainfo mkvtoolnix
ENV NZBGET_PACKAGES build-essential jq
ENV TRANSMISSION_PACKAGES transmission-cli transmission-common transmission-daemon
ENV JACKETT_PACKAGES libcurl4-openssl-dev
ENV PACKAGES git ca-certificates sqlite3 ffmpeg python3.6 $HEADPHONES_PACKAGES $MYLAR_PACKAGES $COUCHPOTATO_PACKAGES $SONARR_PACKAGES $NZBGET_PACKAGES $TRANSMISSION_PACKAGES $JACKETT_PACKAGES

WORKDIR /tmp
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
	&& apt-get update -q \
	&& apt-get install -qy --no-install-recommends software-properties-common python-software-properties wget \
	&& apt-get -f install -qy \
	&& apt-add-repository -y ppa:git-core/ppa \
	&& apt-add-repository -y ppa:transmissionbt/ppa \
	&& apt-add-repository -y ppa:deadsnakes/ppa \
	&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
	&& echo "deb http://download.mono-project.com/repo/ubuntu stable-xenial main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
	&& echo "deb http://mkvtoolnix.download/ubuntu/$(lsb_release -sc)/ ./" | tee /etc/apt/sources.list.d/bunkus.org.list \
	&& wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add - \
	&& apt-get update -q \
	&& apt-get install -qy libjpeg-turbo8-dev \
	&& apt-get install -qy --no-install-recommends --allow-unauthenticated $PACKAGES \
	&& rm -f /usr/bin/python3 \
	&& ln -s /usr/bin/python3.6 /usr/bin/python3 \
	&& echo "Installing pyopenssl for Couchpotato" \
	&& pip install pyopenssl \
	&& echo "Installing unrar from source for nzbget" \
	&& wget -O unrar.tgz $UNRAR_URL --progress=dot:mega \
	&& tar zxvf unrar.tgz \
	&& cd unrar \
	&& make -f makefile \
	&& install -v -m777 unrar /usr/bin \
	&& cd /tmp \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /config

EXPOSE $HEADPHONES_PORT $LAZYLIB_PORT $MYLAR_PORT $COUCHPOTATO_PORT $SONARR_PORT $NZBGET_PORT $TRANSMISSION_PEERPORT $TRANSMISSION_RPCPORT $JACKETT_PORT

ADD defaults/ /defaults
ADD init/ /etc/my_init.d
ADD service/ /etc/service
RUN chmod -v +x -R /etc/my_init.d/* /etc/service/*

ADD sbin/ /tmp/sbin
RUN chmod -v 700 /tmp/sbin/* && chown -v root:root /tmp/sbin/* && mv -v /tmp/sbin/* /sbin

# Base docker image has problems trying to parse environment variables with spaces in them
ENV HEADPHONES_PACKAGES ""
ENV MYLAR_PACKAGES ""
ENV COUCHPOTATO_PACKAGES ""
ENV SONARR_PACKAGES ""
ENV NZBGET_PACKAGES ""
ENV TRANSMISSION_PACKAGES ""
ENV JACKETT_PACKAGES ""
ENV PACKAGES ""

CMD ["/sbin/my_init"]
