
--- @diagnostic disable-next-line: undefined-global
local g = vim.g

local util = require('util')
local keymap = util.keymap


local function setup()
    require('telescope').load_extension('fzf')

    g.nvim_tree_icons = {
        default = ' ',
        symlink = 's',
        git = {
            unstaged = 'x',
            staged = '✓',
            unmerged = 'x',
            renamed = 'R',
            untracked = '?',
            deleted = 'D',
            ignored = "◌"
        },
        folder = {
            arrow_open = '>',
            arrow_closed = ' ',
            default = ' ',
            open = ' ',
            empty = ' ',
            empty_open = ' ',
            symlink = 's',
            symlink_open = 's',
        }
    }
    require('nvim-tree').setup{}
    keymap('n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})

    keymap('n', '<leader>ff', ':Telescope find_files<CR>', {noremap = true, silent = true})  -- TODO git_files or find_files?
    keymap('n', '<leader>fg', ':Telescope live_grep<CR>', {noremap = true, silent = true})
    keymap('n', '<leader>fh', ':Telescope help_tags<CR>', {noremap = true, silent = true})
    keymap('n', '<leader>fk', ':Telescope keymaps<CR>', {noremap = true, silent = true})
    keymap('n', '<leader>fz', ':Telescope spell_suggest<CR>', {noremap = true, silent = true})
    keymap('n', '<leader>f?', ':Telescope<CR>', {noremap = true, silent = true})
end

local M = {
    setup = setup,
}

return M
