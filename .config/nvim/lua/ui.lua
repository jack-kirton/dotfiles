

--- @diagnostic disable-next-line: undefined-global
local opt = vim.opt


local function setup()
    -- opt.background = 'dark'
    -- require('onedarkpro').load()
    opt.termguicolors = true
    require('lighthaus').setup({
        bg_dark = true,
    })

    require('lualine').setup{
        options = {
            -- theme = 'auto',
            theme = 'lighthaus_dark',
            icons_enabled = false,
            component_separators = { left = '|', right = '|' },
            section_separators = { left = '', right = '' }
        },
        tabline = {
            lualine_c = { require('tabline').tabline_buffers },
            lualine_x = { require('tabline').tabline_tabs }
        }
    }

    require('tabline').setup{
        enable = false,
        options = {
            show_devicons = false,
            show_bufnr = true,
            component_separators = {'', ''},
            modified_icon = "+ ",
        }
    }

    require('marks').setup{}
end


local M = {
    setup = setup,
}

return M
