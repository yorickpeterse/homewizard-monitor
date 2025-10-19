FROM ghcr.io/inko-lang/inko:main AS builder
ADD . /homewizard
WORKDIR /homewizard
RUN inko build --release

FROM ghcr.io/inko-lang/inko:main
COPY --from=builder ["/homewizard/build/release/main", "/usr/bin/homewizard"]
CMD ["/usr/bin/homewizard"]
