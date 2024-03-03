local cmd = vim.cmd                    -- execute Vim commands
local exec = vim.api.nvim_exec         -- execute Vimscript
local fn = vim.fn                      -- call Vim functions
local g = vim.g                        -- global variables
local opt = vim.opt                    -- global/buffer/windows-scoped options
local api = vim.api                    -- call Vim api
local ag = vim.api.nvim_create_augroup -- create autogroup
local au = vim.api.nvim_create_autocmd -- create autocomand
local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local neogit = require('neogit')
neogit.setup {}
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
     -- { name = 'vsnip' }, -- For vsnip users.
       { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
       { name = 'orgmode' }
    }, {
      { name = 'buffer' },
    })
  })
require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
require('lspconfig')['tsserver'].setup {
   capabilities = capabilities
}
require'lspconfig'.typst_lsp.setup{
	settings = {
		exportPdf = "onType" -- Choose onType, onSave or never.
        -- serverPath = "" -- Normally, there is no need to uncomment it.
	}
}
--Snippets--
require("luasnip.loaders.from_vscode").lazy_load()
---Plugins---
--require('feline-settings')
require('lualine-plugin')
--require('LuaSnip').setup()
--require('vimtex').setup()---
require('gitsigns').setup()
--- Configuraciones diversas para cmp-------
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
-------------Telescope----------------------
telescope = {
    enabled = true,
    --style = "nvchad"
}
require('telescope').setup()
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
--------------------------------------------
require('orgmode').setup_ts_grammar()

require("dashboard").setup()
require("catppuccin").setup { 
     integrations = {
	treesitter = true,
	cmp = true,
	markdown = true,
	gitsigns = true,
        dashboard = true,
	neogit = true,
 }
}
local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}
require('tabby.tabline').set(function(line)
  return {
    {
      { '  ', hl = theme.head },
      line.sep('', theme.head, theme.fill),
    },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.tab
      return {
        line.sep('', hl, theme.fill),
        tab.is_current() and '' or '󰆣',
        tab.number(),
        tab.name(),
        tab.close_btn(''),
        line.sep('', hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      return {
        line.sep('', theme.win, theme.fill),
        win.is_current() and '' or '',
        win.buf_name(),
        line.sep('', theme.win, theme.fill),
        hl = theme.win,
        margin = ' ',
      }
    end),
    {
      line.sep('', theme.tail, theme.fill),
      { '  ', hl = theme.tail },
    },
    hl = theme.fill,
  }
end)
vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { noremap = true })
require('nvim-treesitter').setup {
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
require('orgmode').setup({
	org_agenda_files = '~/org/agenda.org',
	org_default_notes_file = '~/org/notes.org',
})
-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
