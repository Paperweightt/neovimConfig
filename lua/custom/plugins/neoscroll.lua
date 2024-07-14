return {
  'karb94/neoscroll.nvim',
  config = function()
    if not vim.g.neovide then
      require('neoscroll').setup {}
    end
  end,
}
