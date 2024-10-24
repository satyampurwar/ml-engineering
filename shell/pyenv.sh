#!/bin/bash

# Install pyenv using the installer
# https://github.com/pyenv/pyenv-installer
curl https://pyenv.run | bash

# Function to append text to a file if it doesn't already exist
append_if_not_exists() {
  local file="$1"
  local text="$2"
  grep -qxF "$text" "$file" || echo "$text" >> "$file"
}

# Set up the shell environment for pyenv
# https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv
configure_pyenv() {
  local config_file="$1"
  append_if_not_exists "$config_file" 'export PYENV_ROOT="$HOME/.pyenv"'
  append_if_not_exists "$config_file" 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
  append_if_not_exists "$config_file" 'eval "$(pyenv init -)"'
}

# Configure pyenv in .bashrc and .profile
configure_pyenv ~/.bashrc
configure_pyenv ~/.profile

# Install necessary system libraries for MLflow
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev zlib1g-dev

# Apply changes by restarting the shell
exec "$SHELL"

# Uninstall instructions can be found here:
# https://github.com/pyenv/pyenv-installer?tab=readme-ov-file#uninstall