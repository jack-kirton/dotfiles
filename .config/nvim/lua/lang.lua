

-- local function server_default_on_attach(_, bufnr)
--     --- @diagnostic disable-next-line: undefined-global
--     local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--     --- @diagnostic disable-next-line: undefined-global
--     local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
--
--     -- TODO Better completion than omnifunc? Or better keybinding?
--     -- Enable completion triggered by <c-x><c-o>
--     buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--     -- Mappings.
--     local opts = { noremap=true, silent=true }
--
--     -- TODO Look through these keybindings, are they good?
--     -- See `:help vim.lsp.*` for documentation on any of the below functions
--     buf_set_keymap('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
--     buf_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
--     buf_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
--     buf_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)
--     buf_set_keymap('n', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>', opts)
--     buf_set_keymap('n', '<space>wa', ':lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--     buf_set_keymap('n', '<space>wr', ':lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--     buf_set_keymap('n', '<space>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--     buf_set_keymap('n', '<space>D', ':lua vim.lsp.buf.type_definition()<CR>', opts)
--     buf_set_keymap('n', '<space>rn', ':lua vim.lsp.buf.rename()<CR>', opts)
--     buf_set_keymap('n', '<space>ca', ':lua vim.lsp.buf.code_action()<CR>', opts)
--     buf_set_keymap('n', 'gr', ':lua vim.lsp.buf.references()<CR>', opts)
--     buf_set_keymap('n', '<space>e', ':lua vim.diagnostic.open_float()<CR>', opts)
--     buf_set_keymap('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>', opts)
--     buf_set_keymap('n', ']d', ':lua vim.diagnostic.goto_next()<CR>', opts)
--     buf_set_keymap('n', '<space>q', ':lua vim.diagnostic.setloclist()<CR>', opts)
--     buf_set_keymap('n', '<space>f', ':lua vim.lsp.buf.formatting()<CR>', opts)
-- end


local function server_on_attach(args)
    --- @diagnostic disable-next-line: undefined-global
    local vim = vim  -- This is just to disable undefined-global warning on every vim.keymap.set call
    local opts = { noremap=true, silent=true, buffer=args.buf }

    -- TODO Look through these keybindings, are they good?
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, opts)
end


-- Table of {name = {}} for passing custom arguments to the lspconfig setup function
local server_custom_args = {}


local function server_setup()
    local lsp_install = require('nvim-lsp-installer')
    local lsp_config = require('lspconfig')
    local servers = lsp_install.get_installed_servers()
    for _, server in ipairs(servers) do
        local args = server_custom_args[server.name] or {}
        args.on_attach = server_on_attach
        lsp_config[server.name].setup(args)
    end
end


local function setup()
    local lsp_install = require('nvim-lsp-installer')
    lsp_install.setup{}
    --- @diagnostic disable-next-line: undefined-global
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    server_setup()
end


local M = {
    setup = setup,
}


return M
