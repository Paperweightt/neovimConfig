return {
    'echasnovski/mini.animate',
    version = '*',

    config = function()
        require('mini.animate').setup({
            cursor = {
                enable = false,
            }
        })
    end
}