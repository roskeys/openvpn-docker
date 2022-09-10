FROM alpine:latest

ENV APP_NAME openvpn
ENV APP_INSTALL_PATH /${APP_NAME}
ENV APP_PERSIST_DIR /${APP_NAME}/keys
ENV NET_ADAPTER eth0
ENV HOST_ADDR localhost
ENV HOST_TUN_PORT 1194
ENV HOST_CONF_PORT 80

RUN apk add --no-cache openvpn easy-rsa bash netcat-openbsd zip dumb-init iptables && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/bin/easyrsa

WORKDIR ${APP_INSTALL_PATH}

COPY scripts .
COPY config ./config
COPY VERSION ./config

RUN mkdir -p ${APP_PERSIST_DIR} && \
    mkdir -p /${APP_NAME}/data && \
    cd ${APP_PERSIST_DIR} && \
    easyrsa init-pki && \
    easyrsa gen-dh && \
    cp pki/dh.pem /etc/openvpn && \
    cd ${APP_INSTALL_PATH} && \
    cp config/server.conf /etc/openvpn/server.conf


EXPOSE 1194/udp
EXPOSE 8080/tcp

VOLUME [ "/openvpn" ]

ENTRYPOINT [ "dumb-init", "./start.sh" ]
CMD [ "" ]
