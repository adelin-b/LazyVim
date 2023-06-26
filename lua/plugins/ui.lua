-- variable to use nvim cmp for command line or wilder
local command_line_completion = "cmp"
local is_neovide = vim.fn.exists("g:neovide") == 1
-- command_line_completion = "wilder"

return {
  -- Command line completion
  {
    "hrsh7th/nvim-cmp",
    enabled = command_line_completion == "cmp",

    dependencies = { "hrsh7th/cmp-emoji", "hrsh7th/cmp-cmdline" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        {
          -- TODO: add cmp-git
          -- TODO: add cmp-x (search nice one)
          name = "emoji",
        },
      }))
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },
  {
    enabled = command_line_completion == "wilder",
    event = "VeryLazy",
    "gelguy/wilder.nvim",
    dependencies = {
      "romgrk/fzy-lua-native",
      "nixprime/cpsm",
      "roxma/nvim-yarp",
      "roxma/vim-hug-neovim-rpc",
    },
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })

      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.python_file_finder_pipeline({
            file_command = function(ctx, arg)
              if string.find(arg, ".") ~= nil then
                return { "fd", "-tf", "-H" }
              else
                return { "fd", "-tf" }
              end
            end,
            dir_command = { "fd", "-td" },
            filters = { "cpsm_filter" },
          }),
          wilder.substitute_pipeline({
            pipeline = wilder.python_search_pipeline({
              skip_cmdtype_check = 1,
              pattern = wilder.python_fuzzy_pattern({
                start_at_boundary = 0,
              }),
            }),
          }),
          wilder.cmdline_pipeline({
            fuzzy = 2,
            fuzzy_filter = wilder.lua_fzy_filter(),
          }),
          {
            wilder.check(function(ctx, x)
              return x == ""
            end),
            wilder.history(),
          },

          wilder.vim_search_pipeline()
        ),
      })

      local highlighters = {
        -- wilder.pcre2_highlighter(),
        wilder.lua_fzy_highlighter(),
      }

      local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
        border = "rounded",
        highlights = {
          border = "Normal",
          -- background = { "Normal" },
        },
        empty_message = wilder.popupmenu_empty_message_with_spinner(),
        highlighter = highlighters,
        left = {
          " ",
          wilder.popupmenu_devicons(),
          wilder.popupmenu_buffer_flags({
            flags = " a + ",
            icons = { ["+"] = "", a = "", h = "" },
          }),
        },
        right = {
          " ",
          wilder.popupmenu_scrollbar(),
        },
      }))

      popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_palette_theme({
        -- 'single', 'double', 'rounded' or 'solid'
        -- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
        border = "rounded",
        max_height = "75%", -- max height of the palette
        min_height = 0, -- set to the same as 'max_height' for a fixed height window
        prompt_position = "top", -- 'top' or 'bottom' to set the location of the prompt
        reverse = 0, -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'

        empty_message = wilder.popupmenu_empty_message_with_spinner(),
        highlighter = highlighters,
        left = {
          " ",
          wilder.popupmenu_devicons(),
          wilder.popupmenu_buffer_flags({
            flags = " a + ",
            icons = { ["+"] = "", a = "", h = "" },
          }),
        },
        right = {
          " ",
          wilder.popupmenu_scrollbar(),
        },
      }))

      local wildmenu_renderer = wilder.wildmenu_renderer({
        highlighter = highlighters,
        separator = " · ",
        left = { " ", wilder.wildmenu_spinner(), " " },
        right = { " ", wilder.wildmenu_index() },
      })

      wilder.set_option(
        "renderer",
        wilder.renderer_mux({
          [":"] = popupmenu_renderer,
          -- ["/"] = wildmenu_renderer,
          ["/"] = popupmenu_renderer,
          -- substitute = wildmenu_renderer,
          substitute = popupmenu_renderer,
        })
      )
    end,
  },

  -- window picker
  -- FIXME: graphic bug with edgy, the filename appear on all windows while picking
  {

    -- only needed if you want to use the commands with "_with_window_picker" suffix
    "s1n7ax/nvim-window-picker",
    -- tag = "v1.*",
    config = function()
      require("window-picker").setup({
        autoselect_one = true,
        include_current = false,
        hint = "statusline-winbar",
        -- hint = "floating-big-letter",
        filter_rules = {
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify", "Overseer*", "Outline", "Trouble", "edgy" },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },

  -- Auto resize windows
  {
    enabled = true,
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
      { "anuvyklack/animation.nvim", enabled = false },
    },
    config = function()
      vim.o.winwidth = 5
      vim.o.winminwidth = 5
      vim.o.equalalways = false
      require("windows").setup({
        animation = {
          enable = false,
          duration = 0,
        },
        ignore = {
          buftype = { "quickfix" },
          filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "Mundo", "Trouble" },
        },
      })
      vim.keymap.set("n", "<leader>Z", "<Cmd>WindowsMaximize<CR>")
    end,
  },

  {
    "folke/trouble.nvim",
    enabled = true,
    cmd = { "TroubleToggle", "Trouble" },
    config = {
      auto_open = true,
      auto_close = true,
      use_diagnostic_signs = true, -- en
    },
  },

  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ue",
        function()
          require("edgy").toggle()
        end,
        desc = "Edgy Toggle",
      },
    -- stylua: ignore
    { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
    },
    opts = function()
      local opts = {

        animate = {
          enabled = false,
        },
        bottom = {
          {
            ft = "toggleterm",
            size = { height = 0.4 },
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "noice",
            size = { height = 0.4 },
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "lazyterm",
            title = "LazyTerm",
            size = { height = 0.4 },
            filter = function(buf)
              return not vim.b[buf].lazyterm_cmd
            end,
          },
          "Trouble",
          { ft = "qf", title = "QuickFix" },
          {
            ft = "help",
            size = { height = 20 },
            -- don't open help files in edgy that we're editing
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
          { ft = "spectre_panel", size = { height = 0.4 } },
          { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
        },
        left = {
          {
            title = "Neo-Tree",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "filesystem"
            end,
            pinned = true,
            open = function()
              vim.api.nvim_input("<esc><space>e")
            end,
            size = { height = 0.5 },
          },
          { title = "Neotest Summary", ft = "neotest-summary" },
          {
            title = "Neo-Tree Git",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "git_status"
            end,
            pinned = true,
            open = "Neotree position=right git_status",
          },
          {
            title = "Neo-Tree Buffers",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "buffers"
            end,
            pinned = true,
            open = "Neotree position=top buffers",
          },
          "neo-tree",
        },
        keys = {
          -- increase width
          ["<c-Right>"] = function(win)
            win:resize("width", 2)
          end,
          -- decrease width
          ["<c-Left>"] = function(win)
            win:resize("width", -2)
          end,
          -- increase height
          ["<c-Up>"] = function(win)
            win:resize("height", 2)
          end,
          -- decrease height
          ["<c-Down>"] = function(win)
            win:resize("height", -2)
          end,
        },
      }
      local Util = require("lazyvim.util")
      if Util.has("symbols-outline.nvim") then
        table.insert(opts.left, {
          title = "Outline",
          ft = "Outline",
          pinned = true,
          open = "SymbolsOutline",
          size = { height = 0.3 },
        })
      end
      if Util.has("overseer.nvim") then
        table.insert(opts.left, {
          title = "Overseer",
          ft = "OverseerList",
          pinned = true,
          open = "OverseerOpen",
          size = { height = 0.3 },
        })
      end
      return opts
    end,
  },

  -- Display code blocks by making blocks on the background
  -- Very visual but mess with the virtual text and don't work with transparency
  {
    "HampusHauffman/block.nvim",
    cmd = { "Block", "BlockOn", "BlockOff" },
    config = function()
      require("block").setup({
        percent = 0.8,
        depth = 4,
        colors = nil,
        automatic = false,
      })
    end,
  },

  -- Allow to zoom in/out the GUI
  -- FIXME: Doesn't work atm
  {
    "drzel/vim-gui-zoom",
    cmd = {
      "ZoomIn",
      "ZoomOut",
    },
  },

  -- FIXME: bad integration with edgy, resize itself
  {
    "simnalamburt/vim-mundo",
    cmd = "MundoToggle",
    config = function()
      vim.g.mundo_right = 1
    end,
  },

  -- Display buffer name on top left
  {
    "b0o/incline.nvim",
    event = "BufReadPre",

    config = function()
      if vim.g.started_by_firenvim then
        return
      end

      local function get_diagnostic_label(props)
        local icons = {
          Error = "",
          Warn = "",
          Info = "",
          Hint = "",
        }

        local label = {}
        for severity, icon in pairs(icons) do
          local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
          if n > 0 then
            local fg = "#"
              .. string.format("%06x", vim.api.nvim_get_hl_by_name("DiagnosticSign" .. severity, true)["foreground"])
            table.insert(label, { icon .. " " .. n .. " ", guifg = fg })
          end
        end
        return label
      end

      local function get_saved_label(props)
        local label = {}
        if vim.api.nvim_buf_get_option(props.buf, "modified") then
          table.insert(label, { " ", guifg = "#aa2222" })
        end
        return label
      end

      local colors = require("tokyonight.colors").setup()

      require("incline").setup({
        debounce_threshold = { falling = 500, rising = 250 },
        render = function(props)
          local bufname = vim.api.nvim_buf_get_name(props.buf)
          local filename = vim.fn.fnamemodify(bufname, ":t")
          local diagnostics = get_diagnostic_label(props)
          local saved = get_saved_label(props)
          local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "None"
          local filetype_icon, color = require("nvim-web-devicons").get_icon_color(filename)

          local buffer = {
            { filetype_icon, guifg = color },
            { " " },
            { filename, gui = modified },
          }

          if #diagnostics > 0 then
            table.insert(diagnostics, { "| ", guifg = "grey" })
          end
          for _, buffer_ in ipairs(buffer) do
            table.insert(diagnostics, buffer_)
          end

          for _, saved_ in ipairs(saved) do
            table.insert(diagnostics, saved_)
          end

          return diagnostics
        end,
      })

      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = {
              default = true,
              group = "NormalFloat",
            },
            InclineNormalNC = {
              default = true,
              group = "NormalFloat",
            },
          },
        },
        window = {
          margin = {
            vertical = 0,
            horizontal = 1,
          },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return {
            { icon, guifg = color },
            { " " },
            { filename },
          }
        end,
      })
    end,
  },

  {
    "folke/noice.nvim",
    enabled = not is_neovide, -- makes neovide crash
  },

  -- Show the ts context in bottom bar statusline
  {
    "SmiteshP/nvim-navic",
    enabled = false, -- slow down and make it lag when j or k in neovide
  },
}
