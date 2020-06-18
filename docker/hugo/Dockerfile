FROM alpine:edge

LABEL version="1.1"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="hugo"
LABEL usage="https://github.com/J-Siu/docker_compose/blob/master/docker/hugo/README.md"

RUN apk update && \
	apk --no-cache add ca-certificates ca-certificates-bundle tzdata \
		git \
		hugo

COPY README.md start.sh /
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
