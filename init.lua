-- ==========================
-- Basic options
-- ==========================
vim.keymap.set("n", "ge", vim.diagnostic.open_float, { desc = "Show error" })
vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.cmd([[set indentexpr=]])
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
-- old line had an invalid "popup" flag; cmp sets completeopt properly later
-- vim.cmd [[set completeopt+=menuone,noselect,popup]]

vim.api.nvim_create_augroup("CppIndent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "CppIndent",
  pattern = { "c", "cpp" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

-- Leader
vim.g.mapleader = " "

-- ==========================
-- lazy.nvim bootstrap
-- ==========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =====================================================
-- ONE PLACE to declare your LSP servers (OLD-STYLE)
-- =====================================================
local lsp_servers = {
  -- C/C++
  clangd = {},

  -- Web stack
  cssls = {},
  tailwindcss = {
    root_dir = function(...)
      return require("lspconfig.util").root_pattern(".git")(...)
    end,
  },
  tsserver = { -- we’ll alias to ts_ls automatically if your lspconfig is new
    root_dir = function(...)
      return require("lspconfig.util").root_pattern(".git")(...)
    end,
    single_file_support = false,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "literal",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = false,
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
  },
  html = {},

  -- Lua
  lua_ls = {
    single_file_support = true,
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        completion = { workspaceWord = true, callSnippet = "Both" },
        misc = { parameters = {} },
        hint = {
          enable = true, setType = false, paramType = true,
          paramName = "Disable", semicolon = "Disable", arrayIndex = "Disable",
        },
        doc = { privateName = { "^_" } },
        type = { castNumberToInteger = true },
        diagnostics = {
          disable = { "incomplete-signature-doc", "trailing-space" },
          groupSeverity = { strong = "Warning", strict = "Warning" },
          groupFileStatus = {
            ambiguity = "Opened", ["await"] = "Opened", codestyle = "None",
            duplicate = "Opened", global = "Opened", luadoc = "Opened",
            redefined = "Opened", strict = "Opened", ["strong"] = "Opened",
            ["type-check"] = "Opened", unbalanced = "Opened", unused = "Opened",
          },
          unusedLocalExclude = { "_*" },
        },
        format = {
          enable = false,
          defaultConfig = {
            indent_style = "space", indent_size = "2", continuation_indent_size = "2",
          },
        },
      },
    },
  },
}

-- Tools we want Mason to install (old-style)
local mason_tools = {
  "luacheck",
  "shellcheck",
  "shfmt",
  "tailwindcss-language-server",
  "typescript-language-server",
  "css-lsp",
}

