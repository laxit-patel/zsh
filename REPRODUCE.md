# My Ubuntu + zsh + Catppuccin Setup — Reproduction Prompt

Paste everything below into Claude Code (or another AI agent / a fresh Ubuntu machine)
to reproduce my terminal environment. It's written as an instruction prompt so an
agent can execute it step by step, but each block is also a runnable shell command.

Target OS: Ubuntu (GNOME desktop, GNOME Terminal). Shell: zsh.

---

## PROMPT (copy from here)

Set up my terminal environment on this Ubuntu machine exactly as specified below.
Install missing packages, clone the plugins, install the font, import the terminal
theme, and register the keyboard shortcuts. Ask before overwriting an existing
~/.zshrc or ~/.p10k.zsh.

### 1. Base packages
```bash
sudo apt update
sudo apt install -y zsh git curl wget fzf bat fd-find neofetch flameshot gnome-terminal
# 'bat' installs as batcat and 'fd' as fdfind on Ubuntu — handled by aliases below.
```

Install tools not in apt (or too old):
```bash
# eza (modern ls)
mkdir -p ~/.local/bin
curl -sL https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar xz -C ~/.local/bin
# zoxide (smart cd)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
# SDKMAN (optional — Java/JVM tooling)
curl -s "https://get.sdkman.io" | bash
# Composer (optional — PHP)
# see https://getcomposer.org/download/
```

### 2. Oh My Zsh + plugins + Powerlevel10k
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ZC=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
git clone https://github.com/romkatv/powerlevel10k          "$ZC/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-autosuggestions    "$ZC/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-completions         "$ZC/plugins/zsh-completions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZC/plugins/zsh-syntax-highlighting"
git clone https://github.com/Aloxaf/fzf-tab                    "$ZC/plugins/fzf-tab"
```

Set in ~/.zshrc:
- `ZSH_THEME="powerlevel10k/powerlevel10k"`
- Plugins list:
  ```
  plugins=(git laravel sudo extract colored-man-pages zsh-completions fzf-tab zsh-autosuggestions zsh-syntax-highlighting history-substring-search)
  ```

Then append the CLI-tools / aliases / keybindings block (see section 6), run
`p10k configure`, and `chsh -s $(which zsh)`.

### 3. Nerd Font (MesloLGS NF — required for Powerlevel10k glyphs)
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
for s in Regular Bold Italic "Bold Italic"; do
  wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${s// /%20}.ttf"
done
fc-cache -f
```

### 4. GNOME Terminal — Catppuccin Mocha (default profile)
Easiest: use the official installer, then set Mocha as default.
```bash
curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/main/install.py | python3 -
```
My default profile settings (font + transparency + cursor) — apply to the Mocha profile:
- Font: `MesloLGS NF 14`, use-system-font off
- background-transparency 8%, cursor block + blink on
- scrollbar hidden

### 5. Keyboard shortcuts (GNOME custom keybindings)
```bash
BASE=/org/gnome/settings-daemon/plugins/media-keys
dconf write $BASE/custom-keybindings \
  "['$BASE/custom-keybindings/custom0/', '$BASE/custom-keybindings/custom1/']"

# Print -> Flameshot screenshot
dconf write $BASE/custom-keybindings/custom0/name    "'flameshot'"
dconf write $BASE/custom-keybindings/custom0/command "'flameshot gui'"
dconf write $BASE/custom-keybindings/custom0/binding "'Print'"

# Super(Windows)+T -> fullscreen zsh terminal
dconf write $BASE/custom-keybindings/custom1/name    "'Fullscreen zsh terminal'"
dconf write $BASE/custom-keybindings/custom1/command "'gnome-terminal --full-screen -- zsh'"
dconf write $BASE/custom-keybindings/custom1/binding "'<Super>t'"
```

### 6. .zshrc tail — CLI tools, aliases, keybindings (append after Oh My Zsh sourcing)
```zsh
export PATH="$PATH:$HOME/.config/composer/vendor/bin"
export PATH="$HOME/.local/bin:$PATH"

# fzf key bindings + completion
if command -v fzf >/dev/null 2>&1; then
  [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
  [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
fi

# zoxide (z / zi)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# eza
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --group-directories-first --git'
  alias la='eza -a --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons'
fi

# bat / fd (Ubuntu names)
command -v batcat >/dev/null 2>&1 && alias bat='batcat' && alias cat='batcat --paging=never'
command -v fdfind >/dev/null 2>&1 && alias fd='fdfind'

# history-substring-search on Up/Down and vi j/k
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# SDKMAN (keep at very end)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
```

### 7. Optional extras
- neofetch: copy `~/.config/neofetch/config.conf`
- gh as git credential helper: `gh auth login` (sets it automatically)
- Autostart: AnyDesk tray, Indicator Stickynotes (personal — skip if not wanted)

## END PROMPT
