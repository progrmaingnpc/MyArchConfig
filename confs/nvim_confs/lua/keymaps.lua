vim.g.mapleader = " "
vim.keymap.set('n', '<Leader>w', '<cmd>echo "Example 1"<cr>') -- Abstract, pls ignore this
--[=====[ Copy, paste and cut keymaps --]=====]
-- Paste
vim.keymap.set({ 'n', 'v' }, '<C-v>', '"+p')
-- Cut
vim.keymap.set({ 'n', 'v' }, '<C-x>', '"+d')
-- Copy
vim.keymap.set({ 'n', 'v' }, '<C-c>', '"+y')

--[=====[  Multicursor --]=====]
-- Select all by pattern(write it after :%s/) and replace with following /(write substitute here)
vim.keymap.set({ 'n', 'v' }, '<Leader>e', ':%s/')
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"*')
--[=====[ Code navigation --]=====]
vim.keymap.set({ 'n', 'v' }, '<Leader>t', ':ij ')
