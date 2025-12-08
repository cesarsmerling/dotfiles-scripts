# Linux Installation

## Linux distro - Pop_Os 22.1

I run into some problems with Arch Linux to install the hardware for wifi so I not installed.

Then I tried LinuxMint 22 that works great but also run into problems with the bluetooth that not detect the hardware.

So I tried **PopOS 22.1** that has more support with hardware. The only thing is that I needed to **run the update that shown on the pop up on first start** and then the bluetooth start to work correctly.

Run an udpate and upgrade with:

```bash
sudo apt update && sudo apt upgrade
```

## Utilities

```bash
sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
```

## Terminal Kitty

To install the kitty terminal run:

```bash
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

Then to create a desktop shortcut so can launcher can find it do:

```bash
mkdir ~/.local/bin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
echo 'kitty.desktop' > ~/.config/xdg-terminals.list
```

Run kitty and execute inside

```bash
kitten theme
```

Inside select Catpuccin Mocha, Everforest or Afterglow as theme, and create a new config file

Then copy the content for this config file

```bash
include Catppuccin-Mocha.conf

font_family Hurmit Nerd Font
bold_font auto
italic_font auto
bold_italic_font auto

font_size 12.0

enable_ligatures always
adjust_line_height 110%
adjust_column_width 110%

shell zsh
```

## Terminal Alacritty (better use Kitty)

I installed **Alacritty** from the PopOs Shop, the version is 0.12.2. Uses the yml configuration, in newest version use the toml config. **The config is set in ~/.config/alacritty/alacritty.yml**

[Alacritty Config file](https://www.notion.so/Alacritty-Config-file-1bc33d45c4628047a90af4a158425bf3?pvs=21)

## Zsh

Run on terminal:

```bash
sudo apt update && sudo apt install zsh
```

Then

```bash
chsh -s $(which zsh)
```

Execute

```bash
zsh
```

and create the .zshrc config with the default values (option 2, or an empty one if you desire so)

Add to allacrity.yml config the following so the terminal starts with zsh

Check where zsh is installed, by default is /usr/bin/zsh

```bash
which zsh
```

Add to the .yml file the follwing:

```bash
shell:
  program: *zsh folder output from which command*
```

## Oh My Zsh

Install with:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Plugins to add:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Into .zshrc file add in the plugin line:

```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

## Docker

Installed docker following from the apt with this commands:

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

Maybe when running a docker command, the process don’t have permissions, to add the corresponding permissins:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

## Docker Desktop

Download the docker-desktop.deb from the official web page and run:

```bash
sudo apt-get install ./docker-desktop-amd64.deb
```

## Starship

Follow the installation guide from the web page

Run to install:

```bash
curl -sS https://starship.rs/install.sh | sh
```

Add to ~/,zshrc file at the end:

```bash
eval "$(starship init zsh)"
```

And run

```bash
source ~/.zshrc
```

Si starship no inicia ejecuta los siguientes commandos en la terminal y luego reiniciala:

```bash
set +x
rm ~/.zcompdump*
compinit
```

Y remueve todos los comentarios del la configuracion de zshrc y comenta la linea promp adam1

## Starship theme

```bash
starship preset gruvbox-rainbow -o ~/.config/starship.toml
```

Or copy from typecraft the following:

