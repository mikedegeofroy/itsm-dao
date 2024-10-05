FROM debian:11

RUN apt update
RUN apt install net-tools

CMD [ "/bin/bash" ]