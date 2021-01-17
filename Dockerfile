FROM mcr.microsoft.com/dotnet/aspnet:5.0
ENV DOTNET_VER=5.0 DOTNET_ARCH=x64

LABEL maintainer=Roxedus
LABEL dotnet_version=${DOTNET_VER} dotnet_arch=${DOTNET_ARCH}

RUN \
    apt-get -y update && apt-get -y install curl dnsutils && \
    cd /tmp && curl -O https://download.technitium.com/dns/DnsServerPortable.tar.gz && \
    mkdir /app && tar -zxvf /tmp/DnsServerPortable.tar.gz -C /app && \
    rm -rf /tmp/DnsServerPortable.tar.gz /var/lib/apt/lists/*

EXPOSE 5380/tcp
EXPOSE 53/tcp
EXPOSE 53/udp
COPY root/ /

VOLUME /app/config

WORKDIR /app
ENTRYPOINT ["dotnet", "DnsServerApp.dll"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD dig +time=3 +tries=1 @localhost google.com || exit 1