---@type ChadrcConfig
local M = {}

-- UI Configuration
M.ui = {
    theme = "rxyhn", -- default theme
    theme_toggle = { "onedark", "one_light" },
    transparency = true,

    -- Custom highlight overrides
    hl_override = {
        Normal = {
            -- bg = "#00070B",
            fg = "#A9A9A9",
        },
    },

    -- Statusline configuration
    statusline = {
        theme = "minimal",
        separator_style = "block",
        order = nil,
        modules = nil,
    },

    -- Tabufline configuration
    tabufline = {
        enabled = true,
        lazyload = true,
        order = { "treeOffset", "buffers", "tabs", "btns" },
        modules = nil,
    },

    -- Telescope configuration
    telescope = { style = "bordered" },

    -- Completion configuration
    cmp = {
        sources = {
            -- { name = "codeium" }
        },
        icons_left = false,
        lspkind_text = true,
        style = "flat_dark",
        format_colors = {
            tailwind = true,
            icon = "󱓻",
        },
    },
}

-- NvDash (Dashboard) Configuration
M.nvdash = {
    load_on_startup = true,
    header = {
        "▄███████▄▄ █▄ █",
        "██████████▄ ▀██",
        "████▄██████████",
        "▄▄▄██████████▄▄",
        "█  ▀██ █  ██  █",
        "█   ▀█ █  █  ██",
        "█  █   █    ███",
        "████████████▄██",
        "               ",
        "eovim dont ask",
        "what the second",
        "    tail is.   ",
    },
    buttons = {
        { txt = " Find File", keys = "ff", cmd = "Telescope find_files" },
        { txt = " Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
        { txt = "󰈭 Find Word", keys = "fw", cmd = "Telescope live_grep" },
        { txt = "󱥚 Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
        { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
        { txt = "📁 File Manager", keys = "C-Up", cmd = "Yazi" },
        { txt = " LazyGit", keys = "lg", cmd = "LazyGit" },
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
}

-- Terminal Configuration
M.term = {
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
}

-- LSP Configuration
M.lsp = {
    signature = true
}

-- Cheatsheet Configuration
M.cheatsheet = {
    theme = "grid",                                                     -- simple/grid
    excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
}

-- Mason Configuration
M.mason = {
    pkgs = {}
}

-- Colorify Configuration (if using nvchad colorify plugin)
M.colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
}

-- Base46 specific configurations (if needed)
M.base46 = {
    integrations = {},
    changed_themes = {},
}

return M
