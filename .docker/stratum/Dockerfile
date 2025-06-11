FROM rust:alpine AS base

WORKDIR /stratum

RUN apk add --no-cache musl-dev git

RUN git clone https://github.com/stratum-mining/stratum.git

RUN cd stratum/roles/jd-client/ && cargo build --release
RUN cd stratum/roles/pool/ && cargo build --release
RUN cd stratum/roles/jd-server/ && cargo build --release



FROM alpine:latest AS jdc

WORKDIR /jdc


COPY --from=base /stratum/stratum/roles/target/release/jd_client /jdc
COPY --from=base /stratum/stratum/roles/jd-client/config-examples/ /jdc

ENTRYPOINT [ "./jd_client", "-c", "cfg/example.toml" ]


FROM alpine:latest AS pool

WORKDIR /pool


COPY --from=base /stratum/stratum/roles/target/release/pool_sv2 /pool
COPY --from=base /stratum/stratum/roles/pool/config-examples/ /pool

ENTRYPOINT [ "./pool_sv2", "-c", "cfg/example.toml" ]


FROM alpine:latest AS jds

WORKDIR /jds


COPY --from=base /stratum/stratum/roles/target/release/ /jds
COPY --from=base /stratum/stratum/roles/jd-server/config-examples/ /jds

ENTRYPOINT [ "./jd_server", "-c", "cfg/example.toml" ]