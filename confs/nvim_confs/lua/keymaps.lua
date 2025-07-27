vim.g.mapleader = " "
vim.keymap.set('n', '<Leader>w', '<cmd>echo "Example 1"<cr>')
vim.keymap.set({ 'n', 'v' }, '<C-v>', '"+p')
vim.keymap.set({ 'n', 'v' }, '<C-x>', '"+d')
vim.keymap.set({ 'n', 'v' }, '<C-c>', '"+y')
