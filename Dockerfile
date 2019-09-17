FROM ubuntu:18.04

ARG PROTOBUF_VERSION=3.9.1
ARG PROTOBUF_C_VERSION=1.3.2

ADD . /opt/ttwatch

RUN apt-get update -y  \
    && apt-get install -y \
        build-essential cmake libssl-dev libcurl4-openssl-dev libusb-1.0-0-dev curl pkg-config file \
    && mkdir /tmp/protobuf \
    && cd /tmp/protobuf \
    && curl -sSL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-cpp-${PROTOBUF_VERSION}.tar.gz -o protobuf.tgz \
    && tar -xzvf protobuf.tgz \
    && cd protobuf-${PROTOBUF_VERSION} \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && ldconfig \
    && mkdir /tmp/protobuf-c \
    && cd /tmp/protobuf-c \
    && curl -sSL https://github.com/protobuf-c/protobuf-c/releases/download/v${PROTOBUF_C_VERSION}/protobuf-c-${PROTOBUF_C_VERSION}.tar.gz -o protobuf-c.tgz \
    && tar -xzvf protobuf-c.tgz \
    && cd protobuf-c-${PROTOBUF_C_VERSION} \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && ldconfig \
    && mkdir /opt/ttwatch/build \
    && cd /opt/ttwatch/build && cmake .. \
    && make \
    && make install \
    && rm -rf /tmp/protobuf /tmp/protobuf-c /opt/ttwatch/build \
    && apt-get remove -y \
            build-essential cmake libssl-dev libcurl4-openssl-dev libusb-1.0-0-dev curl pkg-config file \
    && apt-get install -y libssl1.1 libcurl4 libusb-1.0-0 \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && ln -sf /opt/ttwatch/ttbin2mysports /usr/local/bin/ \
    && chmod a+x /usr/local/bin/ttbin2mysports \
    && ln -sf /opt/ttwatch/docker-entrypoint.sh /usr/local/bin/ \
    && ln -sf /etc/ttwatch.conf /opt/ttwatch/docker-ttwatch.conf

WORKDIR /root
VOLUME /root/ttwatch
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
