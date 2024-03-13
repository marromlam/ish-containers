FROM --platform=linux/amd64 econcz/x86-alpine-glibc:ish-glibc-3.14
# RUN wget https://github.com/cli/cli/releases/download/v2.35.0/gh_2.35.0_linux_386.tar.gz && \
#     tar -xvf gh_2.35.0_linux_386.tar.gz && \
#     mv gh_2.35.0_linux_386/bin/gh /bin \
#     && rm -rf gh_2*






RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/main > /etc/apk/repositories
RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk update
RUN apk upgrade

# RUN apk add bash build-base curl file git gzip libc6-compat ncurses ruby ruby-etc ruby-irb ruby-json sudo bash
# RUN apk add gcompat
RUN apk add bash git

RUN apk add neovim stow
RUN apk add texlive

# Create user
RUN adduser -D marcos
RUN echo 'marcos ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
RUN su -l marcos
RUN cd /home/marcos
RUN echo "x32-linux" > /home/marcos/.machine
RUN mkdir -p /home/marcos/Projects
RUN cd /home/marcos/Projects
RUN git clone https://github.com/marromlam/dotfiles.git
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh


# Install miniconda
RUN mkdir -p /opt
# RUN bash Miniconda3-latest-Linux-x86.sh -b /opt/conda3
# RUN rm Miniconda3-latest-Linux-x86.sh


# RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# RUN PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH

# Export the filesystem
RUN tar czvf /tmp/ish-fs.tar.gz / --exclude=dev/ --exclude=proc/* --exclude=sys/*
