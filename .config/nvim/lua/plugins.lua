

--- @diagnostic disable-next-line: undefined-global
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = nil

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end


-- TODO Why is this returned?
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'            -- Plugin manager

    use 'olimorris/onedarkpro.nvim'         -- Colorscheme
    use 'mrjones2014/lighthaus.nvim'

    use {'nvim-telescope/telescope.nvim',   -- Fuzzy finder for everything
        requires = {{'nvim-lua/plenary.nvim'},
                    {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}}
    }

    use 'nvim-treesitter/nvim-treesitter'   -- Better syntax processing

    -- TODO Is polyglot needed? Treesitter probably handles most of it
    -- use 'sheerun/vim-polyglot'           -- Better support for many languages
    use 'tpope/vim-eunuch'                  -- Linux file commands
    use 'tpope/vim-repeat'                  -- Repeat ('.' command) support for many plugins
    use 'numToStr/Comment.nvim'             -- Commenting
    use 'junegunn/vim-easy-align'           -- Simple alignment command

    use 'nvim-lualine/lualine.nvim'         -- Status line
    use 'kdheepak/tabline.nvim'             -- Buffer/tab line

    use 'chentau/marks.nvim'                -- Better support for marks

    use 'mbbill/undotree'                   -- Visual undo tree

    -- TODO Can this just be done with a LSP?
    use 'lervag/vimtex'                     -- Filetype LaTeX

    use 'kyazdani42/nvim-tree.lua'          -- Visual project file tree
    use 'lewis6991/spellsitter.nvim'        -- Spell checking in treesitter-enabled buffers

    use 'neovim/nvim-lspconfig'             -- Basic configs for LSPs
    use 'williamboman/nvim-lsp-installer'   -- Easy install of LSPs

    use 'github/copilot.vim'                -- Github Copilot

    use 'akinsho/toggleterm.nvim'           -- Better persistent terminal support (also for a git TUI)

    -- TODO Want Tmux integration? (e.g., 'aserowy/tmux.nvim')

    use {'lewis6991/gitsigns.nvim',         -- Git signs in gutter and git operations
        requires = {'nvim-lua/plenary.nvim'},
    }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
