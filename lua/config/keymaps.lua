-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Basic vim override for speed this will change default vim behavior
-- remap ; to : in normal and visual mode, not insert mode
vim.keymap.set({ "n", "v" }, ";", ":", { noremap = true })
-- disable : in normal and visual mode, not insert mode
-- vim.keymap.set({ "n", "v" }, ":", "<nop>", { noremap = true })

-- Go to start and end of line with H and L
vim.keymap.set("", "H", "^")
vim.keymap.set("", "L", "$")

-- TODO: install the plugin and add the keymaps
vim.keymap.set("n", "<C-+>", ":ZoomIn<cr>")
vim.keymap.set("n", "<C-_>", ":ZoomOut<cr>")

-- makes * and # work on visual mode too. take the current selection and search for it
vim.cmd([[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction
  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>

  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]])

-- Default lazyvim
---- This file is automatically loaded by lazyvim.config.init
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
if Util.has("bufferline.nvim") then
  map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

if not Util.has("trouble.nvim") then
  map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
  map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
end

-- stylua: ignore start

-- toggle options
map("n", "<leader>uf", require("lazyvim.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function() Util.toggle("relativenumber", true) Util.toggle("number") end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
if vim.lsp.buf.inlay_hint then
  map("n", "<leader>uh", function() vim.lsp.buf.inlay_hint(0, nil) end, { desc = "Toggle Inlay Hints" })
end

-- lazygit
map("n", "<leader>gg", function() Util.float_term({ "lazygit" }, { cwd = Util.get_root(), esc_esc = false, ctrl_hjkl = false }) end, { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function() Util.float_term({ "lazygit" }, {esc_esc = false, ctrl_hjkl = false}) end, { desc = "Lazygit (cwd)" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- floating terminal
local lazyterm = function() Util.float_term(nil, { cwd = Util.get_root() }) end
-- map("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
-- map("n", "<leader>fT", function() Util.float_term() end, { desc = "Terminal (cwd)" })
-- map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
-- map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })


local wk = require("which-key")

wk.setup({
  show_help = false,
  triggers = "auto",
  plugins = { spelling = true },
  key_labels = { ["<leader>"] = "SPC" },
})

local leader = {
  a = {
    name = "+Apps",
    o = {
      name = "Overseer",
      t = { "<cmd>OverseerToggle<cr>", "Toggle" },
      r = { "<cmd>OverseerRun<cr>", "Run" },
      s = { ":OverseerSaveBundle", "Save" },
      l = { "<cmd>OverseerLoadBundle<cr>", "Load" },
    },
  },
  w = {
    name = "+windows",
    ["w"] = { "<C-W>p", "other-window" },
    ["d"] = { "<C-W>c", "delete-window" },
    ["-"] = { "<C-W>s", "split-window-below" },
    ["|"] = { "<C-W>v", "split-window-right" },
    ["2"] = { "<C-W>v", "layout-double-columns" },
    ["h"] = { "<C-W>h", "window-left" },
    ["j"] = { "<C-W>j", "window-below" },
    ["l"] = { "<C-W>l", "window-right" },
    ["k"] = { "<C-W>k", "window-up" },
    ["H"] = { "<C-W>5<", "expand-window-left" },
    ["J"] = { ":resize +5", "expand-window-below" },
    ["L"] = { "<C-W>5>", "expand-window-right" },
    ["K"] = { ":resize -5", "expand-window-up" },
    ["="] = { "<C-W>=", "balance-window" },
    ["s"] = { "<C-W>s", "split-window-below" },
    ["v"] = { "<C-W>v", "split-window-right" },
  },
  c = {
    name = "+code",
    c = { "<cmd>Neogen<cr>", "Comment docs" },
  },
  b = {
    name = "+buffer",
    ["b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
    ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    -- ["D"] = { "<cmd>:bd<CR>", "Delete Buffer & Window" },
  },
  g = {
    name = "+git",
    l = {
      name = "+lazygit",
      l = { "<cmd>LazyGit<cr>", "LazyGit" },
      c = { "<cmd>LazyGitCurrentFile<cr>", "current file" },
      f = { "<cmd>LazyGitFilter<cr>", "filter" },
      C = { "<cmd>LazyGitFilter<cr>", "filter current file" },
    },
    c = { "<Cmd>Telescope git_commits<CR>", "commits" },
    b = { "<Cmd>Telescope git_branches<CR>", "branches" },
    s = { "<Cmd>Telescope git_status<CR>", "status" },
    d = {
      name = "+DiffView",
      d = { "<cmd>DiffviewOpen<cr>", "Open" },
      q = { "<cmd>DiffviewClose<cr>", "Quit" },
      t = { "<cmd>DiffviewToggleFiles<cr>", "Toggle files" },
      h = { "<cmd>DiffviewFileHistory<cr>", "History" },
      H = { "<cmd>DiffviewFileHistory %<cr>", "Current file history" },
      -- with ...branch
      w = {
        function()
          -- pick branch / commit with telescope
          -- then diff with current branch
          require("telescope.builtin").git_branches({
            attach_mappings = function(prompt_bufnr, map)
              map("i", "<CR>", function()
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)

                vim.cmd("DiffviewOpen " .. selection.value)
              end)
              return true
            end,
          })
        end,
        "diff with ...",
      },
    },
    H = {
      name = "+Github",
      c = {
        name = "+Commits",
        c = { "<cmd>GHCloseCommit<cr>", "Close" },
        e = { "<cmd>GHExpandCommit<cr>", "Expand" },
        o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
        p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
        z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
      },
      i = {
        name = "+Issues",
        p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
      },
      l = {
        name = "+Litee",
        t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
      },
      r = {
        name = "+Review",
        b = { "<cmd>GHStartReview<cr>", "Begin" },
        c = { "<cmd>GHCloseReview<cr>", "Close" },
        d = { "<cmd>GHDeleteReview<cr>", "Delete" },
        e = { "<cmd>GHExpandReview<cr>", "Expand" },
        s = { "<cmd>GHSubmitReview<cr>", "Submit" },
        z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
      },
      p = {
        name = "+Pull Request",
        c = { "<cmd>GHClosePR<cr>", "Close" },
        d = { "<cmd>GHPRDetails<cr>", "Details" },
        e = { "<cmd>GHExpandPR<cr>", "Expand" },
        o = { "<cmd>GHOpenPR<cr>", "Open" },
        p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
        r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
        t = { "<cmd>GHOpenToPR<cr>", "Open To" },
        z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
      },
      t = {
        name = "+Threads",
        c = { "<cmd>GHCreateThread<cr>", "Create" },
        n = { "<cmd>GHNextThread<cr>", "Next" },
        t = { "<cmd>GHToggleThread<cr>", "Toggle" },
      },
    },
    h = { name = "+hunk" },
  },
  ["h"] = {
    name = "+help",
    t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
    c = { "<cmd>:Telescope commands<cr>", "Commands" },
    h = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
    m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
    k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
    s = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
    l = { vim.show_pos, "Highlight Groups at cursor" },
    f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
    o = { "<cmd>:Telescope vim_options<cr>", "Options" },
    a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
    p = {
      name = "+packer",
      p = { "<cmd>PackerSync<cr>", "Sync" },
      s = { "<cmd>PackerStatus<cr>", "Status" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      c = { "<cmd>PackerCompile<cr>", "Compile" },
    },
  },
  s = {
    name = "+search",
    g = { "<cmd>Telescope live_grep<cr>", "Grep" },
    b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
    s = {
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        })
      end,
      "Goto Symbol",
    },
    h = { "<cmd>Telescope command_history<cr>", "Command History" },
    m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
    r = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
  },
  f = {
    name = "+file",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    s = { ":w<cr>", "Save" },
    S = { ":wa<cr>", "Save all" },
    ['!'] = { function() vim.cmd "SudaWrite" end,  "Save as sudo" },
    n = { "<cmd>enew<cr>", "New File" },
    o = { "<cmd>Neotree reveal<cr>", "open in neotree" },
    z = "Zoxide",
    c = {
      name = "config",
      k = {
        ":e ~/.config/nvim/lua/config/keymaps.lua<cr>",
        "keymap",
      },
      o = {

        ":e ~/.config/nvim/lua/config/options.lua<cr>",
        "options",
      },
      f = {
        function()
          require("telescope.builtin").find_files({
            prompt_title = "Find Config File",
            cwd = "~/.config/nvim/lua/",
          })
        end,
        "files",
      },
      g = {
        function()
          -- grep config files
          require("telescope.builtin").live_grep({
            prompt_title = "Grep Config Files",
            cwd = "~/.config/nvim/lua/",
          })
        end,
        "grep files",
      },
      s = {
        -- open snippet that matches the current filetypes
        function()
          local ft = vim.bo.filetype

          vim.cmd(":e ~/.config/nvim/snippets/" .. ft .. ".snippets")
        end,
        "snippet",
      },
      p = {

        function()
          require("telescope.builtin").find_files({
            prompt_title = "Find Plugin File",
            cwd = "~/.config/nvim/lua/plugins",
          })
        end,
        "plugins",
      },
    },
  },
  o = {
    name = "+open",
    g = { "<cmd>Glow<cr>", "Markdown Glow" },
  },
  p = {
    name = "+project",
    o = { ":Telescope projects<cr>", "Open project" },
  },
  t = {
    name = "+toggle",
    -- TODO: update config
    -- f = {
    --   -- require("plugins.lsp.formatting").toggle,
    --   "Format on Save",
    -- },
    s = {
      function()
        Util.toggle("spell")
      end,
      "Spelling",
    },
    a = { ":AerialToggle<cr>", "Aerial" },
    u = { ":MundoToggle<cr>", "Undo tree" },
    l = {
      name = "lsp",
      l = {
        name = "+Lsp Lines",
        l = {
          function()
            require("lsp_lines").toggle()

            vim.g.toggle_virtual_lines = not vim.g.toggle_virtual_lines

            local virtual_line_opts = {
              only_current_line = vim.g.toggle_virtual_line_only_current_line,
            }

            vim.diagnostic.config({
              virtual_text = not vim.g.toggle_virtual_lines and vim.g.virtual_text_options,
              virtual_lines = vim.g.toggle_virtual_lines and virtual_line_opts,
            })
          end,
          "toggle lines",
        },

        o = {
          function()
            vim.g.toggle_virtual_line_only_current_line = not vim.g.toggle_virtual_line_only_current_line

            local virtual_line_opts = {
              only_current_line = vim.g.toggle_virtual_line_only_current_line,
            }

            vim.diagnostic.config({
              virtual_text = vim.g.toggle_virtual_line_only_current_line and vim.g.virtual_text_options,
              virtual_lines = virtual_line_opts,
            })
          end,
          "toggle only current line",
        },
      },
    },
    w = {
      function()
        Util.toggle("wrap")
      end,
      "Word Wrap",
    },
    n = {
      function()
        Util.toggle("relativenumber", true)
        Util.toggle("number")
      end,
      "Line Numbers",
    },
  },
  ["<tab>"] = {
    name = "tabs",
    ["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },
    n = { "<cmd>tabnext<CR>", "Next" },
    d = { "<cmd>tabclose<CR>", "Close" },
    p = { "<cmd>tabprevious<CR>", "Previous" },
    ["]"] = { "<cmd>tabnext<CR>", "Next" },
    ["["] = { "<cmd>tabprevious<CR>", "Previous" },
    f = { "<cmd>tabfirst<CR>", "First" },
    l = { "<cmd>tablast<CR>", "Last" },
  },
  ["/"] = {
    name = "+search",
    ["/"] = { "<cmd>Telescope<cr>", "Buffer" },
    a = { "<cmd>Telescope lsp_code_actions<cr>", "Code Actions" },
    b = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Buffer" },
    c = { "<cmd>Telescope commands<cr>", "Commands" },
    C = { "<cmd>Telescope neoclip<cr>", "Clipboard" },
    d = { "<cmd>Telescope lsp_definitions<cr>", "Definitions" },
    D = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics" },
    g = { "<cmd>Telescope live_grep<cr>", "Grep" },
    i = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    l = { "<cmd>Telescope loclist<cr>", "Loclist" },
    O = { "<cmd>Telescope vim_options options_only=true<cr>", "Options Only" },
    p = { "<cmd>Telescope projects<cr>", "Projects" },
    Q = { "<cmd>Telescope macroscope<cr>", "Macros" },
    q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
    r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
    T = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
    t = { "<cmd>Telescope treesitter<cr>", "Treesitter" },
    w = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
    z = { "<cmd>Telescope spell_suggest<cr>", "Spell Suggest" },
  },
  [":"] = { "<cmd>Telescope command_history<cr>", "Command History" },
  q = {
    name = "+quit/session",
    q = { "<cmd>qa<cr>", "Quit" },
    ["!"] = { "<cmd>:qa!<cr>", "Quit without saving" },
    s = { [[<cmd>lua require("persistence").load()<cr>]], "Restore Session" },
    l = { [[<cmd>lua require("persistence").load({last=true})<cr>]], "Restore Last Session" },
    d = { [[<cmd>lua require("persistence").stop()<cr>]], "Stop Current Session" },
  },
  e = {
    name = "+errors",
    x = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble" },
    t = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
    tt = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", "Todo Trouble" },
    T = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
    l = { "<cmd>lopen<cr>", "Open Location List" },
    q = { "<cmd>copen<cr>", "Open Quickfix List" },
    n = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
    p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic" },
    N = { "<cmd>lua vim.diagnostic.goto_next({popup_opts = {border = O.lsp.popup_border}})<cr>", "Next Diagnostic" },
    k = {
      "<cmd>lua vim.diagnostic.set_loclist({open_loclist = false})<cr>",
      "Show Diagnostics popup",
    },
    P = {
      "<cmd>lua vim.diagnostic.goto_prev({popup_opts = {border = O.lsp.popup_border}})<cr>",
      "Previous Diagnostic",
    },
    d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics" },
    w = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
  },
  x = {
    name = "+text",
    a = {
      "<Plug>(EasyAlign)",
      "Easy Align",
      mode = { "n", "v" },
    },
    t = {
      ":Voggle<cr>",
      "+toggle",
    },
    c = {
      name = "+case",
    },
  },
  z = { [[<cmd>ZenMode<cr>]], "Zen Mode" },
}

local leader_visual = {
  ["/"] = {
    function()
      require("telescope.builtin").grep_string({
        search = vim.fn.expand("<cword>"),
      })
    end,
    "Search",
  },
}

for i = 0, 10 do
  leader[tostring(i)] = "which_key_ignore"
end

wk.register(leader, { prefix = "<leader>" })
wk.register(leader_visual, { prefix = "<leader>", mode = "v" })

wk.register({ g = { name = "+goto" } })
