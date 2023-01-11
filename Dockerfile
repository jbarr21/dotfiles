FROM ubuntu:20.04

# Install dependencies
RUN apt-get update
RUN apt-get install -y build-essential file zsh git sudo ruby curl wget vim tmux language-pack-en

# Install latest nvim deps
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ninja-build gettext libtool autoconf automake cmake g++ pkg-config unzip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y cmake libtool-bin

# Create a test user
RUN useradd -ms /bin/bash user && \
        echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
        chmod 0440 /etc/sudoers.d/user

USER user:user

WORKDIR /home/user
RUN touch .bash_profile
RUN touch .zshrc

RUN mkdir -p code

# Build latest nvim from source
RUN git clone https://github.com/neovim/neovim.git --branch v0.8.2 --single-branch /home/user/neovim
RUN cd /home/user/neovim && make CMAKE_BUILD_TYPE=Release -C /home/user/neovim && sudo make install -C /home/user/neovim

CMD ["/usr/bin/zsh"]
