# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands
- **Install / bootstrap** – Run the shell script that sets up Vim/Neovim and installs plugins.
  ```bash
  bash install.sh
  ```
- **Update plugins** – Refresh all vim‑plug plugins.
  ```bash
  vim +PlugUpdate +qall   # for Vim
  nvim +PlugUpdate +qall  # for Neovim
  ```
- **Open Vim/Neovim** – Start the editor with the current configuration.
  ```bash
  vim      # or nvim
  ```
- **Generate unit tests** – In Vim, the `:GenerateTest` command (provided by `rc/vim-ai.vim`) can create test stubs for a selected code block.
- **Run LSP diagnostics** – Use Neovim’s built‑in LSP client (configured via `lua/nvim_lsp.lua`).
- **Install language servers** – Via Mason: `MasonInstall <server>`.

## High‑Level Architecture
- The repository is a **Vim/Neovim configuration** named *vinux*.
- **Root layout**:
  - `install.sh` – bootstrap script that clones the repo into `~/.vim`, backs up existing configs, installs vim‑plug, and optionally sets up Neovim.
  - `init.lua` – Entry point for Neovim; sources the Vim script `vimrc` located in the same directory.
  - `lua/` – Lua modules for Neovim:
    - `nvim_lsp.lua`: LSP client setup.
    - `mason_setup.lua`: Mason package manager configuration.
    - `copilot_chat_setup.lua`, `aerial_setup.lua`: additional Neovim plugins.
  - `rc/` – Vim script files that configure options, keymaps, plugins, and custom commands.
  - `autoload/te/` – Helper functions used by the Vim configuration (e.g., Git integration, file navigation).
- **Plugin management**: Uses **vim‑plug** (`autoload/plug.vim`). Plugins are declared in `rc/vimrc` and lazily loaded.
- **Modularity**: The config is split into many small files (`rc/*.vim`) for readability and lazy loading. Each file focuses on a specific aspect (e.g., keymaps, LSP, UI).
- **Neovim vs Vim**: The same configuration works for both editors. `init.lua` sources the Vim script, so all Vim settings are shared.
- **Documentation**: The README provides a quick‑install command and links to the wiki for detailed configuration options.

## Useful Notes
- The bootstrap script backs up any existing `~/.vimrc` and `~/.config/nvim/init.vim` before replacing them.
- After running `install.sh`, you may need to run `:PlugInstall` once if the script fails to install plugins automatically.
- The configuration is designed for Linux kernel and U‑Boot development; it expects Vim 7.3+ or the latest Neovim.
- The repo contains no unit tests; testing is performed via Vim’s LSP diagnostics and the `:GenerateTest` command.
