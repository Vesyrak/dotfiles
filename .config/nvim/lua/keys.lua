--[[ keys.lua ]]

local wk = require("which-key")

local harpoon = require("harpoon")
local conf = require("telescope.config").values
local function harpoon_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        })
        :find()
end

wk.register({
    -- Buffers
    a = {
        name = "AI",
        c = { "<cmd>Model code<cr>", "Suggest code" },
        g = { "<cmd>Model gitcommit<cr>", "Write a git commit" },
        s = { "<cmd>Mcancel<cr>", "Stop generation" },
        w = { "<cmd>Model write<cr>", "Write for me" },
    },

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

    -- Debugging
    d = {
        name = "Debug",
        b = { "<cmd>lua require('dap').toggle_breakpoint()<cr>)", "Toggle Breakpoint" },
        B = { "<cmd>lua require('dap').set_breakpoint()<cr>)", "Set Breakpoint" },
        c = { "<cmd>lua require('dap').continue()<cr>)", "Continue" },
        d = {
            function()
                require("dap").repl.open()
            end,
            "Open Debug Console",
        },
        i = { "<cmd>lua require('dap').step_into()<cr>)", "Step Into" },
        l = {
            function()
                require("dap").run_last()
            end,
            "Run Last DAP Config",
        },
        n = { "<cmd>lua require('dap').step_over()<cr>)", "Step Over" },
        o = { "<cmd>lua require('dap').step_out()<cr>)", "Step Out" },
        o = { "<cmd>lua require('dapui').toggle()<cr>)", "UI Toggle" },
        v = {
            name = "View",
            f = {
                function()
                    local widgets = require("dap.ui.widgets")
                    widgets.centered_float(widgets.frames)
                end,
                "Frames",
            },
            h = {
                function()
                    require("dap.ui.widgets").hover()
                end,
                "Hover",
            },
            P = {
                function()
                    require("dap.ui.widgets").preview()
                end,
                "Preview",
            },
            s = {
                function()
                    local widgets = require("dap.ui.widgets")
                    widgets.centered_float(widgets.scopes)
                end,
                "Scopes",
            },
        },
    },

    -- Telescope / Find
    f = {
        name = "Telescope",
        a = { "<cmd>Telescope frecency workspace=CWD<cr>", "Search Frecency" },
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
                    additional_args = { "--no-ignore-vcs" },
                    no_ignore = true,
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
                    no_ignore = true,
                })
            end,
            "Find Python Env Library Files",
        },
        n = { "<cmd>Telescope notifications<cr>", "Show notifications" },
        r = { "<cmd>Telescope resume<cr>", "Resume Previous Search" },
        s = { "<cmd>Telescope live_grep_args<cr>", "Search Files" },
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
        d = {
            name = "Diff",
            b = { "<cmd>Gitsigns diffthis<cr>", "Diff this file with source branch" },
            d = { "<cmd>Gitsigns diffthis origin/develop<cr>", "Diff this file with origin/develop" },
            m = { "<cmd>Gitsigns diffthis origin/master<cr>", "Diff this file with origin/master" },
            n = { "<cmd>Gitsigns diffthis origin/main<cr>", "Diff this file with origin/main" },
            v = { "<cmd>DiffviewOpen<cr>", "Open DiffView" },
        },
        f = {
            name = "Buffer",
            r = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
            s = { "<cmd>Gitsigns stage_buffer<cr>", "Stage Buffer" },
        },
        h = {
            name = "Hunk",
            p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
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
        q = { "<cmd>Gitsigns setqflist<cr>", "Show buffer gitsigns" },
        s = {
            name = "Status",
            b = { "<cmd>Telescope git_branches<cr>", "Show Branches" },
            t = { "<cmd>Telescope git_status<cr>", "Show Status" },
        },
    },
    h = {
        name = "Harpoon",
        a = {
            function()
                harpoon:list():add()
            end,
            "Add",
        },
        p = {
            function()
                harpoon_telescope(harpoon:list())
            end,
            "View files",
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
            e = { "<cmd>Telescope aerial<cr>", "Show Aerial in Telescope" },
        },
        c = {
            name = "Different Colorscheme",
            d = { "<cmd>set background=dark<cr>", "Dark Colorscheme" },
            l = { "<cmd>set background=light<cr>", "Light Colorscheme" },
        },
        e = {
            f = { "<cmd>TroubleToggle document_diagnostics<cr>", "Show Trouble for File" },
            n = { '<cmd>lua require("trouble").next({skip_groups = true, jump = true})<cr>', "Go to next entry" },
            p = {
                '<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<cr>',
                "Go to previous entry",
            },
        },
        f = { "<cmd>NvimTreeFocus<cr>", "Focus on Tree Sidebar" },
        m = { "<cmd>Glow<cr>", "Show Markdown" },
        s = { "<cmd>NvimTreeFindFile<cr>", "Find File in Tree" },
        t = { "<cmd>NvimTreeToggle<cr>", "Show Tree Sidebar" },
        u = { "<cmd>UndotreeToggle<cr>", "Show Undo Tree" },
        x = { "<cmd>TodoTelescope<cr>", "Show Todos" },
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
    desc = "LSP actions",
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
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
