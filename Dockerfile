# Serveur web : apache2 + mysql
# Base de donnée : mysql
# Serveur de cache : redis

FROM debian
MAINTAINER Nicolas JOUBERT "njoubert45@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# Mises à jour de la debian + nettoyage automatique
RUN (apt-get update && apt-get upgrade -y -q && apt-get dist-upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)

# Definition des locales
RUN apt-get install -y locales
RUN dpkg-reconfigure locales && locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
RUN echo Europe/Paris | tee /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# Installation des packages de confort
RUN apt-get install -y tree vim htop strace mlocate traceroute zsh tmux expect ipcalc nmap ruby git lsb-release ncurses-term wget apt-utils curl fontconfig python-pip python-setuptools zip unzip

ENV TERM xterm-256color
# Install Zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
 cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
 chsh -s /bin/zsh

# Powerline fonts
RUN mkdir -p $HOME/.fonts $HOME/.config/fontconfig/conf.d
RUN wget -q -P $HOME/.fonts https://github.com/powerline/powerline/raw/master/font/PowerlineSymbols.otf
RUN wget -q -P $HOME/.fonts https://github.com/powerline/fonts/raw/master/Hack/Hack-Regular.ttf
RUN wget -q -P $HOME/.config/fontconfig/conf.d/ https://github.com/powerline/powerline/raw/master/font/10-powerline-symbols.conf
RUN fc-cache -vf $HOME/.fonts/

# Powerline install
RUN wget -q -P /tmp https://github.com/powerline/powerline/archive/master.zip && \
 cd /tmp && \
 unzip -q master.zip && \
 cd /tmp/powerline-master && \
 python setup.py -q install > /dev/null 2>&1

# tmux config
COPY config/.tmux.conf /root/

# Vim airline
RUN git clone https://github.com/bling/vim-airline $HOME/.vim/bundle/vim-airline && \
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

COPY config/.vimrc /root/
