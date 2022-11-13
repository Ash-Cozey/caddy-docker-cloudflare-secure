FROM caddy:2.6-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-dynamicdns \
    --with github.com/greenpau/caddy-security \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin/v2

RUN --mount=type=secret,id=CF_ZONE_TOKEN

FROM caddy:2.6

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "--envfile", "/run/secrets/CF_ZONE_TOKEN", "docker-proxy"]
