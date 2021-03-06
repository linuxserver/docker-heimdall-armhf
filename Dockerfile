FROM lsiobase/alpine.nginx.armhf:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN \
 echo "**** install runtime pacakges ****" && \
 apk add --no-cache \
	curl \
	php7-ctype \
	php7-pdo_sqlite \
	php7-tokenizer \
	tar && \
 echo "**** install heimdall ****" && \
 mkdir -p \
	/var/www/localhost/heimdall && \
 HEIM_VER=$(curl -sX GET "https://api.github.com/repos/linuxserver/Heimdall/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -o \
 /tmp/heimdall.tar.gz -L \
	"https://github.com/linuxserver/Heimdall/archive/${HEIM_VER}.tar.gz" && \
 tar xf \
 /tmp/heimdall.tar.gz -C \
	/var/www/localhost/heimdall --strip-components=1 && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /
