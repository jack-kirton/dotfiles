

--- @diagnostic disable-next-line: undefined-global
local g, opt, fn = vim.g, vim.opt, vim.fn

local util = require('util')
local t = util.t
local keymap = util.keymap


local function setup()
    g.mapleader = ','
    g.maplocalleader = ','

    opt.number = true
    opt.hidden = true
    -- TODO pastetoggle isn't working
    opt.pastetoggle=t'<F12>'  -- TODO Is this a good button?
    opt.autoindent = true
    opt.shiftwidth = 2
    opt.expandtab = true
    opt.tabstop = 2
    opt.softtabstop = 2

    opt.modeline = true

    opt.spelllang = 'en_gb'

    opt.ruler = true
    opt.cursorline = true
    opt.showmatch = true

    opt.ignorecase = true
    opt.smartcase = true
    opt.hlsearch = true
    opt.incsearch = true

    opt.visualbell = true

    opt.list = true
    opt.listchars:append({tab = '> ', trail = '•', extends = '#', nbsp = '.'})

    opt.modeline = true

    keymap('n', '<leader>/', ':nohlsearch<CR>', {silent = true})


    keymap('n', '=', ':bnext<CR>', {noremap = true})
    keymap('n', '-', ':bprev<CR>', {noremap = true})

    -- TODO: Edit multiple files command

    if fn.executable('rg') then
        opt.grepprg = 'rg'
    end
end


local M = {
    setup = setup,
}

return M
