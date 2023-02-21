FROM alpine:3

RUN apk add --update netcat-openbsd fish curl jq
ADD monitor.fish /monitor.fish
CMD ["/usr/bin/fish", "monitor.fish"]