[Typecraft starship config](https://www.notion.so/Typecraft-starship-config-1bc33d45c462801f8533c8bb35f19ccb?pvs=21)

## Exa (ls with steroids)

Install via cargo

```bash
cargo install exa
```

Crete an alias in zshrc

```bash
alias ls='exa -a -l --color=always --icons --group-directories-first'
```

## Colorls (not good colors, use exa instead)

Install dependencies:

```bash
 sudo apt install ruby ruby-dev ruby-colorize
```

Install with gem:

```bash
sudo gem install colorls
```

Add to the zshrc file

```bash
source $(dirname $(gem which colorls))/tab_complete.sh
```

And add the alias

```bash
alias lc='colorls -lA --sd'
```

## Yazi - terminal file manager

Install with cargo, so rust need to me installed first:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
```

Install last version with:

```bash
cargo install --locked --git https://github.com/sxyazi/yazi.git yazi-fm yazi-cli
```

## LazyGit

Install running:

```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm -rf lazygit lazygit.tar.gz
```

## PNPM

```bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

## FNM (Node version manager)

```bash
curl -fsSL https://fnm.vercel.app/install | bash
```

## Git config for GitHub (Merlin Apps)

Create a ssh key to copy in the settings of git hub

```bash
ssh-keygen -t ed25519 -C "tu-email@ejemplo.com"
```

Set name and email on the global config for git

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu-email@ejemplo.com"
```

## Neovim / Lazyvim

- Install

curl -LO <https://github.com/neovim/neovim/releases/latest/download/nvim.appimage>
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

- Make a backup of your current Neovim files:

    ```
    # required
    mv ~/.config/nvim{,.bak}
    
    # optional but recommended
    mv ~/.local/share/nvim{,.bak}
    mv ~/.local/state/nvim{,.bak}
    mv ~/.cache/nvim{,.bak}
    
    ```

-
- Clone the starter

    ```
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    
    ```

- Remove the `.git` folder, so you can add it to your own repo later

    ```
    rm -rf ~/.config/nvim/.git
    
    ```

- Start Neovim!

### Custom config

Removing the tabs for the buffers

Create file config/nvim/plugins/ui.lua and add:

```bash
return {
  {
    "akinsho/bufferline.nvim",
    enabled = false, -- Deactive the tabs - bufferline
  },
}
```

## fd-find

Install

```bash
sudo apt install fd-find
```

Add a link because the commands is called fdfind

```bash
ln -s $(which fdfind) ~/.local/bin/fd
```

Now it can be used as fd

(Not used, there is a configuration that can be used with fzf)

<https://github.com/Sin-cy/dotfiles/blob/main/zsh/.zshrc>

```bash
# NOTE: FZF
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "  
```

## bat

Install, is a replace of cat but with better format

```bash
sudo apt install bat
```

Add an alias to .zshrc

```bash
alias bat='batcat'
```

## FZF

```bash
sudo apt install fzf 
```

Crate alias for preview and preview with open on neovim

```bash
#fzf alias
alias fzfp='fzf -m --preview="batcat --color=always -n --line-range :500 {}"'
alias fzfn='nvim $(fzfp)'
```

## fzf git

Install in the repo (download the script)

Put the script under ~/scrtips/fzf-git.sh/fzf-git.sh

Add this line to the zshrc config

```bash
source ~/scripts/fzf-git.sh/fzf-git.sh
```

**List of bindings**
CTRL-G CTRL-F for Files
CTRL-G CTRL-B for Branches
CTRL-G CTRL-T for Tags
CTRL-G CTRL-R for Remotes
CTRL-G CTRL-H for commit Hashes
CTRL-G CTRL-S for Stashes
CTRL-G CTRL-L for reflogs
CTRL-G CTRL-W for Worktrees
CTRL-G CTRL-E for Each ref (git for-each-ref)

# Gnome extensions

- Tactile
- Just perfection
- Space bar

# Keybindings

In terminal

In git repo folder:

CTRL-G CTRL-B for Branches

CTRL-G CTRL-R for Remotes

CTRL-G CTRL-L for reflogs

CTRL-G CTRL-H for commit Hashes

CTRL-G CTRL-S for Stashes

In desktop

Alt + T  (resize current windows with Tactile)

Super+T (open terminal)

Super+B (open browser)

Super 1 to 6 (switch workspace)

Super + Shift + Q (alt tab en windows, switch apps)

Super + Shift + W (switch between app witouth preview)

Super + Shift + E (switch between several windows of the current app selected, good for switching between terminals)

Spanish character on linux en la terminal:

- **á** → `Ctrl + Shift + U`, luego `00E1`, luego `Enter`
- **é** → `Ctrl + Shift + U`, luego `00E9`, luego `Enter`
- **í** → `Ctrl + Shift + U`, luego `00ED`, luego `Enter`
- **ó** → `Ctrl + Shift + U`, luego `00F3`, luego `Enter`
- **ú** → `Ctrl + Shift + U`, luego `00FA`, luego `Enter`
- **ñ** → `Ctrl + Shift + U`, luego `00F1`, luego `Enter`
- **ü** → `Ctrl + Shift + U`, luego `00FC`, luego `Enter`
- **¿** → `Ctrl + Shift + U`, luego `00BF`, luego `Enter`
- **¡** → `Ctrl + Shift + U`, luego `00A1`, luego `Enter`

### Installed gnome-tweaks

Tactile
Space-bar
Just perfection
Switcher
Vitals
(switcher and just perfection where disabled)
