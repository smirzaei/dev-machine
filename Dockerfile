FROM ubuntu:latest

ENV LC_CTYPE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM xterm
ENV ZSH_THEME soroush

RUN apt-get update && \
  apt-get install git curl zsh vim wget build-essential openssh-server sudo -y && \
  chsh -s $(which zsh)

# Install oh my zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true && \
  mkdir -p ~/.oh-my-zsh/themes && \
  curl https://raw.githubusercontent.com/smirzaei/dotfiles/master/.oh-my-zsh/themes/soroush.zsh-theme > ~/.oh-my-zsh/themes/soroush.zsh-theme

RUN service ssh start

RUN mkdir -p /root/.ssh && \
  curl https://github.com/smirzaei.keys > /root/.ssh/authorized_keys && \
  chmod 700 /root/.ssh && chmod 644 /root/.ssh/authorized_keys

# Installing the Go compiler
COPY --from=golang:1.18.0-bullseye /usr/local/go/ /usr/local/go/

RUN echo "export PATH=\$PATH:/usr/local/go/bin" >> /root/.zshrc

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
