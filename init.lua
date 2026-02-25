-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install lazy.nvim automatically if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.everforest_background = 'hard'
            vim.g.everforest_better_performance = 1
            vim.g.everforest_enable_italic = 1

            vim.cmd([[colorscheme everforest]])
            vim.opt.background = 'dark'
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim", -- Required dependency
            {
                -- FZF native for better performance
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    prompt_prefix = "🔍 ",
                    selection_caret = "➤ ",
                    path_display = { "truncate" },
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                            results_width = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                    mappings = {
                        i = {
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-c>"] = actions.close,
                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,
                            ["<CR>"] = actions.select_default,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                        },
                        n = {
                            ["<esc>"] = actions.close,
                            ["<CR>"] = actions.select_default,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,
                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            ["H"] = actions.move_to_top,
                            ["M"] = actions.move_to_middle,
                            ["L"] = actions.move_to_bottom,
                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,
                            ["gg"] = actions.move_to_top,
                            ["G"] = actions.move_to_bottom,
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        theme = "dropdown",
                        hidden = true, -- Show hidden files
                    },
                    git_files = {
                        theme = "dropdown",
                    },
                    buffers = {
                        theme = "dropdown",
                        sort_lastused = true,
                        mappings = {
                            i = {
                                ["<c-d>"] = actions.delete_buffer,
                            },
                        },
                    },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden" } -- Search in hidden files
                        end,
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            -- Load fzf extension if available
            pcall(telescope.load_extension, "fzf")

            -- Keymaps (equivalent to your fzf mappings)
            local builtin = require("telescope.builtin")

            -- <space>f - Git files (like :GFiles)
            vim.keymap.set('n', '<leader>f', builtin.git_files, { desc = 'Find git files' })

            -- <space>F - All files (like :Files)
            vim.keymap.set('n', '<leader>F', builtin.find_files, { desc = 'Find files' })

            -- <space>b - Buffers (like :Buffers)
            vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Find buffers' })

            -- <space>/ - Live grep (like :Rg)
            vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Live grep' })

            -- <space>T - Buffer tags (like :BTags)
            vim.keymap.set('n', '<leader>T', builtin.current_buffer_tags, { desc = 'Buffer tags' })

            -- Additional useful pickers
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
            vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Find keymaps' })
            vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Find symbols' })
            vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Find diagnostics' })
        end,
    },

    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },

    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Diagnostic signs (same as your vimrc)
            local signs = {
                { name = "DiagnosticSignError", text = "✘" },
                { name = "DiagnosticSignWarn", text = "⚠" },
                { name = "DiagnosticSignHint", text = "➤" },
                { name = "DiagnosticSignInfo", text = "ℹ" },
            }

            for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end

            -- Diagnostic configuration
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                    spacing = 4,
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            -- Hover and signature help with rounded borders
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "rounded",
            })

            -- LSP keymaps (same as your vimrc)
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, silent = true }

                -- Navigation
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
                    vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
                vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition,
                    vim.tbl_extend('force', opts, { desc = 'Go to type definition' }))
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
                    vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
                vim.keymap.set('n', 'gr', vim.lsp.buf.references,
                    vim.tbl_extend('force', opts, { desc = 'Find references' }))

                -- Documentation
                vim.keymap.set('n', 'K', vim.lsp.buf.hover,
                    vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
                vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help,
                    vim.tbl_extend('force', opts, { desc = 'Signature help' }))

                -- Actions
                vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action,
                    vim.tbl_extend('force', opts, { desc = 'Code action' }))
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename' }))

                -- Diagnostics
                vim.keymap.set('n', '<leader>D', vim.diagnostic.setloclist,
                    vim.tbl_extend('force', opts, { desc = 'Document diagnostics' }))
                vim.keymap.set('n', '[g', vim.diagnostic.goto_prev,
                    vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))
                vim.keymap.set('n', ']g', vim.diagnostic.goto_next,
                    vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))

                -- Symbols (using Telescope if available)
                vim.keymap.set('n', '<leader>t', function()
                    if pcall(require, 'telescope.builtin') then
                        require('telescope.builtin').lsp_document_symbols()
                    else
                        vim.lsp.buf.document_symbol()
                    end
                end, vim.tbl_extend('force', opts, { desc = 'Document symbols' }))

                -- Enable inlay hints if supported (Go, Rust, etc)
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
            end

            vim.lsp.enable({ 'lua_ls', 'gopls', 'ruff', 'pyright', 'ts_ls' })

            -- Go (gopls)
            vim.lsp.config('gopls', {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    gopls = {
                        gofumpt = true,
                        codelenses = {
                            gc_details = false,
                            generate = true,
                            regenerate_cgo = true,
                            run_govulncheck = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true,
                        },
                        hints = {
                            assignVariableTypes = false,
                            compositeLiteralFields = false,
                            compositeLiteralTypes = false,
                            constantValues = false,
                            functionTypeParameters = false,
                            parameterNames = false,
                            rangeVariableTypes = false,
                        },
                        analyses = {
                            fieldalignment = true,
                            nilness = true,
                            unusedparams = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        usePlaceholders = false,
                        completeUnimported = true,
                        staticcheck = true,
                        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                        semanticTokens = true,
                    },
                },
            })

            -- Python (Pyright)
            vim.lsp.config('pyright', {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    pyright = {
                        disableOrganizeImports = true, -- Using Ruff for this
                    },
                    python = {
                        analysis = {
                            typeCheckingMode = "standard",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        },
                    },
                },
            })

            -- Python (Ruff)
            vim.lsp.config('ruff', {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- Disable hover in favor of Pyright
                    client.server_capabilities.hoverProvider = false
                    on_attach(client, bufnr)
                end,
            })

            -- TypeScript/JavaScript
            vim.lsp.config('ts_ls', {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                },
            })

            -- Lua (for nvim config)
            vim.lsp.config('lua_ls', {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
        end,
    },

    -- nvim-cmp: Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",         -- LSP source
            "hrsh7th/cmp-buffer",           -- Buffer source
            "hrsh7th/cmp-path",             -- Path source
            "L3MON4D3/LuaSnip",             -- Snippet engine
            "saadparwaiz1/cmp_luasnip",     -- Snippet source
            "rafamadriz/friendly-snippets", -- Snippet collection
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- Load VSCode-style snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Only confirm explicitly selected items
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        -- Kind icons
                        local icons = {
                            Text = "󰉿",
                            Method = "󰆧",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "󰜢",
                            Variable = "󰀫",
                            Class = "󰠱",
                            Interface = "",
                            Module = "",
                            Property = "󰜢",
                            Unit = "󰑭",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "󰈇",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "󰙅",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "",
                        }
                        vim_item.kind = string.format("%s %s", icons[vim_item.kind] or "", vim_item.kind)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            })
        end,
    },

    -- Format on save (like your autocmd BufWritePre)
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    go = { "gofumpt", "goimports" },
                    python = { "ruff_format", "ruff_organize_imports" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    vue = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            })
        end,
    },
}, {
    ui = {
        border = "rounded",
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
    performance = {
        rtp = {
            -- Disable some builtin plugins might not use
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- Disable compatibility with vi
vim.opt.compatible = false

-- ============================================================================
-- Basic Settings
-- ============================================================================

vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = false -- Show relative line numbers
vim.opt.cursorline = true      -- Highlight current line
vim.opt.showcmd = true         -- Show command in bottom bar
vim.opt.wildmenu = true        -- Visual autocomplete for command menu
vim.opt.lazyredraw = true      -- Redraw only when needed
vim.opt.showmatch = true       -- Highlight matching [{()}]
vim.opt.incsearch = true       -- Search as characters are entered
vim.opt.hlsearch = true        -- Highlight matches
vim.opt.ignorecase = true      -- Ignore case when searching
vim.opt.smartcase = true       -- Override ignorecase if search contains uppercase

-- ============================================================================
-- Indentation & Formatting
-- ============================================================================

vim.opt.tabstop = 4        -- Number of visual spaces per TAB
vim.opt.softtabstop = 4    -- Number of spaces in tab when editing
vim.opt.shiftwidth = 4     -- Number of spaces for autoindent
vim.opt.expandtab = true   -- Tabs are spaces
vim.opt.autoindent = true  -- Copy indent from current line
vim.opt.smartindent = true -- Smart autoindenting on new lines

-- ============================================================================
-- UI & Display
-- ============================================================================

vim.opt.wrap = false         -- Don't wrap lines
vim.opt.scrolloff = 8        -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8    -- Keep 8 columns visible left/right of cursor
vim.opt.colorcolumn = "120"  -- Show column at 80 characters
vim.opt.signcolumn = "yes"   -- Always show sign column
vim.opt.termguicolors = true -- Enable 24-bit RGB colors

-- ============================================================================
-- Splits
-- ============================================================================

vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

-- ============================================================================
-- Backup & Swap
-- ============================================================================

vim.opt.backup = false      -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup before overwriting
vim.opt.swapfile = false    -- Don't create swap files

-- ============================================================================
-- Performance
-- ============================================================================

vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 500 -- Time to wait for mapped sequence

-- ============================================================================
-- Mouse & Clipboard
-- ============================================================================

vim.opt.mouse = "a"               -- Enable mouse in all modes
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- ============================================================================
-- Key Mappings
-- ============================================================================


-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows with arrows
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Clear search highlighting
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Save and quit shortcuts
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', { desc = 'Quit all without saving' })

-- Better indenting in visual mode
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Move lines up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })

-- Keep cursor centered when scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result and center' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result and center' })

-- ============================================================================
-- Auto Commands
-- ============================================================================

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = highlight_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
    end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function()
        local save_cursor = vim.fn.getpos('.')
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos('.', save_cursor)
    end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = '*',
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- ============================================================================
-- File Type Specific Settings
-- ============================================================================

-- Go specific settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = false -- Go uses tabs
    end,
})

-- Python specific settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
    end,
})

-- YAML/JSON specific settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'yaml', 'json' },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end,
})

-- ============================================================================
-- Status Line (simple built-in)
-- ============================================================================

vim.opt.laststatus = 2
vim.opt.statusline = '%f %m %r%=%l,%c %p%%'