-- ==========================
-- Plugins
-- ==========================
require("lazy").setup({
  -- LeetCode
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    build = ":TSUpdate html",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    opts = {
      plugins = { non_standalone = true },
      picker  = { provider = "telescope" }, -- switched from mini-picker
      -- lang = "typescript",
    },
  },

  -- Telescope (with file-browser + fzf-native)
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function() return vim.fn.executable("make") == 1 end },
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				"sf",
				function()
					local telescope = require("telescope")
					local function buf_dir()
						local p = vim.fn.expand("%:p:h")
						return (p ~= "" and p) or vim.loop.cwd()
					end
					telescope.extensions.file_browser.file_browser({
						path = "%:p:h",
						cwd = buf_dir(),
						respect_gitignore = false,
						hidden = true,
						grouped = true,
						previewer = false,
						initial_mode = "normal",
						layout_config = { height = 40 },
					})
				end,
				desc = "Telescope: file browser (buffer dir)",
			},
			{
				"<leader>g",
				function()
					local builtin = require("telescope.builtin")
					local root = (function()
						local buf = vim.api.nvim_buf_get_name(0)
						local base = (buf ~= "" and vim.fs.dirname(buf)) or vim.loop.cwd()
						local out  = vim.fn.systemlist(('git -C %s rev-parse --show-toplevel'):format(vim.fn.shellescape(base)))
						if out[1] and out[1] ~= "" and not out[1]:match("^fatal:") then return out[1] end
						local dotgit = vim.fs.find(".git", { upward = true, path = base })[1]
						return (dotgit and vim.fs.dirname(dotgit)) or vim.loop.cwd()
					end)()
					builtin.live_grep({
						cwd = root,
						additional_args = function()
							return { "--hidden", "--follow", "-g", "!.git" }
						end,
					})
				end,
				desc = "Live grep (Git root, hidden, follow)",
			},
			{
				"<leader>f",
				function()
					local builtin = require("telescope.builtin")
					local root = (function()
						local buf = vim.api.nvim_buf_get_name(0)
						local base = (buf ~= "" and vim.fs.dirname(buf)) or vim.loop.cwd()
						local out  = vim.fn.systemlist(('git -C %s rev-parse --show-toplevel'):format(vim.fn.shellescape(base)))
						if out[1] and out[1] ~= "" and not out[1]:match("^fatal:") then return out[1] end
						local dotgit = vim.fs.find(".git", { upward = true, path = base })[1]
						return (dotgit and vim.fs.dirname(dotgit)) or vim.loop.cwd()
					end)()
					builtin.find_files({
						cwd = root,
						hidden = true,
						follow = true,
						no_ignore = false,
					})
				end,
				desc = "Find files (Git root, hidden, follow)",
			},
			{ "<leader>b", function() require("telescope.builtin").buffers() end,   desc = "Buffers" },
			{ "<leader>h", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
		},
	config = function(_, opts)
		local telescope  = require("telescope")
		local actions    = require("telescope.actions")
		local fb_actions = require("telescope").extensions.file_browser.actions

		opts = opts or {}
		local cols  = vim.o.columns
		local lines = vim.o.lines

		opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
			wrap_results     = true,
			layout_strategy  = "horizontal",
			layout_config    = {
				prompt_position = "top",
				width  = cols,       -- integers ✅
				height = lines - 2,  -- leave a tiny margin
				preview_width = math.floor(cols * 0.6),
			},
			sorting_strategy = "ascending",
			winblend         = 0,
			prompt_prefix    = "🔍 ",
			file_ignore_patterns = { "%.git/" },
			mappings = { n = {} },
		})

		opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
			diagnostics = { theme = "ivy", initial_mode = "normal", layout_config = { preview_cutoff = 50 } },
			live_grep   = {
				additional_args = function() return { "--hidden", "--follow", "-g", "!.git" } end,
			},
		})

		-- Important: 'dropdown' theme uses plenary.popup too; give it its own (non-fullscreen) ints
		opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
			file_browser = {
				theme = "dropdown",
				hijack_netrw = true,
				layout_config = { width = math.floor(cols * 0.9), height = math.floor(lines * 0.8) }, -- integers ✅
				mappings = {
					n = {
						["N"] = fb_actions.create,
						["h"] = fb_actions.goto_parent_dir,
						["<C-u>"] = function(prompt_bufnr) for _ = 1, 10 do actions.move_selection_previous(prompt_bufnr) end end,
						["<C-d"]  = function(prompt_bufnr) for _ = 1, 10 do actions.move_selection_next(prompt_bufnr)     end end,
					},
				},
			},
		})

		telescope.setup(opts)
		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "file_browser")
	end,
	},

  -- Colorscheme (transparent)
  {
    "vague2k/vague.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vague").setup({ transparent = true })
      vim.cmd("colorscheme vague")
      vim.cmd(":hi statusline guibg=NONE")
    end,
  },
  
  -- Marks
  {
    "chentoast/marks.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      builtin_marks = { "<", ">", "^" },
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = {},
      excluded_buftypes = {},
      mappings = {},
    },
  },

  -- Oil (file explorer)
  {
    "stevearc/oil.nvim",
    cmd = { "Oil", "OilToggleFloat" },
    keys = {
      { "<leader>e", "<Cmd>Oil<CR>", desc = "Oil" },
      { "<leader>E", function() require("oil").open_float() end, desc = "Oil float" },
      { "<C-f>", "<Cmd>Open .<CR>", desc = "Open cwd" },
    },
    opts = {
      lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
      float = { max_width = 0.7, max_height = 0.6, border = "rounded" },
    },
  },

  -- mini.nvim (keep only bufremove; removed mini.pick)
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete() end, desc = "Buffer delete" },
    },
    config = function()
      require("mini.bufremove").setup()
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "javascript","typescript","tsx","css","html",
        "gitignore","graphql","http","json","scss",
        "sql","vim","lua","rust","ron","c","cpp",
      },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true, disable = { "c", "cpp" } },
      query_linter = { enable = false, use_virtual_text = true, lint_events = { "BufWrite","CursorHold" } },
      autotag = { enable = true },
    },
  },

  -- Typst preview
  { "chomosuke/typst-preview.nvim", ft = { "typst" } },

  -- Mason (tools)
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, mason_tools)
      return opts
    end,
  },

  -- Mason-lspconfig: ensure servers are installed automatically
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = function()
      local servers = {}
      local has_ts_ls = pcall(function() return require("lspconfig.configs").ts_ls or require("lspconfig").ts_ls end)
      for name, _ in pairs(lsp_servers) do
        if name == "tsserver" and has_ts_ls then
          table.insert(servers, "ts_ls")
        else
          table.insert(servers, name)
        end
      end
      return { ensure_installed = servers }
    end,
  },

  -- LSP base
  --{
  --  "neovim/nvim-lspconfig",
  --  event = { "BufReadPre", "BufNewFile" },
  --  dependencies = { "hrsh7th/cmp-nvim-lsp" },  -- ensure cmp_nvim_lsp loads first
  --  opts = {
  --    inlay_hints = { enabled = false },
  --    servers = lsp_servers,
  --  },
  --  config = function(_, opts)
  --    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  --    local capabilities = ok and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

  --    local lspconfig = require("lspconfig")

  --    local function setup_one(server_name, server_opts)
  --      server_opts = server_opts or {}
  --      if server_name == "clangd" then
  --        server_opts.cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" }
  --        server_opts.init_options = { fallbackFlags = { "-std=c++23" } }
  --        server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, {
  --          offsetEncoding = { "utf-16" },
  --        })
  --      else
  --        server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
  --      end
  --      lspconfig[server_name].setup(server_opts)
  --    end

  --    for name, server_opts in pairs(opts.servers or {}) do
  --      setup_one(name, server_opts)
  --    end
  --  end,
  --},
	
	-- new LSP base
	
	{
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  opts = {
    inlay_hints = { enabled = false },
    servers = lsp_servers,
  },
  config = function(_, opts)
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = ok and cmp_nvim_lsp.default_capabilities()
      or vim.lsp.protocol.make_client_capabilities()

    local function setup_one(server_name, server_opts)
      server_opts = server_opts or {}

      if server_name == "clangd" then
        server_opts.cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
					"--compile-commands-dir=build",
        }
        server_opts.init_options = { fallbackFlags = { "-std=c++23" } }
        server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, {
          offsetEncoding = { "utf-16" },
        })
      else
        server_opts.capabilities = vim.tbl_deep_extend(
          "force",
          capabilities,
          server_opts.capabilities or {}
        )
      end

			require("lspconfig")[server_name].setup(server_opts)

    end

    for name, server_opts in pairs(opts.servers or {}) do
      setup_one(name, server_opts)
    end
  end,
	},


  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-emoji",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      vim.o.completeopt = "menu,menuone,noselect"
      vim.o.autoindent = true

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"]    = cmp.mapping.confirm({ select = false }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
          { name = "emoji" },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- cmp ⟷ autopairs
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- LuaSnip
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
      local ls = require("luasnip")
      ls.setup({ enable_autosnippets = true })
      require("luasnip.loaders.from_lua").load({
        paths = vim.fn.expand("~/.config/nvim/snippets/")
      })

      -- LuaSnip mappings
      vim.keymap.set("i", "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
    end,
  },

  -- pear (pairs jumping)
  {
    "SylvanFranklin/pear",
    keys = {
      { "<leader>b", function() require("pear").jump_pair() end, desc = "pear: jump pair" },
    },
  },

	{
		"cpoing/navigator.nvim",
		dir = "~/Documents/lua/navigator.nvim/",
		name = "navigator.nvim",
		opts = {},
		lazy = false,
	}

}, {
  defaults = { lazy = true },
  install = { colorscheme = { "vague" } },
})

