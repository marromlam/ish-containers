FROM --platform=linux/amd64 alpinish:0.0


ENV LANG=C.UTF-8
ARG MATPLOTLIB_VERSION=3.1.2




# RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/main > /etc/apk/repositories
# RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

# RUN apk update && apk upgrade


# RUN apk del --rdepends python3 # zlib -f 
# Build dependencies
RUN cp /etc/apk/repositories /etc/apk/repositories.bak
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/v3.13/main/' >> /etc/apk/repositories
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/v3.13/community/' >> /etc/apk/repositories
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/v3.14/main/' >> /etc/apk/repositories
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/v3.14/community/' >> /etc/apk/repositories
# RUN echo 'https://dl-cdn.alpinelinux.org/alpine/edge/community/' >> /etc/apk/repositories
RUN apk update

# -------------------------------------------------------------------------------
# Install python, pip, numpy and matplotlib {{{
# -------------------------------------------------------------------------------
RUN apk add python3\<3.9 curl
RUN curl -O https://bootstrap.pypa.io/get-pip.py\
    && python3 get-pip.py\
    && rm get-pip.py \
    && pip install pip\<21 \
    && ln -fs /usr/include/locale.h /usr/include/xlocale.h \
    && ln -fs /usr/bin/python3 /usr/local/bin/python \
    && ln -fs /usr/bin/pip3 /usr/local/bin/pip
    # && pip3 install -v --no-cache-dir --upgrade pip


RUN apk add python3-dev libgfortran build-base libstdc++ py3-setuptools \
            libpng libpng-dev py3-kiwisolver freetype freetype-dev \
            libtiff-dev libtiffxx tiff tiff-dev --force-broken-world && \
    pip3 install numpy==1.19.5 && \
    pip3 install matplotlib==$MATPLOTLIB_VERSION && \
    # apk del --purge build-base libgfortran libpng-dev freetype-dev \
    #                 python3-dev && \
    #                 # py-numpy-dev && \
    rm -vrf /var/cache/apk/*

# remove build dependencies
RUN apk del libtiff-dev libtiffxx tiff tiff-dev freetype-dev libpng-dev

# }}}
# -------------------------------------------------------------------------------


RUN apk add texlive

# -------------------------------------------------------------------------------
# Utils and tools {{{
# -------------------------------------------------------------------------------

RUN apk add exa bat ripgrep fzf stow zsh openssh git tmux curl unzip bash
RUN apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
            viu

# }}}
# -------------------------------------------------------------------------------

# ---- RUN apk add tmux git bash zsh curl stow unzip openssh
# ----     # build-base cmake coreutils gettext-tiny-dev \
# ----     # libtool \
# ----     # pkgconf \
# ----     # coreutils \
# ----     # bash zsh \
# ----     # git \
# ----     # openssh \
# ----     # tmux \
# ----     # curl stow unzip
# ---- 
# ---- # RUN apk add bash build-base curl file git gzip libc6-compat ncurses ruby ruby-etc ruby-irb ruby-json sudo bash
# ---- # RUN apk add gcompat
# ---- 
# ---- # RUN apk add texlive
# ---- 

# -------------------------------------------------------------------------------
# Install python/pip {{{
# -------------------------------------------------------------------------------

# ENV PYTHONUNBUFFERED=1
# RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
# RUN python3 -m ensurepip
# RUN pip3 install --no-cache --upgrade pip setuptools
# RUN pip3 install yt-dlp

# }}}
# -------------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# Install neovim {{{
# -------------------------------------------------------------------------------

RUN apk add build-base cmake coreutils curl unzip gettext-tiny-dev
RUN cd /tmp && \
    git clone --depth 1 --branch v0.10.0 https://github.com/neovim/neovim.git && \
    cd neovim && \
    rm -rf .deps && make deps -j4 && \
    make -j4 install CMAKE_BUILD_TYPE=Release

# }}}
# -------------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# Install miniconda {{{
# -------------------------------------------------------------------------------

# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh
# RUN mkdir -p /opt
# RUN bash Miniconda3-latest-Linux-x86.sh -b /opt/conda3
# RUN rm Miniconda3-latest-Linux-x86.sh

# }}}
# -------------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# Go and go utils {{{
# -------------------------------------------------------------------------------

ENV GOMAXPROCS=1
ENV CGO_ENABLED=1
ENV GOOS=linux
ENV GOARCH=386

# RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/main > /etc/apk/repositories
# RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
# RUN apk update
# RUN apk add go
#
# RUN git clone --depth=1 https://github.com/cli/cli.git gh-cli
# RUN cd gh-cli && make install prefix=/opt/local/bin && cd ..

RUN cd /tmp && \
    wget https://github.com/cli/cli/releases/download/v2.35.0/gh_2.35.0_linux_386.tar.gz && \
    tar -xf gh_2.35.0_linux_386.tar.gz && \
    mv gh_2.35.0_linux_386/bin/gh /opt/local/bin

# }}}
# -------------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# Create user {{{
# -------------------------------------------------------------------------------

RUN apk add sudo; \
    adduser -h /home/marcos -s /bin/zsh -G wheel -D marcos; \
    echo "marcos:asdf" | chpasswd; \
    echo 'marcos ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

RUN    mkdir -p /opt/local/bin \
    && mkdir -p /home/marcos/Projects/personal \
    && mkdir -p /home/marcos/Downloads \
    && mkdir -p /home/marcos/Documents \
    && mkdir -p /home/marcos/.config/tmux \
    && echo "x32-linux" > /home/marcos/.machine \
    && echo "echo 'iSH Alpine'" >> /home/marcos/.zshrc \
    && echo "source /home/marcos/.sh.local" >> /home/marcos/.zshrc
    # && echo "sudo rm -rf /dev/null && sudo touch /dev/null" >> /home/marcos/.zshrc \

# Clone dotfiles
RUN    cd /home/marcos/Projects/personal \
    && git clone https://github.com/marromlam/dotfiles.git \
    && mkdir -p /home/marcos/.config/tmux \
    && ln -sf /home/marcos/Projects/dotfiles/files/.config/tmux/tmux.conf /home/marcos/.config/tmux \
    && ln -sf /home/marcos/Projects/dotfiles/files/.config/tmux/theme.conf /home/marcos/.config/tmux

# Adding tools
ADD bin /opt/local/bin
ADD nvim /home/marcos/.config/nvim
ADD extra /opt/loca/extra


# }}}
# -------------------------------------------------------------------------------


# apk-tools-zsh-completion

# -------------------------------------------------------------------------------
# Export the filesystem {{{
# -------------------------------------------------------------------------------

RUN echo "su -l marcos" >> /etc/profile
RUN su -l marcos
# USER marcos
# RUN tar cvzf /tmp/ish-fs.tar.gz / # --exclude=dev/ --exclude=proc/* --exclude=sys/*
RUN cp /etc/apk/repositories.bak /etc/apk/repositories
RUN rm -rf /root/.cache
RUN tar cvzf /tmp/ish-fs.tar.gz / --exclude=sys/* --exclude=proc/* --exclude=dev/* --exclude=tmp/* 

# }}}
# -------------------------------------------------------------------------------








# TMP # Install python/pip
# TMP ENV PYTHONUNBUFFERED=1
# TMP RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
# TMP RUN python3 -m ensurepip
# TMP RUN pip3 install --no-cache --upgrade pip setuptools











# vim: fdm=marker
