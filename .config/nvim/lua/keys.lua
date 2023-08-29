--[[ keys.lua ]]

local wk = require("which-key")

wk.register({
    -- Buffers
    b = {
        name = "Buffers",
        c = { "<cmd>%bd|e#|bd#<cr>", "Delete All But Current Buffer" },
        d = { "<cmd>bdelete<cr>", "Delete Buffer" },
        n = { "<cmd>bnext<cr>", "Next Buffer" },
        p = { "<cmd>bprevious<cr>", "Previous Buffer" },
    },

    --Copy
    c = {
        name = "Copy",
        p = { ':let @+ = expand("%:p")<cr>', "Copy Current Buffer Path" },
    },

    -- Telescope / Find
    f = {
        name = "Telescope",
        b = { "<cmd>Telescope buffers<cr>", "Search Open Buffers" },
        f = { "<cmd>Telescope find_files<cr>", "Find Files" },
        g = { "<cmd>Telescope grep_string<cr>", "Grep String" },
        h = { "<cmd>Telescope help_tags<cr>", "Search Help Tags" },
        i = {
            function()
                require("telescope.builtin").live_grep({
                    prompt_title = "Python Env Library Grep",
                    path_display = { "smart" },
                    search_dirs = { "$VIRTUAL_ENV" },
                })
            end,
            "Search Python Env Library Files",
        },
        k = { "<cmd>Telescope keymaps<cr>", "Show Keymaps" },
        l = {
            function()
                require("telescope.builtin").find_files({
                    prompt_title = "Python Env Library Files",
                    path_display = { "smart" },
                    search_dirs = { "$VIRTUAL_ENV" },
                })
            end,
            "Find Python Env Library Files",
        },
        r = { "<cmd>Telescope resume<cr>", "Resume Previous Search" },
        s = { "<cmd>Telescope live_grep<cr>", "Search Files" },
        w = { "<cmd>Telescope spell_suggest<cr>", "Search Spell Suggestions" },
    },

    -- Git
    g = {
        name = "Git",
        b = {
            name = "Blame",
            l = { "<cmd>Gitsigns blame_line<cr>", "Blame current line" },
            t = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle Current Line Blame" },
        },
        d = { "<cmd>Gitsigns diffthis<cr>", "Diff this file" },
        f = {
            name = "Buffer",
            r = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
            s = { "<cmd>Gitsigns stage_buffer<cr>", "Stage Buffer" },
        },
        h = {
            name = "Hunk",
            p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
            q = { "<cmd>Gitsigns setqflist<cr>", "Something something gitsigns" },
            r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
            s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
            u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo Stage Hunk" },
        },
        o = {
            name = "Open",
            b = { "<Plug>(gh-line-blame)", "Open Web Repository Line Blame" },
            l = { "<Plug>(gh-line)", "Open Web Repository Line" },
            r = { "<Plug>(gh-repo)", "Open Web Repository" },
        },
        s = {
            name = "Status",
            b = { "<cmd>Telescope git_branches<cr>", "Show Branches" },
            t = { "<cmd>Telescope git_status<cr>", "Show Status" },
        },
    },
    -- Tab (Layers)
    l = {
        name = "Tabs",
        c = { "<cmd>tabclose<cr>", "Close Current Tab" },
        o = { "<cmd>$tabnew<cr>", "Create New Tab" },
    },

    -- Refactoring
    r = {
        name = "Refactoring",
        b = {
            "<Esc><cmd>lua require('refactoring').refactor('Extract Block')<cr>",
            "Extract Block",
        },
        e = {
            "<Esc><cmd>lua require('refactoring').refactor('Extract Function')<cr>",
            "Extract Function",
            mode = "v",
        },
        f = {
            "<Esc><cmd>lua require('refactoring').refactor('Extract Function To File')<cr>",
            "Extract Function To File",
            mode = "v",
        },
        i = {
            "<Esc><cmd>lua require('refactoring').refactor('Inline Variable')<cr>",
            "Inline Variable",
            mode = "v",
        },

        s = {
            "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<cr>",
            "Select Refactor",
            mode = "v",
        },
        v = {
            "<Esc><cmd>lua require('refactoring').refactor('Extract Variable')<cr>",
            "Extract Variable",
            mode = "v",
        },
    },

    -- Visual
    s = {
        name = "Show",
        a = {
            name = "Aerial",
            f = { "<cmd>AerialToggle float<cr>", "Show Aerial Float" },
            t = { "<cmd>AerialToggle<cr>", "Show Aerial Sidebar" },
        },
        c = {
            name = "Different Colorscheme",
            d = { "<cmd>set background=dark<cr>", "Dark Colorscheme" },
            l = { "<cmd>set background=light<cr>", "Light Colorscheme" },
        },
        e = {
            name = "Errors",
            s = { "<cmd>TroubleToggle<cr>", "Show Trouble for Workspace" },
            f = { "<cmd>TroubleToggle document_diagnostics<cr>", "Show Trouble for File" },
        },
        f = { "<cmd>NvimTreeFocus<cr>", "Focus on Tree Sidebar" },
        m = { "<cmd>Glow<cr>", "Show Markdown" },
        o = { "<cmd>Oil<cr>", "Show Oil" },
        s = { "<cmd>NvimTreeFindFile<cr>", "Find File in Tree" },
        t = { "<cmd>NvimTreeToggle<cr>", "Show Tree Sidebar" },
        u = { "<cmd>UndotreeToggle<cr>", "Show Undo Tree" },
        z = { "<cmd>ZenMode<cr>", "Toggle Zen Mode" },
    },

    -- Test
    t = {
        name = "Test",
        a = { "<cmd>call VimuxRunCommand('make test-fast')<cr>", "Run All Tests" },
        d = { '<cmd>lua require("neotest").run.run({strategey="dap"})<cr>', "Debug Test" },
        f = { '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', "Run Test File" },
        n = { '<cmd>lua require("neotest").run.run()<cr>', "Run Nearest Test" },
        o = { '<cmd>lua require("neotest").output.open()<cr>', "Float test panel" },
        p = { '<cmd>lua require("neotest").output_panel.toggle()<cr>', "Toggle Test Panel" },
        s = { '<cmd>lua require("neotest").summary.toggle()<cr>', "Toggle Test Summaries" },
    },
}, { prefix = "<leader>" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", ":Telescope lsp_definitions<cr>", opts) -- vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", ":Telescope lsp_implementations<cr>", opts) --vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gci", ":Telescope lsp_incoming_calls<cr>", opts)
        vim.keymap.set("n", "gco", ":Telescope lsp_outgoing_calls<cr>", opts)
        vim.keymap.set("n", "<leader>kk", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>D", ":Telescope lsp_type_definitions<cr>", opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", ":Telescope lsp_references<cr>", opts) --vim.lsp.buf.references, opts)
    end,
})
