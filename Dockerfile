FROM --platform=linux/amd64 econcz/x86-alpine-glibc:ish-glibc-latest
RUN cd /home
RUN wget https://github.com/cli/cli/releases/download/v2.35.0/gh_2.35.0_linux_386.tar.gz && tar -xvf gh_2.35.0_linux_386.tar.gz && mv gh_2.35.0_linux_386/bin/gh /bin && rm -rf gh_2*
RUN tar czvf /tmp/ish-fs.tar.gz / --exclude=dev/ --exclude=proc/* --exclude=sys/*
