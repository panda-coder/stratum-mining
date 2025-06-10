FROM alpine:latest AS stage

WORKDIR /app

RUN wget https://github.com/Sjors/bitcoin/releases/download/sv2-tp-0.1.17/bitcoin-sv2-tp-0.1.17-x86_64-linux-gnu.tar.gz

RUN tar -zxvf bitcoin-sv2-tp-0.1.17-x86_64-linux-gnu.tar.gz


FROM debian:bookworm-slim

WORKDIR /app

COPY --from=stage /app/bitcoin-sv2-tp-0.1.17/ /app/bitcoin-sv2 

CMD [ "/app/bitcoin-sv2/bin/bitcoind", "-regtest", "-sv2", "-sv2port=8442", "-debug=sv2" ]