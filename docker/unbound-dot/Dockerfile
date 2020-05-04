FROM alpine:latest
RUN apk --no-cache add unbound ca-certificates-cacert
COPY unbound.conf /etc/unbound/
EXPOSE 53
CMD ["unbound","-d"]