vim.opt.compatible = false
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.mouse = "v"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.ttyfast = true
vim.opt.mouse = "a"
vim.syntax = "on"
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,list:full"
vim.opt.swapfile = false
vim.opt.winborder = "rounded"
vim.opt.cc = 80
vim.opt.backupdir = "~/.cache/vim"
--[=====[
vim.opt.filetype.plugin.indent = "on"
vim.filetype.plugin = "on"
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
" set cursorline              " highlight current cursorline
" set spell                 " enable spell check (may need to download language package)

hi NonText ctermbg=none guibg=NONE
hi Normal guibg=NONE ctermbg=NONE
hi NormalNC guibg=NONE ctermbg=NONE
hi SignColumn ctermbg=NONE ctermfg=NONE guibg=NONE

hi Pmenu ctermbg=NONE ctermfg=NONE guibg=NONE
hi FloatBorder ctermbg=NONE ctermfg=NONE guibg=NONE
hi NormalFloat ctermbg=NONE ctermfg=NONE guibg=NONE
hi TabLine ctermbg=None ctermfg=None guibg=None
--]=====]
