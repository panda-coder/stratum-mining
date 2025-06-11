FROM alpine:latest AS stage

WORKDIR /cpuminer

COPY pooler-cpuminer-2.5.1-linux-x86_64.tar.gz /cpuminer

RUN tar -zxvf pooler-cpuminer-2.5.1-linux-x86_64.tar.gz


FROM debian:bookworm-slim AS cpuminer

WORKDIR /cpuminer

COPY --from=stage  /cpuminer/minerd /cpuminer


ENTRYPOINT [ "./minerd", "-a" ,"sha256d", "-o", "stratum+tcp://10.10.0.7:34255", "-q", "-D", "-P" ]

