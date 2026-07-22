#!/usr/bin/env bash
# Installer for laxit-patel/zsh — Ubuntu + zsh + Powerlevel10k + Catppuccin.
# Idempotent-ish: safe to re-run. Backs up existing ~/.zshrc and ~/.p10k.zsh.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing apt packages"
sudo apt update
sudo apt install -y zsh git curl wget fzf bat fd-find neofetch flameshot gnome-terminal

echo "==> Installing eza + zoxide into ~/.local/bin"
mkdir -p "$HOME/.local/bin"
if ! command -v eza >/dev/null 2>&1; then
  curl -sL https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz \
    | tar xz -C "$HOME/.local/bin"
fi
command -v zoxide >/dev/null 2>&1 || \
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

echo "==> Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "==> Plugins + Powerlevel10k"
ZC="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone() { [ -d "$2" ] || git clone --depth=1 "$1" "$2"; }
clone https://github.com/romkatv/powerlevel10k          "$ZC/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions    "$ZC/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-completions         "$ZC/plugins/zsh-completions"
clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZC/plugins/zsh-syntax-highlighting"
clone https://github.com/Aloxaf/fzf-tab                    "$ZC/plugins/fzf-tab"

echo "==> MesloLGS Nerd Font"
mkdir -p "$HOME/.local/share/fonts"
for s in "Regular" "Bold" "Italic" "Bold Italic"; do
  f="MesloLGS NF ${s}.ttf"
  [ -f "$HOME/.local/share/fonts/$f" ] || \
    wget -qO "$HOME/.local/share/fonts/$f" \
      "https://github.com/romkatv/powerlevel10k-media/raw/master/${f// /%20}"
done
fc-cache -f >/dev/null 2>&1 || true

echo "==> Config files (backing up existing)"
ts="$(date +%s)"
[ -f "$HOME/.zshrc" ]   && cp "$HOME/.zshrc"   "$HOME/.zshrc.bak.$ts"
[ -f "$HOME/.p10k.zsh" ] && cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak.$ts"
cp "$HERE/zshrc"    "$HOME/.zshrc"
cp "$HERE/p10k.zsh" "$HOME/.p10k.zsh"
mkdir -p "$HOME/.config/neofetch"
cp "$HERE/neofetch.conf" "$HOME/.config/neofetch/config.conf"

echo "==> GNOME Terminal theme + keyboard shortcuts"
if command -v dconf >/dev/null 2>&1; then
  dconf load /org/gnome/terminal/ < "$HERE/gnome-terminal.dconf" || true
  dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$HERE/gnome-keybindings.dconf" || true
fi

echo "==> Set zsh as default shell"
[ "$SHELL" = "$(command -v zsh)" ] || chsh -s "$(command -v zsh)" || \
  echo "   (run 'chsh -s $(command -v zsh)' manually if this failed)"

echo
echo "Done. Log out/in (or restart your terminal). Set the terminal font to"
echo "'MesloLGS NF 14' if it didn't apply, and run 'p10k configure' to re-tune if desired."
