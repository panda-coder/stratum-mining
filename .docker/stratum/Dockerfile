FROM rust:alpine AS base

WORKDIR /stratum

RUN apk add --no-cache musl-dev git

RUN git clone https://github.com/stratum-mining/stratum.git

RUN cd stratum/roles/jd-client/ && cargo build --release
RUN cd stratum/roles/pool/ && cargo build --release
RUN cd stratum/roles/jd-server/ && cargo build --release
RUN cd stratum/roles/translator/ && cargo build --release
RUN cd stratum/roles/test-utils/mining-device/ && cargo build --release



FROM alpine:latest AS jdc

WORKDIR /jdc


COPY --from=base /stratum/stratum/roles/target/release/jd_client /jdc
COPY --from=base /stratum/stratum/roles/jd-client/config-examples/ /jdc

EXPOSE 34265

ENTRYPOINT [ "./jd_client", "-c", "cfg/example.toml" ]


FROM alpine:latest AS pool

WORKDIR /pool

COPY --from=base /stratum/stratum/roles/target/release/pool_sv2 /pool
COPY --from=base /stratum/stratum/roles/pool/config-examples/ /pool

EXPOSE 34254

ENTRYPOINT [ "./pool_sv2", "-c", "cfg/example.toml" ]


FROM alpine:latest AS jds

WORKDIR /jds


COPY --from=base /stratum/stratum/roles/target/release/ /jds
COPY --from=base /stratum/stratum/roles/jd-server/config-examples/ /jds

ENTRYPOINT [ "./jd_server", "-c", "cfg/example.toml" ]



FROM debian:bookworm-slim AS tproxy

WORKDIR /tproxy


COPY --from=base /stratum/stratum/roles/target/release/translator_sv2 /tproxy
COPY --from=base /stratum/stratum/roles/translator/config-examples/ /tproxy

ENTRYPOINT [ "./translator_sv2", "-c", "cfg/example.toml" ]


FROM debian:bookworm-slim AS miningdevice

WORKDIR /mining-device


COPY --from=base /stratum/stratum/roles/target/release/mining_device /mining-device


ENTRYPOINT [ "./mining_device", "--address-pool", "10.10.0.5:34254" ]