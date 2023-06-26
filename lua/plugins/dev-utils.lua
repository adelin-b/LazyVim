return {

  -- run commands
  -- TODO: change keymaps for c-l c-k c-h c-j
  -- TODO: make sure its working well with edgy
  {
    "stevearc/overseer.nvim",
    config = function()
      require("overseer").setup({
        -- Template modules to load
        templates = { "builtin" },
        task_list = {
          bindings = {
            ["?"] = "ShowHelp",
            ["g?"] = "ShowHelp",
            ["<CR>"] = "RunAction",
            ["<C-e>"] = "Edit",
            ["o"] = "Open",
            ["<C-v>"] = "OpenVsplit",
            ["<C-s>"] = "OpenSplit",
            ["<C-f>"] = "OpenFloat",
            ["<C-q>"] = "OpenQuickFix",
            ["p"] = "TogglePreview",
            ["<M-l>"] = "IncreaseDetail",
            ["<M-h>"] = "DecreaseDetail",
            ["L"] = "IncreaseAllDetail",
            ["H"] = "DecreaseAllDetail",
            ["["] = "DecreaseWidth",
            ["]"] = "IncreaseWidth",
            ["{"] = "PrevTask",
            ["}"] = "NextTask",
            ["<C-u>"] = "ScrollOutputUp",
            ["<C-d>"] = "ScrollOutputDown",
          },
        },
      })
    end,
  },

  -- toggle word under cursor
  { "adelin-b/Voggle", event = "BufReadPost" },

  { "tpope/vim-abolish", event = "BufReadPost" },

  {
    "simrat39/symbols-outline.nvim",
    config = true,
  },

  -- align code
  { "junegunn/vim-easy-align", cmd = "EasyAlign" },

  -- show code in regions
  {
    "chrisbra/NrrwRgn",
    event = "VeryLazy",
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      -- suggestion = { enabled = false },
      -- panel = { enabled = false },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-w>",
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },

      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>cS",
        function()
          require("ssr").open()
        end,
        mode = { "n", "x" },
        desc = "Structural Replace",
      },
    },
  },
}
