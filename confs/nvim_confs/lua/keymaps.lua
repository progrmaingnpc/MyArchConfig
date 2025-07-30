vim.g.mapleader = " "
vim.keymap.set('n', '<Leader>w', '<cmd>echo "Example 1"<cr>') -- Abstract, pls ignore this
--[=====[ Copy, paste and cut keymaps --]=====]
-- Paste
vim.keymap.set({ 'n', 'v' }, '<C-v>', '"+p')
-- Cut
vim.keymap.set({ 'n', 'v' }, '<C-x>', '"+d')
-- Copy
vim.keymap.set({ 'n', 'v' }, '<C-c>', '"+y')

-- Select all by pattern(write it after :%s/) and replace with following /(write substitute here)
vim.keymap.set({ 'n', 'v' }, '<Leader>E', ':%s/')
--[=====[
    Select all by pattern(write it after '%s/')
    and choose which occurences to replace with another pattern (write it between the '//' before 'gc')
--]=====]
vim.keymap.set({ 'n', 'v' }, '<Leader>e', ':%s///gc')
-- Select all occurances of a word pattern your cursor is on(press n to move to the next occurence)
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"*')
--[=====[ Code navigation --]=====]
vim.keymap.set({ 'n', 'v' }, '<Leader>t', ':ij ')
