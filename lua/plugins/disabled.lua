-- Disabled plugin, to review

D = {
  {
    -- highligh args
    "m-demare/hlargs.nvim",
    event = "VeryLazy",
    enabled = false,
    config = {
      excluded_argnames = {
        usages = {
          lua = { "self", "use" },
        },
      },
    },
  },

  { "junegunn/vim-easy-align", cmd = "EasyAlign" },

  {
    -- Diabled because there is a warning at the start
    enabled = false,
    "luukvbaal/statuscol.nvim",
    config = function()
      require("statuscol").setup()
    end,
    event = "VeryLazy",
  },
  { "tpope/vim-fugitive", cmd = { "G", "Git" } },
  { "tpope/vim-rhubarb", cmd = { "Gbrowse" } },
}
return {}
