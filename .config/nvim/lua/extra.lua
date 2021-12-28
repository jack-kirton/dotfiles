

--- @diagnostic disable-next-line: undefined-global
local api, fn = vim.api, vim.fn

local gitui = nil
_gitui_toggle = nil  --- @diagnostic disable-line: lowercase-global



local function setup_gitui()
    local cmd = nil

    if fn.executable('gitui') then
        cmd = 'gitui'
    elseif fn.executable('lazygit') then
        cmd = 'lazygit'
    else
        return
    end

    gitui = require('toggleterm.terminal').Terminal:new({
            cmd = cmd,
            hidden = true,
            direction = 'float'
        })

    --- @diagnostic disable-next-line: lowercase-global
    _gitui_toggle = function()
        gitui:toggle()
    end

    require('util').keymap('n', '<leader>g', ':lua _gitui_toggle()<CR>', {noremap = true, silent = true})
end



local function setup()
    setup_gitui()
    require('gitsigns').setup{}
    require('spellsitter').setup{}
    -- TODO Easy align keymaps don't work with util.keymap for some reason
    api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})
    api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})
end


local M = {
    setup = setup,
}

return M
