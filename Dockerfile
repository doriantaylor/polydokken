FROM ubuntu:latest

ARG UID=1000
ARG GID=1000

# da files
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential curl ca-certificates git sudo \
 && rm -rf /var/lib/apt/lists/*

# replace user, make it able to sudo
RUN userdel -r ubuntu 2>/dev/null || true \
 && groupadd -g $GID polytoken \
 && useradd -m -u $UID -g $GID -G www-data -s /bin/bash polytoken \
 && echo 'polytoken ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/polytoken \
 && chmod 0440 /etc/sudoers.d/polytoken \
    && visudo -cf /etc/sudoers.d/polytoken

# now set up polytoken

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
