return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "petertriho/cmp-git",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      local git = require("cmp_git").setup()

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "git" },
        { name = "emoji" },
      }))
    end,
  },
}
