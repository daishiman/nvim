# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Neovim configuration repository using Lua-based configuration with the Lazy.nvim plugin manager. The configuration is modular, with separate files for different aspects of functionality.

## Architecture

### Core Structure
- **Entry Point**: `init.lua` - Initializes Neovim, sets up the leader key, bootstraps lazy.nvim, and loads config modules
- **Configuration**: `lua/config/` - Core Neovim settings (options, keymaps, autocmds)
- **Plugins**: `lua/plugins/` - Modular plugin configurations, each file returns a Lua table for lazy.nvim
- **LSP**: `lua/plugins/lsp/` - Language Server Protocol configurations (init, servers, keymaps)
- **Filetype Settings**: `after/ftplugin/` - Language-specific settings

### Plugin Loading Strategy
- Uses lazy.nvim with lazy loading enabled by default for performance
- Plugins are loaded on-demand based on events, commands, or file types
- Search plugins are modularized in separate files (search-finder, search-motion, search-replace, search-telescope)

## Common Commands

### Plugin Management
```bash
# Open Neovim and manage plugins
nvim +Lazy                    # Open Lazy plugin manager UI
nvim +checkhealth             # Run health checks for all components
nvim +"Lazy sync"             # Update all plugins
```

### Development Tasks
```bash
# Check configuration health
nvim +checkhealth

# Profile startup time
nvim --startuptime startup.log

# Clean install (reset all plugins)
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
nvim +Lazy
```

### LSP and Tool Management
- Use `:Mason` to manage LSP servers and development tools
- Use `:LspInfo` to check active language servers
- Use `:LspLog` to view LSP logs for debugging

## Key Mappings Convention

- **Leader key**: Space (`<leader>`)
- **Local leader**: Backslash (`<localleader>`)
- **Prefix conventions**:
  - `<leader>f` - Find/search operations (fzf-lua)
  - `<leader>g` - Git operations
  - `<leader>s` - Window splits
  - `<leader>t` - Tabs and toggles
  - `<leader>l` - LSP operations
  - `<leader>c` - Code actions
  - `<leader>d` - Debug/diagnostics

## Adding New Features

### Adding a Plugin
1. Create a new file in `lua/plugins/` or add to existing category file
2. Return a table with plugin spec following lazy.nvim format
3. Include dependencies, lazy loading conditions, and configuration

### Adding LSP Support
1. Add server to `mason_lspconfig.ensure_installed` in `lua/plugins/lsp/init.lua`
2. Configure server-specific settings in `lua/plugins/lsp/servers.lua`
3. Add any language-specific keymaps in `lua/plugins/lsp/keymaps.lua`

### Adding Filetype Settings
1. Create a new file in `after/ftplugin/{filetype}.lua`
2. Use `vim.opt_local` for buffer-local settings

## Performance Considerations

- All plugins use lazy loading where possible
- Disabled unused built-in plugins in performance settings
- Uses `vim.loader.enable()` for faster Lua module loading
- Cache enabled in lazy.nvim for faster startup

## Debugging Issues

1. Check `:messages` for error messages
2. Run `:checkhealth` to diagnose configuration issues
3. Check specific plugin issues with `:Lazy profile` for startup times
4. LSP issues: Check `:LspInfo` and `:LspLog`
5. For plugin conflicts, temporarily disable plugins in their respective files

## Important Files to Understand

- `init.lua` - Entry point and plugin manager setup
- `lua/config/options.lua` - Editor behavior settings
- `lua/config/keymaps.lua` - Global key mappings
- `lua/plugins/lsp/servers.lua` - Language-specific LSP configurations
- `lua/plugins/completion.lua` - Auto-completion setup
- `lua/plugins/search-init.lua` - Search plugin integration point