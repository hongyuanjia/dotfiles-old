-- |  \/  \ \ / /\ \   / /_ _|  \/  |  _ \ / ___|
-- | |\/| |\ V /  \ \ / / | || |\/| | |_) | |
-- | |  | | | |    \ V /  | || |  | |  _ <| |___
-- |_|  |_| |_|     \_/  |___|_|  |_|_| \_\\____|
--
--
-- Author: @hongyuanjia
-- Last Modified: 2022-04-15 16:06:06

-- Basic Settings
local options = {
    backup = false,
    swapfile = false,
    writebackup = false,
    undofile = true,

    -- UI
    mouse = "a",
    cmdheight = 2,
    conceallevel = 0,
    pumheight = 10,
    showmode = false,
    showtabline = 2,
    cursorline = true,
    number = true,
    relativenumber = true,
    numberwidth = 4,
    signcolumn = "yes",
    wrap = false,
    scrolloff = 8,
    sidescrolloff = 8,
    termguicolors = true,
    laststatus = 2,

    -- search
    hlsearch = true,
    ignorecase = true,
    smartcase = true,

    -- split
    splitbelow = true,
    splitright = true,

    -- edit
    fileencoding = "utf-8",
    smartindent = true,
    clipboard = "unnamedplus",
    textwidth = 80,

    -- autocomplete
    completeopt = { "menu", "menuone", "noselect" },
    timeoutlen = 500,
    updatetime = 300,

    -- tabs
    smarttab = true,
    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,
    softtabstop = 4
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- don't give ins-completion-menu messages
vim.opt.shortmess:append("c")
-- treat '-' as word separator
vim.opt.iskeyword:append("-")
-- do not add comment header
vim.opt.formatoptions:remove("cro")
-- do not insert spaces for multi bytes
vim.opt.formatoptions:append("M")

-- Key maps
-- shorten function name
function _G.keymap(mode, lhs, rhs, opts)
    opts = vim.tbl_extend("force", {noremap = true, silent = true}, opts or {})
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

function _G.bufkeymap(mode, lhs, rhs, opts, bufnr)
    opts = vim.tbl_extend("force", {noremap = true, silent = true}, opts or {})
    bufnr = bufnr or 0
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
end

-- remap space as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","
keymap("", "<Space>", "<Nop>")

-- use jk to go back to normal mode in insert mode
keymap("i", "jk", "<Esc>")

-- remap j and k to move across display lines and not real lines
keymap("n", "k", "gk")
keymap("n", "gk", "k")
keymap("n", "j", "gj")
keymap("n", "gj", "j")

-- use <C-[hjkl]> for window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- use <C-[UDLR]> for window resizing
keymap("n", "<C-Up>", "<cmd>resize -2<CR>")
keymap("n", "<C-Down>", "<cmd>resize +2<CR>")
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- move text up and down
keymap("n", "<A-j>", "<Esc><cmd>m .+1<CR>==gi")
keymap("n", "<A-k>", "<Esc><cmd>m .-2<CR>==gi")

-- stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- move text up and down
keymap("v", "<A-j>", "<cmd>m .+1<CR>==")
keymap("v", "<A-k>", "<cmd>m .-2<CR>==")

-- jump to beginning or end using H and L
keymap("n", "H", "^")
keymap("n", "L", "$")
keymap("v", "H", "^")
keymap("v", "L", "$")

-- use Y to yank to the end of line
keymap("n", "Y", "y$")
keymap("v", "Y", "'+y")

-- buffer & tab navigation
keymap("n", "]b", "<cmd>bnext<CR>")
keymap("n", "[b", "<cmd>bprev<CR>")
keymap("n", "]t", "<cmd>tabnext<CR>")
keymap("n", "[t", "<cmd>tabprev<CR>")

-- <Leader>b[uffer]
keymap("n", "<Leader>bd", "<cmd>bdelete<CR>")
keymap("n", "<Leader>bn", "<cmd>bnext<CR>")
keymap("n", "<Leader>bp", "<cmd>bprev<CR>")
keymap("n", "<Leader>bN", "<cmd>enew <BAR> startinsert <CR>")

-- <Leader>f[ile]
keymap("n", "<Leader>fs", "<cmd>update<CR>")
keymap("n", "<Leader>fR", "<cmd>source $MYVIMRC<CR>")
keymap("n", "<Leader>fv", "<cmd>e $MYVIMRC<CR>")

-- <Leader>o[pen]
keymap("n", "<Leader>oq", "<cmd>qopen<CR>")
keymap("n", "<Leader>ol", "<cmd>lopen<CR>")

-- <Leader>t[oggle]
function _G.toggle_colorcolumn()
    if vim.wo.colorcolumn ~= "" then
        vim.wo.colorcolumn = ""
    else
        vim.wo.colorcolumn = "80"
    end
end
function _G.toggle_linenumber()
    vim.cmd[[
        execute {
            \ '00': 'set relativenumber   | set number',
            \ '01': 'set norelativenumber | set number',
            \ '10': 'set norelativenumber | set nonumber',
            \ '11': 'set norelativenumber | set number'
            \ }[&number . &relativenumber]
    ]]
end
keymap("n", "<Leader>tc", "<cmd>lua toggle_colorcolumn()<CR>")
keymap("n", "<Leader>tl", "<cmd>lua toggle_linenumber()<CR>")

-- <Leader>q[uit]
keymap("n", "<Leader>q", "<cmd>q<CR>")
keymap("n", "<Leader>Q", "<cmd>qa!<CR>")

-- <Leader>s[earch]
keymap("n", "<Leader>sn", "<cmd>nohlsearch<CR>")

-- <Leader>w[indow]
keymap("n", "<Leader>ww", "<C-w>w")
keymap("n", "<Leader>wc", "<C-w>c")
keymap("n", "<Leader>w-", "<C-w>s")
keymap("n", "<Leader>w|", "<C-w>v")
keymap("n", "<Leader>wh", "<C-w>h")
keymap("n", "<Leader>wj", "<C-w>j")
keymap("n", "<Leader>wl", "<C-w>l")
keymap("n", "<Leader>wk", "<C-w>k")
keymap("n", "<Leader>wH", "<C-w>5<")
keymap("n", "<Leader>wL", "<C-w>5>")
keymap("n", "<Leader>wJ", "<cmd>resize +5<CR>")
keymap("n", "<Leader>wK", "<cmd>resize -5<CR>")
keymap("n", "<Leader>w=", "<C-w>=")
keymap("n", "<Leader>wv", "<C-w>v")
keymap("n", "<Leader>ws", "<C-w>s")
keymap("n", "<Leader>wo", "<cmd>only<CR>")

keymap("t", "<Esc>", [[<C-\><C-n>]])
keymap("t", "jk",    [[<C-\><C-n>]])
keymap("t", "<C-h>", [[<C-\><C-n><C-W>h]])
keymap("t", "<C-j>", [[<C-\><C-n><C-W>j]])
keymap("t", "<C-k>", [[<C-\><C-n><C-W>k]])
keymap("t", "<C-l>", [[<C-\><C-n><C-W>l]])

-- Plugins
-- automatically install packer
local packer_install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
    if vim.fn.executable("git") == 0 then
        print "Git was not installed. Please install Git first. All plugins will be not installed."
        return
    end

    PACKER_BOOTSTRAP = vim.fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        packer_install_path,
    }
    print "Installing 'packer.nvim'... Please close and reopen Neovim after installing."
    vim.cmd("packadd packer.nvim")
