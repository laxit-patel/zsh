# zsh — my Ubuntu terminal setup

My daily-driver terminal environment on Ubuntu (GNOME): **zsh + Oh My Zsh +
Powerlevel10k**, a set of modern CLI tools, a **Catppuccin Mocha** GNOME Terminal
theme, and a couple of GNOME keyboard shortcuts. This repo has the *actual* config
files so it reproduces 1:1 — not an approximation.

## What's inside

| File | What it is |
|------|-----------|
| `zshrc` | My `~/.zshrc` — Oh My Zsh, plugins, aliases, keybindings |
| `p10k.zsh` | My `~/.p10k.zsh` — full Powerlevel10k prompt styling (exact look) |
| `neofetch.conf` | `~/.config/neofetch/config.conf` |
| `gnome-terminal.dconf` | Exact GNOME Terminal profiles (all Catppuccin variants; default = Mocha) |
| `gnome-keybindings.dconf` | GNOME custom shortcuts (Super+T, Print) |
| `vscode-settings.json` | `~/.config/Code/User/settings.json` — cursive Fira Code iScript for keywords/comments/declarations, MesloLGS NF terminal font |
| `REPRODUCE.md` | Step-by-step reproduction guide / agent prompt |
| `install.sh` | One-shot installer that wires it all up |

## Quick start

```bash
git clone https://github.com/laxit-patel/zsh.git
cd zsh
./install.sh
```

Then log out/in (or `chsh -s $(which zsh)` and restart your terminal).

## Highlights

- **Prompt:** Powerlevel10k, font **MesloLGS NF 14**
- **Plugins:** git, laravel, sudo, extract, colored-man-pages, zsh-completions,
  fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting, history-substring-search
- **CLI tools:** `eza` (ls), `bat` (cat), `fd` (find), `fzf`, `zoxide` (`z`)
- **Terminal theme:** Catppuccin Mocha, 8% transparency, block cursor
- **Shortcuts:** `Super`(Windows)+`T` → fullscreen zsh terminal · `Print` → Flameshot

See `REPRODUCE.md` for the full manual walkthrough.

## Restore just the GNOME bits

```bash
dconf load /org/gnome/terminal/                       < gnome-terminal.dconf
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-keybindings.dconf
```
