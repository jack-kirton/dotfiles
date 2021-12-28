

--- @diagnostic disable-next-line: undefined-global
local g, opt, fn = vim.g, vim.opt, vim.fn

local keymap = require('util').keymap

local function setup()
    require('Comment').setup()

    -- TODO Also exit undotree with ESC (:UndotreeHide), when focus is on undotree window
    opt.undolevels = 10000
    opt.undodir = fn.stdpath('data') .. '/undo/'
    opt.undofile = true
    g.undotree_WindowLayout = 3
    g.undotree_SetFocusWhenToggle = 1
    keymap('n', '<C-u>', ':UndotreeToggle<CR>', {noremap = true, silent = true})
end


local M = {
    setup = setup,
}

return M
