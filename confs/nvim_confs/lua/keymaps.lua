vim.g.mapleader = " "
vim.keymap.set('n', '<Leader>w', '<cmd>echo "Example 1"<cr>')
vim.keymap.set({ 'n', 'v', 'i' }, '<C-v>', '"+p')
vim.keymap.set({ 'n', 'v', 'i' }, '<C-x>', '"+d')
vim.keymap.set({ 'n', 'v', 'i' }, '<C-c>', '"+y')
