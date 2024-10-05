FROM debian:11

RUN apt update
RUN apt install net-tools man -y

CMD [ "/bin/bash" ]