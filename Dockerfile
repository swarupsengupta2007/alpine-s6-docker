ARG BASE_OS=alpine
ARG BASE_VERSION=3.16.0
FROM ${BASE_OS}:${BASE_VERSION}
ARG DEF_USER=appuser
ARG DEF_GROUP=appuser
ARG DEF_UID=1000
ARG DEF_GID=1000
ARG DEF_CONFIG=/config
ARG DEF_APP=/app
ARG DEF_DEFAULTS=/defaults
ARG TARGETARCH
ARG TARGETVARIANT
ARG S6VERSION=3.1.0.1
ARG SOFTWARES="shadow,bash"
ENV DEF_USER=${DEF_USER}           \
		DEF_GROUP=${DEF_GROUP}         \
		DEF_UID=${DEF_UID}             \
		DEF_GID=${DEF_GID}             \
		DEF_CONFIG=${DEF_CONFIG}       \
		DEF_APP=${DEF_APP}             \
		DEF_DEFAULTS=${DEF_DEFAULTS} 
RUN BASE_URI="https://github.com/just-containers/s6-overlay/releases/download"                  && \
		apk --no-cache add ${SOFTWARES//,/ }                                                         && \
		mkdir -p ${DEF_CONFIG} ${DEF_APP} ${DEF_DEFAULTS}                                           && \
		groupadd -og ${DEF_GID} ${DEF_GROUP}                                                        && \
		useradd -ou ${DEF_UID} -g ${DEF_GID} -d ${DEF_CONFIG} -s /bin/false ${DEF_USER}             && \
		chown -R ${DEF_USER}:${DEF_GROUP} ${DEF_CONFIG} ${DEF_APP} ${DEF_DEFAULTS}                  && \
		case ${TARGETARCH} in                                                                          \
			arm64) S6ARCH=aarch64; ;;                                                                    \
			arm)                                                                                         \ 
						case $TARGETVARIANT in                                                                 \
								v7) S6ARCH=aarch64; ;;                                                             \
								v6) S6ARCH=arm; ;;                                                                 \
						esac;	                                                                                 \
			;;                                                                                           \
			amd64) S6ARCH=x86_64;  ;;                                                                    \
			386) 	 S6ARCH=i686; 	 ;;                                                                    \
		esac                                                                                        && \
		wget -qO - ${BASE_URI}/v${S6VERSION}/s6-overlay-noarch.tar.xz 		| tar -C / -xpJ	          && \
		wget -qO - ${BASE_URI}/v${S6VERSION}/s6-overlay-${S6ARCH}.tar.xz 	| tar -C / -xpJ           && \
		wget -qO - ${BASE_URI}/v${S6VERSION}/s6-overlay-symlinks-noarch.tar.xz | tar -C / -xpJ      && \
		wget -qO - ${BASE_URI}/v${S6VERSION}/s6-overlay-symlinks-noarch.tar.xz | tar -C / -xpJ

COPY base/ /
VOLUME /config
ENTRYPOINT ["/init"]
