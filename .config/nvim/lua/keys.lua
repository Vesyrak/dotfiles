-- Define Snacks global
_G.Snacks = require("snacks")

local wk = require("which-key")

-- Double-tap esc to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])

wk.add({
    { "<leader>a", group = "AI" },
    --{
    --    "<leader>aa",
    --    "<cmd>AvanteToggle<cr>",
    --    desc = "Toggle Avante",
    --},
    --{
    --    "<leader>ae",
    --    "<cmd>AvanteEdit<cr>",
    --    desc = "Edit block with Avante",
    --},
    --{
    --    "<leader>as",
    --    "<cmd>AvanteStop<cr>",
    --    desc = "Stop Avante",
    --},
    { "<leader>b", group = "Buffers" },
    { "<leader>bc", "<cmd>%bd|e#|bd#<cr>", desc = "Delete All But Current Buffer" },
    { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },
    { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
    { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
    { "<leader>c", group = "Copy" },
    { "<leader>cp", ':let @+ = expand("%:p")<cr>', desc = "Copy Current Buffer Path" },
    { "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Actions" },
    { "<leader>d", group = "Debug" },
    { "<leader>dB", "<cmd>lua require('dap').set_breakpoint()<cr>", desc = "Set Breakpoint" },
    { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
    { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
    {
        "<leader>dd",
        function()
            require("dap").repl.open()
        end,
        desc = "Open Debug Console",
    },
    { "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into" },
    {
        "<leader>dl",
        function()
            require("dap").run_last()
        end,
        desc = "Run Last DAP Config",
    },
    { "<leader>dn", "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over" },
    { "<leader>do", "<cmd>lua require('dapui').toggle()<cr>)", desc = "UI Toggle" },
    { "<leader>dv", group = "View" },
    {
        "<leader>dvP",
        function()
            require("dap.ui.widgets").preview()
        end,
        desc = "Preview",
    },
    {
        "<leader>dvf",
        function()
            local widgets = require("dap.ui.widgets")
            widgets.centered_float(widgets.frames)
        end,
        desc = "Frames",
    },
    {
        "<leader>dvh",
        function()
            require("dap.ui.widgets").hover()
        end,
        desc = "Hover",
    },
    {
        "<leader>dvs",
        function()
            local widgets = require("dap.ui.widgets")
            widgets.centered_float(widgets.scopes)
        end,
        desc = "Scopes",
    },
    { "<leader>f", group = "Picker" },
    {
        "<leader>fa",
        function()
            Snacks.picker.smart()
        end,
        desc = "Search Frecency",
    },
    {
        "<leader>fb",
        function()
            Snacks.picker.buffers()
        end,
        desc = "Search Open Buffers",
    },
    {
        "<leader>ff",
        function()
            Snacks.picker.grep()
        end,
        desc = "Search Files",
    },
    {
        "<leader>fh",
        function()
            Snacks.picker.help()
        end,
        desc = "Search Help Tags",
    },
    {
        "<leader>fi",
        function()
            Snacks.picker.grep({ dirs = { "$VIRTUAL_ENV" }, ignored = true })
        end,
        desc = "Search Python Env Library Files",
    },
    {
        "<leader>fk",
        function()
            Snacks.picker.keymaps()
        end,
        desc = "Show Keymaps",
    },
    {
        "<leader>fl",
        function()
            Snacks.picker.files({ cwd = "$VIRTUAL_ENV", ignored = true })
        end,
        desc = "Find Python Env Library Files",
    },
    {
        "<leader>fm",
        function()
            Snacks.picker.marks()
        end,
        desc = "Show Marks",
    },
    {
        "<leader>fn",
        function()
            Snacks.picker.notifications()
        end,
        desc = "Show notifications",
    },
    {
        "<leader>fr",
        function()
            Snacks.picker.resume()
        end,
        desc = "Resume Previous Search",
    },
    {
        "<leader>fs",
        function()
            Snacks.picker.files()
        end,
        desc = "Find Files",
    },
    {
        "<leader>fw",
        function()
            Snacks.picker.spelling()
        end,
        desc = "Search Spell Suggestions",
    },
    { "<leader>g", group = "Git" },
    { "<leader>gb", group = "Blame" },
    { "<leader>gbl", "<cmd>Gitsigns blame_line<cr>", desc = "Blame current line" },
    { "<leader>gbt", "<cmd>Git blame<cr>", desc = "Open Blame" },
    { "<leader>gc", group = "Change Base" },
    { "<leader>gcd", "<cmd>Gitsigns change_base origin/develop<cr>", desc = "Change base to origin/develop" },
    { "<leader>gcm", "<cmd>Gitsigns change_base origin/master<cr>", desc = "Change base to origin/master" },
    { "<leader>gcn", "<cmd>Gitsigns change_base origin/main<cr>", desc = "Change base to origin/main" },
    { "<leader>gcr", "<cmd>Gitsigns change_base<cr>", desc = "Reset base to head" },
    { "<leader>gd", group = "Diff" },
    { "<leader>gdb", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this file with source branch" },
    { "<leader>gdd", "<cmd>Gitsigns diffthis origin/develop<cr>", desc = "Diff this file with origin/develop" },
    { "<leader>gdm", "<cmd>Gitsigns diffthis origin/master<cr>", desc = "Diff this file with origin/master" },
    { "<leader>gdn", "<cmd>Gitsigns diffthis origin/main<cr>", desc = "Diff this file with origin/main" },
    { "<leader>gdv", "<cmd>DiffviewOpen<cr>", desc = "Open DiffView" },
    { "<leader>gf", group = "Buffer" },
    { "<leader>gfp", "<cmd>lua MiniDiff.toggle_overlay()<cr>", desc = "Reset Buffer" },
    { "<leader>gfr", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
    { "<leader>gfs", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
    { "<leader>gh", group = "Hunk" },
    { "<leader>ghp", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Preview Hunk" },
    { "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
    { "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
    { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },
    {
        "<leader>gn",
        function()
            require("gitsigns").nav_hunk("next")
        end,
    },
    { "<leader>go", group = "Open" },
    {
        "<leader>gol",
        function()
            Snacks.gitbrowse()
        end,
        desc = "Open Web Repository Line",
        mode = { "n", "v" },
    },
    {
        "<leader>gp",
        function()
            require("gitsigns").nav_hunk("prev")
        end,
    },
    { "<leader>gq", "<cmd>Gitsigns setqflist<cr>", desc = "Show buffer gitsigns" },
    { "<leader>gs", group = "Status" },
    {
        "<leader>gsb",
        function()
            Snacks.picker.git_branches()
        end,
        desc = "Show Branches",
    },
    {
        "<leader>gsd",
        function()
            Snacks.picker.git_diff()
        end,
        desc = "Show Diff picker",
    },
    {
        "<leader>gst",
        function()
            Snacks.picker.git_status()
        end,
        desc = "Show Status",
    },

    { "<leader>l", group = "Tabs" },
    { "<leader>lc", "<cmd>tabclose<cr>", desc = "Close Current Tab" },
    { "<leader>lo", "<cmd>$tabnew<cr>", desc = "Create New Tab" },
    { "<leader>m", group = "Markdown" },
    { "<leader>mt", '<cmd>lua require("util").toggle_checkbox()<cr>' },
    { "<leader>q", group = "Quickfix / Trouble" },
    { "<leader>qt", "<cmd>TodoTrouble<cr>", desc = "Show Todos" },
    { "<leader>r", group = "Refactoring" },
    { "<leader>rb", "<Esc><cmd>lua require('refactoring').refactor('Extract Block')<cr>", desc = "Extract Block" },
    { "<leader>s", group = "Show" },
    { "<leader>sa", group = "Aerial" },
    { "<leader>saf", "<cmd>AerialToggle float<cr>", desc = "Show Aerial Float" },
    {
        "<leader>sat",
        "<cmd>AerialToggle<cr>",
        desc = "Show Aerial Sidebar",
    },
    { "<leader>sc", group = "Different Colorscheme" },
    { "<leader>scd", "<cmd>set background=dark<cr>", desc = "Dark Colorscheme" },
    { "<leader>scl", "<cmd>set background=light<cr>", desc = "Light Colorscheme" },
    {
        "<leader>sef",
        "<cmd>Trouble document_diagnostics toggle<cr>",
        desc = "Show Trouble for File",
    },
    {
        "<leader>sen",
        ":Trouble diagnostics next focus=false jump=true open=false<cr>",
        desc = "Go to next entry",
    },
    {
        "<leader>sep",
        ":Trouble diagnostics prev focus=false jump=true open=false<cr>",
        desc = "Go to previous entry",
    },
    { "<leader>sf", "<cmd>NvimTreeFocus<cr>", desc = "Focus on Tree Sidebar" },
    { "<leader>ss", "<cmd>NvimTreeFindFile<cr>", desc = "Find File in Tree" },
    { "<leader>st", "<cmd>NvimTreeToggle<cr>", desc = "Show Tree Sidebar" },
    { "<leader>su", "<cmd>UndotreeToggle<cr>", desc = "Show Undo Tree" },
    {
        "<leader>sx",
        function()
            Snacks.picker.todo_comments()
        end,
        desc = "Show Todos",
    },
    { "<leader>sz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    { "<leader>t", group = "Test" },
    { "<leader>ta", "<cmd>call VimuxRunCommand('make test-fast')<cr>", desc = "Run All Tests" },
    { "<leader>td", '<cmd>lua require("neotest").run.run({strategey="dap"})<cr>', desc = "Debug Test" },
    { "<leader>tf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', desc = "Run Test File" },
    {
        "<leader>th",
        "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",
        desc = "Toggle inlay hints",
    },
    { "<leader>tn", '<cmd>lua require("neotest").run.run()<cr>', desc = "Run Nearest Test" },
    { "<leader>to", '<cmd>lua require("neotest").output.open()<cr>', desc = "Float test panel" },
    { "<leader>tp", '<cmd>lua require("neotest").output_panel.toggle()<cr>', desc = "Toggle Test Panel" },
    { "<leader>ts", '<cmd>lua require("neotest").summary.toggle()<cr>', desc = "Toggle Test Summaries" },
    {
        mode = { "v" },
        {
            "<leader>re",
            "<Esc><cmd>lua require('refactoring').refactor('Extract Function')<cr>",
            desc = "Extract Function",
        },
        {
            "<leader>rf",
            "<Esc><cmd>lua require('refactoring').refactor('Extract Function To File')<cr>",
            desc = "Extract Function To File",
        },
        {
            "<leader>ri",
            "<Esc><cmd>lua require('refactoring').refactor('Inline Variable')<cr>",
            desc = "Inline Variable",
        },
        {
            "<leader>rv",
            "<Esc><cmd>lua require('refactoring').refactor('Extract Variable')<cr>",
            desc = "Extract Variable",
        },
    },
    { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
})

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", function()
            Snacks.picker.lsp_definitions()
        end, opts) -- vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", function()
            Snacks.picker.lsp_implementations()
        end, opts) --vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>kk", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>D", function()
            Snacks.picker.lsp_type_definitions()
        end, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", function()
            Snacks.picker.lsp_references()
        end, opts) --vim.lsp.buf.references, opts)
    end,
})
