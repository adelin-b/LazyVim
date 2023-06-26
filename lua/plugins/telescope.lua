return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["<c-t>"] = function(...)
              return require("trouble.providers.telescope").open_with_trouble(...)
            end,
            ["<a-t>"] = function(...)
              return require("trouble.providers.telescope").open_selected_with_trouble(...)
            end,
            ["<a-i>"] = function()
              local action_state = require("telescope.actions.state")
              local line = action_state.get_current_line()
              Util.telescope("find_files", { no_ignore = true, default_text = line })()
            end,
            ["<a-h>"] = function()
              local action_state = require("telescope.actions.state")
              local line = action_state.get_current_line()
              Util.telescope("find_files", { hidden = true, default_text = line })()
            end,

            ["<C-n>"] = require("telescope.actions").cycle_history_next,
            ["<C-p>"] = require("telescope.actions").cycle_history_prev,
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            ["<Esc>"] = require("telescope.actions").close,
            ["<C-h>"] = "which_key",
          },
          n = {
            ["q"] = function(...)
              return require("telescope.actions").close(...)
            end,
          },
        },
      },
    },
  },
}
