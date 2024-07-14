vim.opt.fillchars = { eob = ' ' }
vim.opt.scrolloff = 8
vim.opt.cursorline = true
vim.opt.wrap = true

-- tabbing
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.laststatus = 0

-- foldstuff
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.o.shell = 'powershell'
vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
vim.o.shellquote = '"'
vim.o.shellxquote = ''
vim.o.shellpipe = '| Out-File -Encoding UTF8 -Append'
vim.o.shellredir = '| Out-File -Encoding UTF8'

function CdToBufferDirectory()
  local current_buffer_path = vim.fn.expand '%:p:h'
  vim.cmd('cd ' .. current_buffer_path)
end

vim.cmd 'command! CdToBufferDirectory lua CdToBufferDirectory()'

vim.cmd 'autocmd VimEnter * normal! ahi'

-- remaps
-- Remap Ctrl+S to save the file
vim.api.nvim_set_keymap('n', '<C-s>', ':CdToBufferDirectory<CR>:w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-s>', ':CdToBufferDirectory<CR>:w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:CdToBufferDirectory<CR>:w<CR>a', { noremap = true, silent = true })
-- Map a keybind to execute CdToBufferDirectory command
vim.api.nvim_set_keymap('n', '<leader>cd', ':CdToBufferDirectory<CR>', { noremap = true, silent = true })

-- neovide
if vim.g.neovide then
  vim.g.neovide_transparency = 0.75
  vim.g.neovide_cursor_animation_length = 0.02
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_scale_factor = 0.8
end
return {}
