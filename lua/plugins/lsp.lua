return {
  --  null ls [code formatting]
  --  https://github.com/jose-elias-alvarez/null-ls.nvim
  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   dependencies = {
  --     {
  --       "jay-babu/mason-null-ls.nvim",
  --       cmd = { "NullLsInstall", "NullLsUninstall" },
  --       opts = { handlers = {} },
  --     },
  --   },
  --   event = "User File",
  --   opts = function()
  --     local nls = require("null-ls")
  --     return {
  --       sources = {
  --         nls.builtins.formatting.beautysh.with({
  --           command = "beautysh",
  --           args = {
  --             "--indent-size=2",
  --             "$FILENAME",
  --           },
  --         }),
  --       },
  --       on_attach = require("base.utils.lsp").on_attach,
  --     }
  --   end,
  -- },
  {
    "neovim/nvim-lspconfig",
    -- dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },

              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            if client.name == "tsserver" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>",
                { buffer = buffer, desc = "Organize Imports" })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>",
                { desc = "Rename File", buffer = buffer })
            end
          end)
          -- require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
  },
  --  null ls [code formatting]
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      {
        "ThePrimeagen/refactoring.nvim",
        keys = {
          {
            "<leader>r",
            function()
              require("refactoring").select_refactor()
            end,
            mode = "v",
            noremap = true,
            silent = true,
            expr = false,
          },
        },
        config = {},
      },

      {
        "danymat/neogen",
        config = { snippet_engine = "luasnip" },
      },
      {
        "lvimuser/lsp-inlayhints.nvim",
        event = "LspAttach",
        branch = "anticonceal",
        opts = {},
        init = function()
          vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
            callback = function(args)
              if not (args.data and args.data.client_id) then
                return
              end
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              require("lsp-inlayhints").on_attach(client, args.buf, false)
            end,
          })
        end,
      },
    },
    opt = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.fish_indent,
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
          -- nls.builtins.diagnostics.flake8,
          nls.builtins.diagnostics.markdownlint,
          -- nls.builtins.diagnostics.luacheck,
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.sqlfluff.with({
            extra_args = { "--dialect", "postgres" }, -- change to your dialect
          }),
          nls.builtins.formatting.pg_format,

          nls.builtins.diagnostics.tsc.with({
            extra_args = { "--noEmit", "--skipLibCheck", "--incremental" },
          }),
          nls.builtins.diagnostics.selene.with({
            condition = function(utils)
              return utils.root_has_file({ "selene.toml" })
            end,
          }),
          -- nls.builtins.code_actions.gitsigns,
          nls.builtins.formatting.isort,
          nls.builtins.formatting.black,
          nls.builtins.diagnostics.flake8,

          -- Cspell
          nls.builtins.diagnostics.cspell.with({
            -- Force the severity to be HINT
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity.HINT
            end,
          }),
          nls.builtins.code_actions.cspell,

          nls.builtins.code_actions.gitsigns,

          -- Refactoring
          nls.builtins.code_actions.refactoring,

          null_ls.builtins.code_actions.ts_node_action,
        },
      }
    end,
  },
}
