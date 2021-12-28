

local function server_default_on_attach(_, bufnr)
    --- @diagnostic disable-next-line: undefined-global
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    --- @diagnostic disable-next-line: undefined-global
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- TODO Better completion than omnifunc? Or better keybinding?
    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- TODO Look through these keybindings, are they good?
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', ':lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', ':lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', ':lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', ':lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', ':lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', ':lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', ':lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', ':lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', ':lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', ':lua vim.lsp.buf.formatting()<CR>', opts)
end


local function server_default_opts()
    return {
        on_attach = server_default_on_attach
    }
end


local function server_default_setup(server)
    server:setup(server_default_opts())
end


-- Table of {name = function(server)} for specific LSP setup functions
local server_custom_setups = {
    -- rust_analyzer = function(server)
    --     local opts = {}
    --     opts.settings = {
    --         ['rust-analyzer'] = {
    --             experimental = {enable = true, procAttrMacros = true},
    --             proc_macro = {enable = true},
    --             cargo = {loadOutDirsFromCheck = true},
    --             ["experimental.enable"] = true,
    --             ["experimental.procAttrMacros"] = true,
    --             ["proc_macro.enable"] = true,
    --             ["cargo.loadOutDirsFromCheck"] = true,
    --         },
    --         experimental = {enable = true, procAttrMacros = true},
    --         proc_macro = {enable = true},
    --         cargo = {loadOutDirsFromCheck = true},
    --         ["rust-analyzer.experimental.enable"] = true,
    --         ["rust-analyzer.experimental.procAttrMacros"] = true,
    --         ["rust-analyzer.proc_macro.enable"] = true,
    --         ["rust-analyzer.cargo.loadOutDirsFromCheck"] = true,
    --     }
    --     --- @diagnostic disable-next-line: undefined-global
    --     server:setup(vim.tbl_deep_extend("force", server_default_opts(), opts))
    -- end,
}


local function server_setup(server)
    local setup_func = server_custom_setups[server.name] or server_default_setup
    setup_func(server)
end


local function setup()
    local lsp_install = require('nvim-lsp-installer')
    lsp_install.on_server_ready(server_setup)
end


local M = {
    setup = setup,
}


return M
