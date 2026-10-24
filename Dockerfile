FROM ubuntu:latest

ARG UID=1000
ARG GID=1000

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential curl ca-certificates git \
 && rm -rf /var/lib/apt/lists/*

# ubuntu:24.04 ships a default "ubuntu" user at 1000; remove it to avoid clashes
RUN userdel -r ubuntu 2>/dev/null || true \
 && groupadd -g $GID polytoken \
 && useradd -m -u $UID -g $GID -G www-data -s /bin/bash polytoken

USER polytoken
WORKDIR /home/polytoken

RUN curl -fsS https://get.polytoken.dev | bash
RUN mkdir -p ~/.local/share/bash-completion/completions \
 && ~/.local/bin/polytoken completions bash \
      > ~/.local/share/bash-completion/completions/polytoken

# mount point for the host-side work directory
RUN mkdir -p /home/polytoken/work
WORKDIR /home/polytoken/work

CMD ["bash"]
