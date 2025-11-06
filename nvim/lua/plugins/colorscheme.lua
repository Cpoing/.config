return {
  {
    "vague2k/vague.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other plugins
    config = function()
      -- NOTE: you do not need to call setup if you don't want to.
      require("vague").setup({
        -- optional configuration here
      })
      vim.cmd("colorscheme vague")
    end,
  },
  {
    "sainnhe/everforest",
    --config = function()
    --  vim.cmd.colorscheme("vim")
    --  vim.cmd([[
    --    highlight Pmenu guibg=#1e1e2e guifg=#c0caf5
    --    highlight PmenuSel guibg=#33467C guifg=#ffffff
    --  ]])
    --end,
  },
  {
    "sainnhe/edge",
  },
  {
    "sainnhe/sonokai",
  },
  {
    "Yazeed1s/oh-lucy.nvim",
  },
  {
    "projekt0n/github-nvim-theme",
  },
  {
    "Alexis12119/nightly.nvim",
  },
  {
    "catppuccin/nvim",
  },
  {
    "shaunsingh/nord.nvim",
  },
  {
    "rebelot/kanagawa.nvim",
  },
  {
    "aliqyan-21/darkvoid.nvim",
  },
  --{
  --  "folke/tokyonight.nvim",
  --  lazy = false,
  --  opts = {
  --    style = "night",
  --    transparent = true,
  --    terminal_colors = true,
  --    styles = {
  --      sidebars = "transparent",
  --      floats = "transparent",
  --    },
  --  },
  --  --config = function(_, opts)
  --  --  require("tokyonight").setup(opts)
  --  --  vim.cmd("colorscheme tokyonight")
  --  --end,
  --},
  {
    "navarasu/onedark.nvim",
    --config = function()
    --  require("onedark").setup({})
    --  vim.cmd.colorscheme("onedark")
    --end,
  },

  --{
  --  "catppuccin/nvim",
  --  name = "catppuccin",
  --  --priority = 1000, -- Ensure it's loaded early
  --  opts = {
  --    term_colors = true,
  --    transparent_background = false,
  --    styles = {
  --      comments = {},
  --      conditionals = {},
  --      loops = {},
  --      functions = {},
  --      keywords = {},
  --      strings = {},
  --      variables = {},
  --      numbers = {},
  --      booleans = {},
  --      properties = {},
  --      types = {},
  --    },
  --    --color_overrides = {
  --    --  mocha = {
  --    --    base = "#000000",
  --    --    mantle = "#000000",
  --    --    crust = "#000000",
  --    --  },
  --    --},
  --    integrations = {
  --      telescope = true,
  --      nvimtree = true, -- Ensure nvim-tree integration is enabled
  --    },
  --  },
  --},
  --{
  --  "LazyVim/LazyVim",
  --  opts = {
  --    colorscheme = "catppuccin",
  --  },
  --},
  { "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
  {
    "sainnhe/gruvbox-material",
  },
  { "morhetz/gruvbox" },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        styles = {
          transparency = true,
        },
      })
      --vim.cmd("colorscheme rose-pine")
    end,
  },

  require("catppuccin").setup({
    flavour = "frappe",
    transparent_background = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  }),
}
