return {
  -- Treesitter core
  {
    "nvim-treesitter/nvim-treesitter",
    -- Unpin to stay compatible with Neovim 0.11.x fixes
    version = false, -- or branch = "master"
    build = ":TSUpdate", -- keep parsers fresh
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "css",
        "gitignore",
        "graphql",
        "http",
        "json",
        "scss",
        "sql",
        "vim",
        "lua",
        "rust",
        "ron",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      -- The linter can throw on out-of-date queries; start with it off
      query_linter = {
        enable = false,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      -- If you use autotag through TS, enable here too (plugin below must be installed)
      autotag = { enable = true },
    },
  },

  -- Autotag must be its own plugin entry
  {
    "windwp/nvim-ts-autotag",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {}, -- default settings
  },
}

--return {
--  {
--    "nvim-treesitter/nvim-treesitter",
--    tag = "v0.9.1",
--    opts = {
--      ensure_installed = {
--        "javascript",
--        "typescript",
--        "tsx",
--        "css",
--        "gitignore",
--        "graphql",
--        "http",
--        "json",
--        "scss",
--        "sql",
--        "vim",
--        "lua",
--        --"cpp",
--        "rust",
--        "ron",
--      },
--      indent = { enable = true }, -- enable treesitter-based indentation
--      query_linter = {
--        enable = true,
--        use_virtual_text = true,
--        lint_events = { "BufWrite", "CursorHold" },
--      },
--      {
--        "windwp/nvim-ts-autotag",
--        opts = {},
--      },
--    },
--  },
--}
