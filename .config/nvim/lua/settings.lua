local cmd = vim.cmd                    -- execute Vim commands
local exec = vim.api.nvim_exec         -- execute Vimscript
local fn = vim.fn                      -- call Vim functions
local g = vim.g                        -- global variables
local opt = vim.opt                    -- global/buffer/windows-scoped options
local api = vim.api                    -- call Vim api
local ag = vim.api.nvim_create_augroup -- create autogroup
local au = vim.api.nvim_create_autocmd -- create autocomand
local cmp = require'cmp'
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- spell
--exec ([[
--    augroup markdownSpell
--        autocmd!
--        autocmd FileType markdown setlocal spell spelllang=es
--        autocmd BufRead,BufNewFile *.md setlocal spell spelllang=es
 --   augroup END
 -- ]], false)
-----------------------------------------------------------
-- General
-----------------------------------------------------------
g.mapleader = ';'             -- change leader to a comma
opt.mouse = 'a'               -- enable mouse support
opt.clipboard = 'unnamedplus' -- copy/paste to system clipboard
opt.swapfile = false   
vim.cmd('language eo.UTF-8')
vim.cmd('setlocal spell spelllang=es')
opt.number = true             -- show line number
opt.relativenumber = true     -- show line number
opt.showmatch = true          -- highlight matching parenthesis
opt.foldmethod = 'expr'       -- enable folding (default 'foldmarker')
opt.colorcolumn = '80'        -- line lenght marker at 80 columns
opt.splitright = true         -- vertical split to the right
opt.splitbelow = true         -- orizontal split to the bottom
opt.ignorecase = true         -- ignore case letters when search
opt.smartcase = true          -- ignore lowercase for the whole pattern
opt.linebreak = true          -- wrap on word boundary
opt.foldlevel = 99            -- should open all folds
opt.conceallevel = 0
opt.termguicolors = true
opt.guifont = "JetBrainsMono Nerd Font"

-- Configuraciones Autocompletado --
native_lsp = {
    enabled = true,
    virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
    },
    underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
    },
    inlay_hints = {
        background = true,
    },
},
cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
      --  vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
         require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
       completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
     mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<TAB>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
       { name = 'luasnip' }, -- For luasnip users.
       { name = 'ultisnips' }, -- For ultisnips users.
       { name = 'snippy' }, -- For snippy users.
        { name = 'orgmode'}
    }, {
      { name = 'buffer' },
    })
  })
require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
--Snippets--
require("luasnip.loaders.from_vscode").lazy_load()
---Plugins---
--require('feline-settings')
require('lualine-plugin')
--require('LuaSnip').setup()
--require('vimtex').setup()---
require('gitsigns').setup()
-------------Telescope----------------------
require('telescope').setup()
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
--------------------------------------------
require('orgmode').setup_ts_grammar({
      org_agenda_files = '~/org/agenda.org',
      org_default_notes_file = '~/org/notes.org',
    })
require("dashboard").setup()
require("catppuccin").setup{ integrations = {
	treesitter = true,
	cmp = true,
	markdown = true,
	gitsigns = true,
        dashboard = true,
 }
}
require('nvim-treesitter.configs').setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop,
  -- highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    -- Required for spellcheck, some LaTex highlights and
    -- code block highlights that do not have ts grammar
    additional_vim_regex_highlighting = {'org'},
    additional_vim_regex_highlighting = {'latex'},
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}
-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
