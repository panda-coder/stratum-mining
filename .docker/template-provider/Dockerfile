FROM alpine:latest AS stage

WORKDIR /app

RUN wget https://github.com/Sjors/bitcoin/releases/download/sv2-tp-0.1.17/bitcoin-sv2-tp-0.1.17-x86_64-linux-gnu.tar.gz

RUN tar -zxvf bitcoin-sv2-tp-0.1.17-x86_64-linux-gnu.tar.gz


FROM debian:bookworm-slim

WORKDIR /app

COPY --from=stage /app/bitcoin-sv2-tp-0.1.17/ /app/bitcoin-sv2 
COPY ./start.sh /app/start.sh

EXPOSE 18443


CMD [ "./start.sh" ]