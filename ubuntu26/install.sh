#!/usr/bin/env bash
set -euo pipefail

# Versions
NVIM_VERSION="0.12.6"
TMUX_VERSION="3.7c"
LAZYGIT_VERSION="0.66.2"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
OPT_DIR="$HOME/.local/opt"

mkdir -p "$BIN_DIR" "$OPT_DIR"
export PATH="$BIN_DIR:$PATH"

case "$(uname -m)" in
    x86_64|amd64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

log() {
    printf '\n==> %s\n' "$*"
}

download() {
    curl --fail --location --silent --show-error \
        --retry 3 --output "$2" "$1"
}

install_packages() {
    log "Installing system packages"

    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates \
        curl \
        git \
        build-essential \
        gdb \
        ninja-build \
        python3 \
        python3-venv \
        python3-dev \
        python3-pip \
        clangd \
        fzf \
        ripgrep \
        nodejs \
        npm \
        bubblewrap \
        apparmor-profiles \
        apparmor-utils
}

install_neovim() {
    local dest="$OPT_DIR/nvim-$NVIM_VERSION"
    local package="nvim-linux-$ARCH"
    local archive="$WORK_DIR/nvim.tar.gz"

    if [[ ! -x "$dest/bin/nvim" ]]; then
        log "Installing Neovim $NVIM_VERSION"

        download \
            "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${package}.tar.gz" \
            "$archive"

        tar -xzf "$archive" -C "$WORK_DIR"

        rm -rf "$dest"
        mv "$WORK_DIR/$package" "$dest"
    fi

    ln -sfn "$dest/bin/nvim" "$BIN_DIR/nvim"
}

install_tmux() {
    local dest="$OPT_DIR/tmux-$TMUX_VERSION"
    local archive="$WORK_DIR/tmux.tar.gz"

    if [[ ! -x "$dest/tmux" ]]; then
        log "Installing tmux $TMUX_VERSION"

        download \
            "https://github.com/tmux/tmux-builds/releases/download/v${TMUX_VERSION}/tmux-${TMUX_VERSION}-linux-${ARCH}.tar.gz" \
            "$archive"

        mkdir -p "$dest"
        tar -xzf "$archive" -C "$dest" tmux
        chmod +x "$dest/tmux"
    fi

    ln -sfn "$dest/tmux" "$BIN_DIR/tmux"
}

install_lazygit() {
    local dest="$OPT_DIR/lazygit-$LAZYGIT_VERSION"
    local archive="$WORK_DIR/lazygit.tar.gz"

    if [[ ! -x "$dest/lazygit" ]]; then
        log "Installing Lazygit $LAZYGIT_VERSION"

        download \
            "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_linux_${ARCH}.tar.gz" \
            "$archive"

        mkdir -p "$dest"
        tar -xzf "$archive" -C "$dest" lazygit
        chmod +x "$dest/lazygit"
    fi

    ln -sfn "$dest/lazygit" "$BIN_DIR/lazygit"
}

install_rustup() {
    local rustup="$HOME/.cargo/bin/rustup"

    if [[ ! -x "$rustup" ]]; then
        log "Installing rustup"

        download \
            "https://sh.rustup.rs" \
            "$WORK_DIR/rustup-init.sh"

        sh "$WORK_DIR/rustup-init.sh" \
            -y \
            --no-modify-path \
            --default-toolchain stable
    fi

    if ! "$rustup" toolchain list |
        grep -q '^stable-'; then
        log "Installing stable Rust toolchain"
        "$rustup" toolchain install stable
    fi

    # Only select stable when no default is configured.
    if ! "$rustup" default >/dev/null 2>&1; then
        "$rustup" default stable
    fi

    log "Ensuring Rust components are installed"
    "$rustup" component add \
        rustfmt \
        clippy \
        rust-analyzer \
        --toolchain stable
}

install_uv() {
    if [[ -x "$BIN_DIR/uv" ]]; then
        return
    fi

    log "Installing uv"

    download \
        "https://astral.sh/uv/install.sh" \
        "$WORK_DIR/uv-install.sh"

    UV_INSTALL_DIR="$BIN_DIR" \
        sh "$WORK_DIR/uv-install.sh"
}

install_codex() {
    mkdir -p "$HOME/.codex"

    if [[ -x "$BIN_DIR/codex" ]]; then
        log "Codex already installed"
        return
    fi

    log "Installing Codex"

    npm install --global \
        --prefix "$HOME/.local" \
        @openai/codex
}

configure_apparmor() {
    local source="/usr/share/apparmor/extra-profiles/bwrap-userns-restrict"
    local dest="/etc/apparmor.d/bwrap-userns-restrict"

    if [[ ! -f "$source" ]]; then
        echo "Warning: AppArmor profile not found: $source" >&2
        return
    fi

    log "Configuring AppArmor"

    sudo install -m 0644 "$source" "$dest"
    sudo apparmor_parser -r "$dest"
    sudo systemctl reload apparmor.service
}

install_tpm() {
    local dest="$HOME/.tmux/plugins/tpm"

    if [[ -d "$dest/.git" ]]; then
        return
    fi

    log "Installing TPM"

    mkdir -p "$(dirname "$dest")"
    git clone https://github.com/tmux-plugins/tpm "$dest"
}

link_dotfile() {
    local source="$SCRIPT_DIR/$1"
    local dest="$HOME/$2"

    if [[ ! -f "$source" ]]; then
        echo "Missing dotfile: $source" >&2
        return 1
    fi

    mkdir -p "$(dirname "$dest")"

    if [[ -d "$dest" && ! -L "$dest" ]]; then
        echo "Cannot replace directory: $dest" >&2
        return 1
    fi

    if [[ -L "$dest" ]] &&
        [[ "$(readlink "$dest")" == "$source" ]]; then
        return
    fi

    ln -sfn "$source" "$dest"
    echo "Linked $dest"
}

install_dotfiles() {
    log "Installing dotfiles"

    link_dotfile init.lua    .config/nvim/init.lua
    link_dotfile lazygit.yml .config/lazygit/config.yml
    link_dotfile tmux.conf   .tmux.conf
    link_dotfile bashrc      .bashrc
    link_dotfile gitconfig   .gitconfig
}

install_plugins() {
    log "Installing Neovim plugins"
    "$BIN_DIR/nvim" --headless "+Lazy! sync" +qa

    log "Installing tmux plugins"
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"
}

main() {
    install_packages

    install_neovim
    install_tmux
    install_lazygit

    install_rustup
    install_uv
    install_codex

    configure_apparmor
    install_tpm
    install_dotfiles
    install_plugins

    log "Installed versions"

    "$BIN_DIR/nvim" --version | head -n 1
    "$BIN_DIR/tmux" -V
    "$BIN_DIR/lazygit" --version
    python3 --version
    "$HOME/.cargo/bin/rustc" --version
    "$HOME/.cargo/bin/cargo" --version
    "$HOME/.cargo/bin/rustup" --version
    "$BIN_DIR/uv" --version
    "$BIN_DIR/codex" --version

    log "Install complete"
}

main "$@"
