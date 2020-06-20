FROM alpine:edge

LABEL version="2.81-r1"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="dnsmasq"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/dnsmasq/README.md"

RUN apk --no-cache add ca-certificates ca-certificates-bundle tzdata
RUN apk --no-cache add dnsmasq=2.81-r1

COPY docker-compose.yml env /

CMD ["dnsmasq","--no-daemon"]
