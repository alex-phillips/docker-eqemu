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
	libmysql++ \
	lua5.1-dev \
	make \
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






# # git g++ make cmake lua5.1-dev liblua5.1-dev zlib1g-dev libsodium-dev libssl-dev libmysql++ libmbedtls-dev uuid-dev


# # set version label
# ARG BUILD_DATE
# ARG VERSION
# ARG SNIBOX_VERSION
# LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
# LABEL maintainer="alex-phillips"

# ARG BUILD_PACKAGES="\
# 	build-essential \
# 	cmake \
# 	cpp \
# 	curl \
# 	debconf-utils \
# 	g++ \
# 	gcc \
# 	git \
# 	git-core \
# 	libio-stringy-perl \
# 	liblua5.1 \
# 	liblua5.1-dev \
# 	libluabind-dev \
# 	libmysql++ \
# 	libperl-dev \
# 	libperl5i-perl \
# 	libmysqlclient-dev \
# 	minizip \
# 	lua5.1 \
# 	make \
# 	mariadb-client \
# 	open-vm-tools \
# 	unzip \
# 	uuid-dev \
# 	wget -q \
# 	minizip \
# 	zlibc \
# 	libsodium-dev \
# 	libsodium23 \
# 	libjson-perl \
# 	libssl-dev"

# # packages as variables
# ARG RUNTIME_PACKAGES="\
# 	libboost-filesystem-dev \
# 	libboost-iostreams-dev \
# 	libboost-program-options-dev \
# 	libboost-system-dev \
# 	libboost-thread-dev \
# 	libmariadbclient-dev \
# 	libreadline-dev \
# 	mariadb-client \
# 	screen"

# COPY addons /tmp/

# RUN \
#  ls -altr /tmp/ && \
#  apt update && \
#  echo "**** install build packages ****" && \
#  apt-get install -y \
#  	--no-install-recommends \
# 	$BUILD_PACKAGES && \
#  apt-get install -y \
#  	--no-install-recommends \
# 	$RUNTIME_PACKAGES && \
#  echo "**** clone EQEmu ****" && \
#  git clone https://github.com/EQEmu/Server.git /eqemu && \
#  cd /eqemu && \
#  mkdir -p build && \
#  cd build && \
#  cmake -DEQEMU_BUILD_LOGIN=ON -DEQEMU_BUILD_LUA=ON -G 'Unix Makefiles' ..



















#  git checkout e0835b4673 && \
#  echo "**** installing Eluna ****" && \
#  git clone https://github.com/ElunaLuaEngine/ElunaTrinityWotlk.git && \
#  cd ElunaTrinityWotlk && \
#  git submodule init && \
#  git submodule update && \
#  echo "**** installing Solocraft ****" && \
#  cd /trinitycore/src/server/scripts/Custom && \
#  mv /tmp/Solocraft.cpp . && \
#  patch -p1 custom_script_loader.cpp < /tmp/solocraft.patch && \
#  echo "**** installing npcbots ****" && \
#  git clone https://bitbucket.org/trickerer/trinity-bots.git /trinity-bots && \
#  mv /trinity-bots/last/NPCBots.patch /trinitycore && \
#  cd /trinitycore && \
#  patch -p1 < NPCBots.patch && \
#  echo "**** building core ****" && \
#  cd /trinitycore && \
#  mkdir build && \
#  cd build && \
#  cmake ../ -DCMAKE_INSTALL_PREFIX=/app/server && \
#  make -j $(nproc) install && \
#  echo "**** cleanup ****" && \
#  rm -rf /trinitycore/build
# #  apt-get purge -y --auto-remove \
# # 	$BUILD_PACKAGES && \
# #  rm -rf \
# # 	/root/.cache \
# # 	/tmp/*

# # copy local files
# COPY root/ /