-- ==========================
-- Keymaps & misc
-- ==========================
local map = vim.keymap.set
map('n', '<leader>w', '<Cmd>write<CR>')
map('n', '<leader>q', '<Cmd>:quit<CR>')
map('n', '<leader>Q', '<Cmd>:wqa<CR>')
map({ 'n', 'v', 'x' }, ';', ':')
map({ 'n', 'v', 'x' }, ':', ';')

-- open RC files
map('n', '<leader>v', '<Cmd>e $MYVIMRC<CR>')
map('n', '<leader>z', '<Cmd>e ~/.config/zsh/.zshrc<CR>')

-- quick file switching
map('n', '<leader>s', '<Cmd>e #<CR>')
map('n', '<leader>S', '<Cmd>bot sf #<CR>')
map({ 'n', 'v', 'x' }, '<leader>m', ':move ')

-- I use norm so much
map({ 'n', 'v' }, '<leader>n', ':norm ')

-- system clipboard
vim.opt.clipboard = "unnamedplus"
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>d', '"+d')
map({ 'n', 'v' }, '<leader>c', ':')

-- soft reload config file
map({ 'n', 'v' }, '<leader>o', ':update<CR> :source<CR>')

-- terminal tweaks
map('t', '<Esc>', [[<C-\><C-n>]])
map('t', '<C-o>', [[<C-\><C-o>]])

-- LSP helpers
map('n', '<leader>lf', vim.lsp.buf.format)

-- window sizing
map("n", "<M-n>", "<cmd>resize +2<CR>")
map("n", "<M-e>", "<cmd>resize -2<CR>")
map("n", "<M-i>", "<cmd>vertical resize +5<CR>")
map("n", "<M-m>", "<cmd>vertical resize -5<CR>")

-- insert-mode spell-ish fix
map("i", "<C-s>", "<c-g>u<Esc>[s1z=`]a<c-g>u")

-- QuickFix helpers
map("n", "<C-q>", ":copen<CR>", { silent = true })
for i = 1, 9 do
  map('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
end
map("n", "<leader>a", function()
  vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%"), } }, "a")
end, { desc = "Add current file to QuickFix" })

-- QuickFix buffer local maps
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("qf", { clear = true }),
  callback = function()
    if vim.bo.buftype == "quickfix" then
      map("n", "<C-q>", ":ccl<cr>", { buffer = true, silent = true })
      map("n", "dd", function()
        local idx = vim.fn.line('.')
        local qflist = vim.fn.getqflist()
        table.remove(qflist, idx)
        vim.fn.setqflist(qflist, 'r')
      end, { buffer = true })
    end
  end,
})

-- For languages where you want “classic” Vim indent rules
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function()
    vim.opt_local.indentexpr = ""   -- ensure no custom indentexpr steals control
  end,
})
