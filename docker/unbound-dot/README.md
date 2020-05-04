# Unbound - Docker DNS over TLS (DoT) Forwarder

- Base: alpine:latest with unbound from apk
- Small image < 14M.
- Default config use Google and Cloudflare as DoT forwarder

## Usage

### Standard Usage

```txt
docker run -d \
  -p 53:53/udp \
  -p 53:53/tcp \
  jsiu/unbound:latest
```

### Custom Config

Unbound custom config file:

```txt
docker run -d \
  -v <absolute path config file>:/etc/unbound/unbound.conf
  -p 53:53/udp \
  -p 53:53/tcp \
  jsiu/unbound:latest
```

Unbound custom config directory:

```txt
docker run -d \
  -v <absolute path config dir>:/etc/unbound/ \
  -p 53:53/udp \
  -p 53:53/tcp \
  jsiu/unbound:latest
```

## /etc/unbound/unbound.conf

```ini
server:
  username: unbound
  interface: ::0
  interface: 0.0.0.0
  #interface-automatic: yes
  verbosity: 0
  prefer-ip6: yes
  do-ip4: yes
  do-ip6: yes
  do-udp: yes
  do-tcp: yes
  tls-cert-bundle: /etc/ssl/cert.pem
  # Logs
  logfile: ""
  use-syslog: no
  log-replies: no
  log-tag-queryreply: no
  log-servfail: no
  hide-identity: yes
  hide-version: yes
  hide-trustanchor: yes
  # Allow recursive query from anywhere
  access-control: 0.0.0.0/0 allow
  access-control: ::0/0 allow
  # Force cache min. ttl
  #cache-min-ttl: 300
forward-zone:
  name: "."
  forward-tls-upstream: yes
  # Google
  #forward-addr: 2001:4860:4860::8888@853
  #forward-addr: 2001:4860:4860::8844@853
  forward-addr: 8.8.8.8@853
  forward-addr: 8.8.4.4@853
  # Cloudflare DNS
  #forward-addr: 2606:4700:4700::1111@853
  #forward-addr: 2606:4700:4700::1001@853
  forward-addr: 1.1.1.1@853
  forward-addr: 1.0.0.1@853
```
