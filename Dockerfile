FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SNIBOX_VERSION
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
	libjson-perl \
	mariadb-client \
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
 echo "**** cleanup ****" && \
 rm -rf \
	/root/.cache \
	/tmp/*

COPY root/ /
