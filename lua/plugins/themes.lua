return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox",
    },
  },
  { "shaunsingh/oxocarbon.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "water-sucks/darkrose.nvim" },
  { "baliestri/aura-theme" },
  { "projekt0n/github-nvim-theme" },
  { "catppuccin/nvim" },
  { "ray-x/starry.nvim" },

  -- Make background transparent
  {
    "xiyaowong/nvim-transparent",
    lazy = false,
    config = function()
      require("transparent").setup({
        extra_groups = { "NvimTreeNormal", "FloatBorder" },
      })
    end,
  },

  -- Associate theme to filetype
  {
    "folke/styler.nvim",
    event = "VeryLazy",
    config = {
      themes = {
        markdown = { colorscheme = "tokyonight-storm" },
        help = { colorscheme = "oxocarbon", background = "dark" },
      },
    },
  },
}
