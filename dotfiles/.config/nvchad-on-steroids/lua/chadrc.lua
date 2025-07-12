local options = {

    base46 = {
        theme = "rxyhn", -- default theme
        hl_add = {},
        hl_override = {
            Normal = {
                bg = "#00070B",
                fg = "#A9A9A9",
            },
        },

        integrations = {},
        changed_themes = {},
        transparency = true,
        theme_toggle = { "onedark", "one_light" },
    },

    ui = {
        cmp = {
            sources = {
                { name = "codeium" }
            },
            icons_left = false,
            lspkind_text = true,
            style = "flat_dark",
            format_colors = {
                tailwind = true,
                icon = "󱓻",
            },
        },

        telescope = { style = "bordered" },

        statusline = {
            enabled = true,
            theme = "minimal",
            separator_style = "block",
            order = nil,
            modules = nil,
        },

        tabufline = {
            enabled = true,
            lazyload = true,
            order = { "treeOffset", "buffers", "tabs", "btns" },
            modules = nil,
        },

        nvdash = {
            load_on_startup = true,
            header = {
                "▄███████████▄ █▄ ▄█",
                "█████████████▄ ▀██ ",
                "████▄█████████████ ",
                " ▄ ▄▄▄▄██████████▀ ",
                " █ █  ▀██ █  ██  ██",
                " █ █   ▀█ █  █  ███",
                " █ █  █   █    ████",
                " █ ████████████▄███",
                "                   ",
                "      eovim       ",
                "   Don't ask what  ",
                " the second tail is",
            },
            buttons = {
                { txt = " Find File", keys = "ff", cmd = "Telescope find_files" },
                { txt = " Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
                { txt = "󰈭 Find Word", keys = "fw", cmd = "Telescope live_grep" },
                { txt = "󱥚 Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
                { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
                { txt = "📁 File Manager", keys = "C-Up", cmd = "Yazi" },
                { txt = " LazyGit", keys = "lg", cmd = "LazyGit" },

                { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

                {
                    txt = function()
                        local stats = require("lazy").stats()
                        local ms = math.floor(stats.startuptime) .. " ms"
                        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
                    end,
                    hl = "NvDashFooter",
                    no_gap = true,
                },

                { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
            },
        },
    },
    term = {
        winopts = { number = false, relativenumber = false },
        sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
        float = {
            relative = "editor",
            row = 0.3,
            col = 0.25,
            width = 0.5,
            height = 0.4,
            border = "single",
        },
    },

    lsp = { signature = true },

    cheatsheet = {
        theme = "grid",                                                     -- simple/grid
        excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
    },

    mason = { pkgs = {} },

    colorify = {
        enabled = true,
        mode = "virtual", -- fg, bg, virtual
        virt_text = "󱓻 ",
        highlight = { hex = true, lspvars = true },
    },
}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
