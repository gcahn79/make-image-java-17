FROM alpine:3.16

LABEL name ="GeunChang Ahn"
LABEL email = "gcahn79@w-mall.co.kr"
LABEL version = "jdk-17.0.5+8"
LABEL description = "jdk-17.0.5+8 upgrade"

RUN set -eux && \
    ARCH="$(apk --print-arch)" && \
    case "${ARCH}" in \
      amd64|x86_64) \
        ESUM='cb154396ff3bfb6a9082e3640c564643d31ecae1792fab0956149ed5258ad84b'; \
        BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_x64_alpine-linux_hotspot_17.0.5_8.tar.gz'; \
        ;; \
    \
      aarch64) \
        ESUM='1c26c0e09f1641a666d6740d802beb81e12180abaea07b47c409d30c7f368109'; \
        BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.5_8.tar.gz'; \
        ;; \
    \
      *) \
        echo "Unsupported arch: ${ARCH}"; \
        exit 1; \
        ;; \
    esac; \
    wget -O /tmp/openjdk.tar.gz ${BINARY_URL} && \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c - && \
    mkdir -p "$JAVA_HOME" && \
    tar --extract --file /tmp/openjdk.tar.gz --directory "$JAVA_HOME" --strip-components 1 --no-same-owner && \
    rm /tmp/openjdk.tar.gz;


ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
RUN apk add --no-cache fontconfig libretls musl-locales musl-locales-lang ttf-dejavu tzdata zlib && \
    rm -rf /var/cache/apk/* \
ENV JAVA_VERSION=jdk-17.0.5+8

# RUN echo Verifying install ... && \
    # fileEncoding="$(echo 'System.out.println(System.getProperty("file.encoding"))' | jshell -s -)" && \
    # [ "$fileEncoding" = 'UTF-8' ] && \
    # rm -rf ~/.java     && \
    # echo javac --version && \
    # javac --version && \
    # echo java --version && \
    # java --version && \
    # echo Complete.

CMD ["/usr/local/bin/jshell"]