end

-- stop loading plugin configs if packer is not installed
local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
    return
end

-- use a popup window for packer
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float {
                border = "rounded"
            }
        end,
    }
}

packer.startup(function(use)
    -- packer and basics
    use {
        "wbthomason/packer.nvim",
        config = function()
            -- <Leader>P[acker]
            keymap("n", "<Leader>Pc", "<cmd>PackerCompile<CR>")
            keymap("n", "<Leader>Pi", "<cmd>PackerInstall<CR>")
            keymap("n", "<Leader>Ps", "<cmd>PackerSync<CR>")
            keymap("n", "<Leader>PS", "<cmd>PackerStatus<CR>")
            keymap("n", "<Leader>Pu", "<cmd>Packerupdate<CR>")
        end
    }
    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"

    -- start tim profile
    use {
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime"
    }

    -- plugin lazy loading
    use {
        "lewis6991/impatient.nvim",
        config = function()
            require("impatient").enable_profile()
        end
    }
    use "nathom/filetype.nvim"

    -- UI
    use {
        "folke/tokyonight.nvim",
        config = function()
            vim.g.tokyonight_italic_comments = false
            vim.cmd [[colorscheme tokyonight]]
        end
    }
    use {
        "nvim-lualine/lualine.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            local status_ok, tokyonight = pcall(require, "tokyonight")
            local theme = "auto"
            if status_ok then
                theme = "tokyonight"
            end

            require("lualine").setup({
                options = {
                    theme = theme,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        {
                            "branch",
                            icons_enabled = true,
                            icon = "",
                        },
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            sections = { "error", "warn" },
                            symbols = { error = " ", warn = " " },
                            colored = false,
                        }
                    },
                    lualine_x = {
                        {
                            "diff",
                            colored = false,
                            symbols = { added = " ", modified = " ", removed = " " },
                            cond = function()
                                return vim.fn.winwidth(0) > 80
                            end
                        },
                        "encoding",
                        {
                            "filetype",
                            icons_enabled = false
                        }

                    }
                }
            })
        end,
    }
    use {
        "akinsho/bufferline.nvim",
        requires = {
            "kyazdani42/nvim-web-devicons",
            "moll/vim-bbye"
        },
        config = function()
            require("bufferline").setup {
                options = {
                    numbers = "none",
                    close_command = "Bdelete! %d",
                    left_mouse_command = "buffer %d",
                    middle_mouse_command = "Bdelete %d",
                    right_mouse_command = nil,
                    max_name_length = 30,
                    max_prefix_length = 15,
                    seperator_style = "thick",
                    enforce_regular_tabs = true,
                }
            }
        end
    }
    use "RRethy/vim-illuminate"
    use {
        "moll/vim-bbye",
        config = function()
            keymap("n", "<Leader>bd", "<cmd>Bdelete<CR>")
        end
    }
    use {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        config = function()
            vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
            vim.g.indent_blankline_filetype_exclude = {
                "help",
                "alpha",
                "checkhealth",
                "dashboard",
                "packer",
                "NvimTree"
            }

            -- don't displays a trailing indentation guide on blank lines
            vim.g.indent_blankline_show_trailing_blankline_indent = false
            -- use treesitter to calculate indentation when possible
            vim.g.indent_blankline_use_treesitter = true

            require("indent_blankline").setup({
                show_current_context = true
            })
        end
    }
    use {
        "goolord/alpha-nvim",
        requires = "nvim-telescope/telescope.nvim",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.buttons.val = {
            	dashboard.button("SPC b N", "  New file"),
            	dashboard.button("SPC s f", "  Find file"),
            	dashboard.button("SPC s p", "  Find project"),
            	dashboard.button("SPC f r", "  Recently used files"),
            	dashboard.button("SPC s g", "  Find text"),
            	dashboard.button("SPC f v", "  Configuration"),
            	dashboard.button("SPC Q",   "  Quit Neovim"),
            }

            alpha.setup(dashboard.config)

            -- <Leader>b[uffer]
            vim.api.nvim_set_keymap("n", "<Leader>ba", "<cmd>Alpha<CR>", { noremap = true, silent = true })
        end
    }
    use {
        "norcalli/nvim-colorizer.lua",
        event = "BufRead",
        config = function()
            require("colorizer").setup()
        end
    }
    use {
        "akinsho/toggleterm.nvim",
        cmd = "ToggleTerm",
        module = {"toggleterm", "toggleterm.terminal"},
        config = function()
            require("toggleterm").setup({
                float_opts = {
                    border = "curved",
                    winblend = 0,
                    highlights = {
                        border = "Normal",
                        background = "Normal"
                    }
                }
            })

            -- <Leader>t[erminal]
            keymap("n", "<Leader>tF", "<cmd>ToggleTerm direction=float<CR>")
            keymap("n", "<Leader>tH", "<cmd>ToggleTerm size=10 direction=horizontal<CR>")
            keymap("n", "<Leader>tV", "<cmd>ToggleTerm size=80 direction=vertical<CR>")
        end
    }
    use {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        setup = function()
            vim.g.symbols_outline = {
                auto_preview = false
            }

            -- <Leader>l[ist]
            keymap("n", "<Leader>lo", "<cmd>SymbolsOutline<CR>")
        end
    }
    use {
        "t9md/vim-choosewin",
        cmd = { "(Plug)(choosewin)", "ChooseWin", "ChooseWinSwap", "ChooseWinSwapStay" },
        config = function()
            -- use - to choose window
            keymap("n", "-", "<cmd>ChooseWin<CR>", { noremap = false })
        end
    }
    use {
        "sindrets/winshift.nvim",
        config = function()
            require("winshift").setup()

            keymap("n", "<Leader>wS", "<cmd>WinShift<cr>")
        end
    }
    use 'dstein64/nvim-scrollview'

    -- autocompletion
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            -- completion sources
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",

            -- snippets
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets"
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            -- load snippets
            require("luasnip/loaders/from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end
                },
                mapping = {
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs( 4), { "i", "c" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-y>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-e>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close()
                    }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
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
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" }
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind_icons = {
                            Text = "",
                            Method = "m",
                            Function = "",
                            Constructor = "",
                            Field = "",
                            Variable = "",
                            Class = "",
                            Interface = "",
                            Module = "",
                            Property = "",
                            Unit = "",
                            Value = "",
                            Enum = "",
                            Keyword = "",
                            Snippet = "",
                            Color = "",
                            File = "",
                            Reference = "",
                            Folder = "",
                            EnumMember = "",
                            Constant = "",
                            Struct = "",
                            Event = "",
                            Operator = "",
                            TypeParameter = "",
                        }
                        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end
                },
                experimental = {
                    ghost_text = true,
                    native_menu = false
                }
            })

            cmp.setup.cmdline("/", {
                sources = {
                    { name = "buffer" }
                }
            })
        end
    }

    -- lsp
    use {
        "neovim/nvim-lspconfig",
        requires = {
            "williamboman/nvim-lsp-installer",
            "jose-elias-alvarez/null-ls.nvim"
        },
        event = {"BufRead", "BufNewFile"},
        config = function()
            local lsp_handlers = {}

            lsp_handlers.setup = function()
                local signs = {
                    { name = "DiagnosticSignError", text = "" },
                    { name = "DiagnosticSignWarn",  text = "" },
                    { name = "DiagnosticSignHint",  text = "" },
                    { name = "DiagnosticSignInfo",  text = "" },
                }

                for _, sign in ipairs(signs) do
                    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
                end

                local config = {
                    virtual_text = false,
                    signs = { active = signs },
                    update_in_insert = true,
                    underline = true,
                    severity_sort = true,
                    float = {
                        focusable = false,
                        style = "minimal",
                        border = "rounded",
                        source = "always",
                        header = "",
                        prefix = "",
                    }
                }

                vim.diagnostic.config(config)
                vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                    border = "rounded", wrap = false
                })

                vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                    border = "rounded",
                })
            end
            lsp_handlers.setup()

            lsp_handlers.on_attach = function(client, bufnr)
                local function bufkeymap(mode, lhs, rhs, opts)
                    opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
                    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
                end

                bufkeymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
                bufkeymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
                bufkeymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
                bufkeymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
                bufkeymap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>")
                bufkeymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
                bufkeymap("n", "gA", "<cmd>lua vim.lsp.buf.code_action()<CR>")
                bufkeymap("n", "gl", "<cmd>lua vim.diagnostic.open_float(0, {scope = 'line'})<CR>")
                bufkeymap("n", "K",  "<cmd>lua vim.lsp.buf.hover()<CR>")
                bufkeymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>")
                bufkeymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>")

                -- <Leader>l[sp]
                bufkeymap("n", "<Leader>li", "<cmd>LspInfo<CR>")
                bufkeymap("n", "<Leader>lI", "<cmd>LspInstallInfo<CR>")
                bufkeymap("n", "<Leader>lj", "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>")
                bufkeymap("n", "<Leader>lk", "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>")
                bufkeymap("n", "<Leader>ll", "<cmd>lua vim.lsp.codelens.run()<CR>")
                bufkeymap("n", "<Leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>")
                bufkeymap("n", "<Leader>lF", "<cmd>lua vim.lsp.buf.formatting()<CR>")
                bufkeymap("n", "<Leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>")

                vim.cmd[[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
            end

            -- add completion source
            local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if status_ok then
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                lsp_handlers.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
            end

            local lsp_installer = require("nvim-lsp-installer")
            lsp_installer.on_server_ready(function(server)
                local opts = {
                    on_attach = lsp_handlers.on_attach,
                    capabilities = lsp_handlers.capabilities
                }

                if server.name == "sumneko_lua" then
                    local lua_settings = {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    library = {
                                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                        [vim.fn.stdpath("config") .. "/lua"] = true,
                                    },
                                },
                            }
                        }
                    }

                    opts = vim.tbl_deep_extend("force", lua_settings, opts)
                end

                server:setup(opts)
            end)
        end
    }
    use {
        "ray-x/lsp_signature.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("lsp_signature").setup({
                hint_enable = false
            })
        end
    }
    use {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup()

            -- <Leader>t[oggle]
            keymap("n", "<Leader>tt", "<cmd>TroubleToggle<CR>")

            -- use trouble to replace gr
            keymap("n", "gr", "<cmd>TroubleToggle lsp_references<CR>")

            -- <Leader>l[ist]
            keymap("n", "<Leader>ld", "<cmd>TroubleToggle document_diagnostics<CR>")
            keymap("n", "<Leader>lw", "<cmd>TroubleToggle workspace_diagnostics<CR>")

            -- <Leader>o[pen]
            keymap("n", "<Leader>oq", "<cmd>TroubleToggle quickfix<CR>")
            keymap("n", "<Leader>ol", "<cmd>TroubleToggle loclist<CR>")
        end
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "ahmedkhalf/project.nvim",
            "stevearc/dressing.nvim",
        },
        cmd = "Telescope",
        module = "telescope",
        setup = function()
            -- <Leader>b[uffer]
            keymap("n", "<Leader>bb", "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<CR>")

            -- <Leader>f[ile]
            keymap("n", "<Leader>ff", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<CR>")
            keymap("n", "<Leader>fr", "<cmd>Telescope oldfiles<CR>")

            -- <Leader>g[it]
            keymap("n", "<Leader>gS", "<cmd>Telescope git_status<CR>")
            keymap("n", "<Leader>gB", "<cmd>Telescope git_branches<CR>")
            keymap("n", "<Leader>gC", "<cmd>Telescope git_commits<CR>")

            -- <Leader>l[ist]
            keymap("n", "<Leader>ld", "<cmd>Telescope diagnostics bufnr=0<CR>")
            keymap("n", "<Leader>lw", "<cmd>Telescope diagnostics<CR>")

            -- <Leader>s[earch]
            keymap("n", "<Leader>sl", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
            keymap("n", "<Leader>sf", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<CR>")
            keymap("n", "<Leader>sb", "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<CR>")
            keymap("n", "<Leader>sB", "<cmd>Telescope git_branches<CR>")
            keymap("n", "<Leader>sC", "<cmd>Telescope colorscheme enable_preview=true<CR>")
            keymap("n", "<Leader>sh", "<cmd>Telescope help_tags<CR>")
            keymap("n", "<Leader>sM", "<cmd>Telescope man_pages<CR>")
            keymap("n", "<Leader>sr", "<cmd>Telescope oldfiles<CR>")
            keymap("n", "<Leader>sR", "<cmd>Telescope registers<CR>")
            keymap("n", "<Leader>sk", "<cmd>Telescope keymaps<CR>")
            keymap("n", "<Leader>sc", "<cmd>Telescope commands<CR>")
            keymap("n", "<Leader>sg", "<cmd>Telescope live_grep theme=ivy<CR>")
            keymap("n", "<Leader>sp", "<cmd>Telescope projects<CR>")
            keymap("n", "<Leader>ss", "<cmd>Telescope lsp_document_symbols<CR>")
            keymap("n", "<Leader>sS", "<cmd>Telescope lsp_workspace_symbols<CR>")
        end,
        config = function()
            require("project_nvim").setup({
                detection_methods = {"pattern", "lsp"},
                patterns = {".git", ".svn", ".Rproj", ".here", "package.json"}
            })

            if packer_plugins["trouble"] then
                local trouble = require("trouble.providers.telescope")
                require("telescope").setup({
                    defaults = {
                        mappings = {
                            i = { ["<C-t>"] = trouble.open_with_trouble },
                            n = { ["<C-t>"] = trouble.open_with_trouble }
                        }
                    }
                })
            else
                require("telescope").setup()
            end

            require('telescope').load_extension("projects")
        end
    }
    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        after = "telescope.nvim",
        run = "mingw32-make",
        config = function()
            require("telescope").load_extension("fzf")
        end
    }

    -- editing
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local autopairs = require("nvim-autopairs")
            autopairs.setup({
                check_ts = true,
                disable_filetype = { "TelescopePrompt" }
            })

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            local cmp_status_ok, cmp = pcall(require, "cmp")
            if cmp_status_ok then
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
            end
        end
    }
    use {
        "terrortylor/nvim-comment",
        requires = "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require('nvim_comment').setup({
                hook = function()
                    if vim.api.nvim_buf_get_option(0, "filetype") == "vue" then
                        require("ts_context_commentstring.internal").update_commentstring()
                    end
                end
            })
        end
    }
    use {
        "antoinemadec/FixCursorHold.nvim",
        config = function()
            vim.g.curshold_updatime = 1000
        end
    }
    use "wellle/targets.vim"
    use {
        'ggandor/lightspeed.nvim',
        requires = "tpope/vim-repeat"
    }
    use {
        "machakann/vim-sandwich",
        config = function()
            vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]
        end
    }
    use {
        "AndrewRadev/sideways.vim",
        cmd = {"SidewaysLeft", "SidewaysRight"},
        setup = function()
            -- <Leader>a[rgument]
            keymap("n", "<Leader>ah", "<cmd>SidewaysLeft<CR>")
            keymap("n", "<Leader>al", "<cmd>SidewaysRight<CR>")
        end
    }
    use {
        "ntpeters/vim-better-whitespace",
        cmd = {
            "EnableWhitespace",
            "DisableWhitespace",
            "StripWhitespace",
            "ToggleWhitespace"
        },
        config = function()
            -- <Leader>t[oggle]
            keymap("n", "<Leader>tS", "<cmd>ToggleWhitespace<CR>")
            keymap("n", "<Leader>tX", "<cmd>ToggleStripWhitespaceOnSave<CR>")
        end
    }
    use {
        "mg979/vim-visual-multi",
    }

    -- file management
    use {
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons"
        },
        config = function()
            vim.g.nvim_tree_respect_buf_cwd = 1

            require("nvim-tree").setup({
                hijack_netrw = true,
                hijack_cursor = true,
                update_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_cwd = true
                },
                diagnostics = {
                    enable = true
                },
                actions = {
                    open_file = {
                        quit_on_open = true
                    }
                },
                view = {
                    mappings = {
                        list = {
                            { key = "h", action = "close_node" },
                            { key = "l", action = "edit"}
                        }
                    }
                }
            })

            -- <Leader>f[iles]
            keymap("n", "<Leader>fe", "<cmd>NvimTreeToggle<CR>")
            keymap("n", "<Leader>fl", "<cmd>NvimTreeFindFileToggle<CR>")

            -- <Leader>t[oggle]
            keymap("n", "<Leader>te", "<cmd>NvimTreeToggle<CR>")
        end
    }

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        requires = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = "all",
                highlight = { enable = true },
                autopairs = { enable = true },
                indent = { enable = true },
                incremental_selection = { enable = true },
                context_commentstring = { enable = true, enable_autocmd = false }
            })
        end
    }

    -- Git
    use {
        "lewis6991/gitsigns.nvim",
        require = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup()
            -- ][c to navigate hunks
            keymap("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
            keymap("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

            -- <Leader>g[it]
            keymap("n", "<Leader>gj", "<cmd>Gitsigns next_hunk<CR>")
            keymap("n", "<Leader>gk", "<cmd>Gitsigns prev_hunk<CR>")
            keymap("n", "<Leader>gs", "<cmd>Gitsigns stage_hunk<CR>")
            keymap("v", "<Leader>gs", "<cmd>Gitsigns stage_hunk<CR>")
            keymap("n", "<Leader>gr", "<cmd>Gitsigns reset_hunk<CR>")
            keymap("v", "<Leader>gr", "<cmd>Gitsigns reset_hunk<CR>")
            keymap("l", "<Leader>gl", "<cmd>Gitsigns setloclist<CR>")
            keymap("n", "<Leader>gp", "<cmd>Gitsigns preview_hunk<CR>")
            keymap("n", "<Leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>")
            keymap("n", "<Leader>gw", "<cmd>Gitsigns stage_buffer<CR>")
            keymap("n", "<Leader>gR", "<cmd>Gitsigns reset_buffer<CR>")
            keymap("n", "<Leader>gb", "<cmd>lua require'gitsigns'.blame_line{full=true}<CR>")

            -- ih for text object
            keymap("o", "ih", "<cmd>Gitsigns select_hunk<CR>")
            keymap("x", "ih", "<cmd>Gitsigns select_hunk<CR>")
        end
    }
    use {
        "tpope/vim-fugitive",
        requires = "tpope/vim-rhubarb",
        config = function()
            keymap("n", "<Leader>gg", "<cmd>Git<CR>")
            keymap("n", "<Leader>gd", "<cmd>Gdiffsplit<CR>")
        end
    }

    -- WhichKey
    use {
        "folke/which-key.nvim",
        config = function()
            local whichkey = require("which-key")

            whichkey.setup({
                plugins = { spelling = { enable = true } },
                window = { border = "rounded" }
            })

            whichkey.register({
                a = {
                    name = "Argument",
                    h = "Move to Left",
                    l = "Move to Right",
                },
                b = {
                    name = "Buffer",
                    a = "Alpha",
                    b = "Search",
                    d = "Delete",
                    n = "Next",
                    p = "Previous",
                    N = "New",
                },
                f = {
                    name = "File",
                    f = "Search",
                    e = "NvimTree",
                    l = "Locate in NvimTree",
                    r = "Recent",
                    s = "Save",
                    R = "Source $MYVIMRC",
                    v = "Edit $MYVIMRC"
                },
                g = {
                    name = "Git",
                    g = "Status",
                    j = "Next Hunk",
                    k = "Prev Hunk",
                    s = "Stage Hunk",
                    r = "Reset Hunk",
                    p = "preview Hunk",
                    u = "Undo Hunk",
                    w = "Stage Buffer",
                    R = "Reset Buffer",
                    b = "Blame line",
                    d = "Diff",
                    S = "Status",
                    B = "Branches",
                    C = "Commits",
                },
                l = {
                    name = "List",
                    a = "Code Action",
                    i = "Lsp Info",
                    I = "Lsp Install",
                    j = "Prev Diagnostic",
                    k = "Next Diagnostic",
                    l = "Codelens",
                    d = "Buffer Diagnostics",
                    w = "Workspace Diagnostics",
                    o = "Symbol Outline",
                    F = "Format Buffer",
                    r = "Rename in Buffer",
                },
                o = {
                    name = "Open",
                    q = "Quickfix",
                    l = "Location List"
                },
                s = {
                    name = "Search",
                    l = "Lines",
                    f = "Files",
                    b = "Buffers",
                    B = "Git Branches",
                    C = "Colorschemes",
                    h = "Help Tags",
                    M = "Manuals",
                    r = "Rencent Files",
                    R = "Registers",
                    k = "Key Maps",
                    c = "Commands",
                    g = "Live Grep",
                    p = "Projects",
                    n = "No Search Highlight"
                },
                t = {
                    name = "Toggle",
                    e = "NvimTree",
                    c = "Colorcolumn",
                    s = "WhiteSpace",
                    t = "Trouble",
                    F = "Float Terminal",
                    H = "Horizontal Terminal",
                    V = "Vertical Terminal"
                },
                w = {
                    name = "Windows",
                    w = "Next",
                    c = "Close",
                    ["-"] = "Split Horizontal",
                    ["|"] = "Split Vertical",
                    s = "Split Horizontal",
                    v = "Split Vertical",
                    h = "Left",
                    j = "Below",
                    l = "Right",
                    k = "Below",
                    o = "Only",
                    H = "Resize Left",
                    L = "Resize Right",
                    J = "Resize Above",
                    K = "Resize Below",
                    W = "Shift Window",
                    ["="] = "Resize Equally",
                },
                q = {
                    name = "Quit"
                }

            }, { prefix = "<leader>" })
        end
    }

    -- R
    use {
        "jalvesaq/R-Vim-runtime",
        ft = {"r", "rmd", "rnoweb", "rout"}
    }
    use {
        "jalvesaq/Nvim-R",
        ft = {"r", "rmd", "rnoweb", "rout"},
        config = function()
            -- do not update $HOME on Windows since I set it manually
            if vim.fn.has('win32') == 1 then
                vim.g.R_set_home_env = 0
            end

            -- do not align function arguments
            vim.g.r_indent_align_args = 0
            -- use two backticks to trigger the Rmarkdown chunk completion
            vim.g.R_rmdchunk = "``"
            -- use <Alt>- to insert assignment
            vim.g.R_assign_map = "<M-->"
            -- show hidden objects in object browser
            vim.g.R_objbr_allnames = 1
            -- show comments when sourced
            vim.g.R_commented_lines = 1
            -- use the same working directory as Vim
            vim.g.R_nvim_wd = 1
            -- highlight chunk header as R code
            vim.g.rmd_syn_hl_chunk = 1
            -- only highlight functions when followed by a parenthesis
            vim.g.r_syntax_fun_pattern = 1
            -- set encoding to UTF-8 when sourcing code
            vim.g.R_source_args = 'echo = TRUE, spaced = TRUE, encoding = "UTF-8"'
            -- number of columns to be offset when calculating R terminal width
            vim.g.R_setwidth = -7

            -- auto quit R when close Vim
            vim.cmd[[
                autocmd VimLeave * if exists("g:SendCmdToR") && string(g:SendCmdToR) != "function('SendCmdToR_fake')" | call RQuit("nosave") | endif
            ]]
        end
    }
    use {
        "mllg/vim-devtools-plugin",
        requires = "jalvesaq/Nvim-R",
        ft = {"r", "rmd", "rnoweb", "rout"},
        config = function()
            -- redefine test current file
            vim.cmd[[ command! -nargs=0 RTestFile :call devtools#test_file() ]]
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
