FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips"

ARG BUILD_PACKAGES="\
	cmake \
	g++ \
	git \
	liblua5.1-dev \
	libmbedtls-dev \
	libmysql++ \
	libneon27-dev \
	lua5.1-dev \
	make \
	systemtap-sdt-dev \
	uuid-dev \
	zlib1g-dev \
	libsodium-dev \
	libssl-dev"

# packages as variables
ARG RUNTIME_PACKAGES="\
	iputils-ping \
	libjson-perl \
	mariadb-client \
	net-tools \
	screen \
	unzip \
	wget"

RUN \
 ls -altr /tmp/ && \
 apt update && \
 echo "**** install build packages ****" && \
 apt-get install -y \
 	--no-install-recommends \
	$BUILD_PACKAGES && \
 apt-get install -y \
 	--no-install-recommends \
	$RUNTIME_PACKAGES && \
 echo "**** build EQEmu ****" && \
 mkdir -p /app/eqemu && \
 cd /app/eqemu && \
 git clone https://github.com/EQEmu/Server.git Server && \
 cd Server && \
 git submodule init && \
 git submodule update && \
 mkdir -p build && \
 cd build && \
 cmake -DEQEMU_BUILD_LOGIN=ON -DEQEMU_BUILD_LUA=ON -G 'Unix Makefiles' .. && \
 make -j $(nproc) && \
 cd /app/eqemu && \
 echo "**** install eqemu-web-admin ****" && \
 echo "**** installing nodejs ****" && \
 curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
 apt install -y nodejs && \
 echo "**** install server ****" && \
 mkdir -p /app/web-admin && \
 if [ -z ${SERVER_RELEASE+x} ]; then \
	SERVER_RELEASE=$(curl -sX GET "https://api.github.com/repos/Akkadius/eqemu-web-admin/commits/master" \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 	/tmp/server.tar.gz -L \
	"https://github.com/Akkadius/eqemu-web-admin/archive/${SERVER_RELEASE}.tar.gz" && \
 tar xf \
 	/tmp/server.tar.gz -C \
	/app/web-admin/ --strip-components=1 && \
 cd /app/web-admin && \
 npm install && \
 echo "**** install client ****" && \
 mkdir -p /tmp/client && \
 if [ -z ${CLIENT_RELEASE+x} ]; then \
	CLIENT_RELEASE=$(curl -sX GET "https://api.github.com/repos/Akkadius/eqemu-web-admin-client/commits/master" \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 	/tmp/client.tar.gz -L \
	"https://github.com/Akkadius/eqemu-web-admin-client/archive/${CLIENT_RELEASE}.tar.gz" && \
 tar xf \
 	/tmp/client.tar.gz -C \
	/tmp/client/ --strip-components=1 && \
 cd /tmp/client && \
 npm install && \
 echo "**** fixing bootstrap file ****" && \
 sed -i 's| \* \$input-line-height||g' src/assets/css/theme.min.css && \
 npm run build && \
 mv /tmp/client/dist/* /app/web-admin/public/ && \
 echo "**** cleanup ****" && \
 rm -rf \
	/root/.cache \
	/tmp/*

COPY root/ /
