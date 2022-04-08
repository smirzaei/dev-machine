FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
  apt install curl zsh vim wget build-essential openssh-server sudo -y && \
  chsh -s $(which zsh)

RUN service ssh start

RUN mkdir -p /root/.ssh && \
  curl https://github.com/smirzaei.keys > /root/.ssh/authorized_keys && \
  chmod 700 /root/.ssh && chmod 644 /root/.ssh/authorized_keys

COPY --from=golang:1.18.0-bullseye /usr/local/go/ /usr/local/go/

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
