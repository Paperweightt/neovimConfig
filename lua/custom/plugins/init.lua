vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
vim.opt.fillchars = { eob = ' ' }
vim.opt.scrolloff = 12
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.relativenumber = true

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

-- vim.cmd 'autocmd VimEnter* normal! ahi'

-- remaps
-- Remap Ctrl+S to save the file
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', function()
  vim.cmd 'w'
end, { noremap = true, silent = true })

-- Map a keybind to execute CdToBufferDirectory command
vim.keymap.set('n', '<leader>cd', CdToBufferDirectory, {
  noremap = true,
  silent = true,
  desc = '[C]d to current [D]irectory',
})

vim.keymap.set('v', '<leader>r', function()
  -- Get the selected text
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)

  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  -- Extract the selected text
  local selected_text
  if #lines == 1 then
    -- Single-line selection
    selected_text = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    -- Multi-line selection
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    selected_text = table.concat(lines, '\n')
  end

  -- Print or process the selected text
  print(selected_text)

  -- Prompt for replacement text
  local replacement = vim.fn.input('Replace"' .. selected_text .. '" with? ')
  if replacement ~= '' then
    -- Execute the substitution
    vim.cmd('%s/\\V' .. vim.fn.escape(selected_text, '\\') .. '/' .. vim.fn.escape(replacement, '\\') .. '/g')
  end
end, {
  desc = '[R]eplace visual selection',
})

-- Variables to track the terminal
local term_win_id = nil
local term_bufnr = nil

local function toggle_floating_terminal()
  if term_win_id and vim.api.nvim_win_is_valid(term_win_id) then
    -- Close the terminal if it's open
    vim.api.nvim_win_close(term_win_id, true)
    term_win_id = nil
  else
    -- Create a new terminal buffer if needed
    if not term_bufnr or not vim.api.nvim_buf_is_valid(term_bufnr) then
      term_bufnr = vim.api.nvim_create_buf(false, true)
    end

    -- Change to the directory of the current file
    -- local file_dir = vim.fn.expand '%:p:h'
    -- vim.api.nvim_feedkeys('cd ' .. file_dir .. ' > /dev/null 2>&1\n', 't', false)

    -- Open a floating window
    term_win_id = vim.api.nvim_open_win(term_bufnr, true, {
      relative = 'editor',
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      row = math.floor(vim.o.lines * 0.1),
      col = math.floor(vim.o.columns * 0.1),
      style = 'minimal',
      border = 'rounded',
    })

    -- Open a terminal in the buffer
    vim.api.nvim_command 'terminal'

    -- Start in insert mode (for terminal)
    vim.api.nvim_command 'startinsert'
  end
end

-- Map Ctrl-t in normal and terminal modes
vim.keymap.set('i', '<C-t>', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
  toggle_floating_terminal()
  vim.api.nvim_feedkeys('a', 'n', false)
end, { desc = '[T]oggle floating terminal' })

vim.keymap.set('n', '<C-t>', toggle_floating_terminal, { desc = '[T]oggle floating terminal' })
vim.keymap.set('t', '<C-t>', function()
  -- Leave terminal insert mode and toggle the terminal
  vim.api.nvim_command 'stopinsert'
  toggle_floating_terminal()
end, { desc = 'Toggle floating terminal from terminal mode' })

vim.keymap.set('t', '<C-o>', function()
  -- Leave terminal insert mode and toggle the terminal
  vim.api.nvim_command 'stopinsert'
  toggle_floating_terminal()
end, { desc = 'Toggle floating terminal from terminal mode' })

-- neovide
if vim.g.neovide then
  vim.g.neovide_transparency = 0.75
  vim.g.neovide_cursor_animation_length = 0.02
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_scale_factor = 0.8
end

return {}
