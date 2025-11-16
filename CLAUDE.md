# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a documentation and reference repository for Linux system configuration, primarily focused on Pop!_OS 22.1 setup. It contains installation guides and configuration references rather than executable scripts.

## Repository Structure

- `linux-install-notion.md` - Comprehensive setup guide for Pop!_OS 22.1 including:
  - System utilities installation
  - Terminal setup (Kitty/Alacritty)
  - Shell configuration (Zsh, Oh My Zsh, Starship)
  - Development tools (Docker, Node.js tooling, Neovim/LazyVim)
  - CLI utilities (yazi, lazygit, fzf, bat, exa, fd-find)
  - Git/GitHub configuration
  - Gnome extensions and keybindings

## Key Installation Commands Referenced

The documentation includes installation procedures for:
- **System utilities**: `sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick`
- **Terminal**: Kitty (preferred) or Alacritty
- **Shell**: Zsh with Oh My Zsh, plugins (zsh-autosuggestions, zsh-syntax-highlighting)
- **Prompt**: Starship with gruvbox-rainbow preset
- **Node.js**: pnpm and fnm (Fast Node Manager)
- **Rust tools**: exa, yazi (via cargo)
- **Git UI**: lazygit

## Development Philosophy

This repository serves as a personal reference for setting up a consistent development environment. When adding new content:
- Focus on Pop!_OS 22.1 compatibility
- Include complete installation commands with all dependencies
- Document configuration file locations and contents
- Note any troubleshooting steps or gotchas encountered
- Maintain separation between different tool categories (terminal, shell, development tools, etc.)
- under the folder scripts we will have the scripts in bash. We will separate each command or each application mentioned in the linux-install-notion as a separated script file with comments for reference. There will be two types of scripts under the corresponding folder 'ubuntu' for apt installation (ubuntu) and 'arch' for Arch linux system. Then will be a main script files that run everything. You will guide me to create this files and then document the test cases and errors
- dont run the docker environment, let me test it by my self manually