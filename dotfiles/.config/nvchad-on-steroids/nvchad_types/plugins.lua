---@meta

---@alias PluginName string

---@class LazyPluginSpecExtra: LazyPluginSpec
--- Specify the plugin to load when opening a file with one of the specified filetypes
---@field ft? string|string[]|fun(_: LazyPlugin, ft: string[]):string[] 
--- Specify the plugin to load when one of the specified commands are called
---@field cmd? string|string[]|fun(_: LazyPlugin, ft: string[]): string[]
--- Specify some sequence of keybinds that will load this plugin
---     - If a function, then the second argument of the function are the list of key sequences that defined the loading of this plugin by NvChad
---         - The first argument is reserved for internal use, it should not be used under normal circumstances
--- ## Examples
--- ```lua
---     keys = "foo"
---     keys = {"b", "a", "r"}
---     keys = {
---       {"foo", "bar", desc = "Some keymaps", mode = {"n", "i"}}
---     }
---     keys = function (_, keys)
---       ---@type (string|LazyKeymaps)[]
---       return {
---         { "foo", mode = { "n", "i" } },
---         "bar"
---       }
---     end
--- ```
---@field keys? string|string[]|LazyKeymaps[]|fun(_:LazyPlugin, keys:string[]):((string|LazyKeymaps)[])
--- Will be executed when this plugin is loaded. 
--- - If `config` is `true`, then `require("plugin").setup(opts)` will be run.  
--- - If a function, then `opts` argument will be the table from `opts` field
---@field config? fun(_:LazyPlugin, opts:table)|true  
--- Config for a plugin
--- Read the docs of that plugin for more info. 
--- If `opts` is a function, then the second argument `opts` is the default config defined by NvChad
--- If `opts` is defined, then `config` will be true unless defined by user
---@field opts? table|fun(_:LazyPlugin, opts:table):table?
--- List of plugin names or plugin specs that should be loaded when the plugin loads. 
--- If you only specify the name, it will be installed and loaded with other(s) dependent plugins
--- Example of how the dependencies table could be
---
--- 1. It can be a list of strings
--- ```lua
---     dependencies = {
---       "plugin foo",
---       "plugin bar"
---     }
--- ```
--- 2. It can be a table to define another plugin (cannot co-exist with 1.)
--- ```lua
---     dependencies = {
---       "plugin foo",
---       config = function(_, opts)
---         require("plugin").setup(opts)
---       end
---     }
--- ```
--- 3. It can be a table with a table of strings, or a list of tables defining plugin configurations
--- ```lua
---     dependencies = {
---       -- List of strings defining list of plugins that is dependencies of parent
---       {
---         "plugin/foo",
---         "plugin/bar"
---       },
---       -- Or a table defining a dependent plugin
---       {
---         "plugin/baz",
---         opts = {...},
---         config = ...
---       }
---     }
--- ```
--- It is best to not have nested dependencies (or deeply nested ones), i.e.
--- ```lua
---     dependencies = {
---       -- Some config
---       dependencies = {
---         depedencies = {...}, -- You can do this but it isn't nice, is it?
---       },
---     }
--- ```
---@field dependencies? (string[]|NvPluginSpec) 
---@field init? fun(_: LazyPlugin) Will always be run on opening neovim
--- Condition that this plugin will be loaded
--- Useful for defining loading conditions for plugins only used inside Neovim TUI and not FireNvim and VsCode, for example
---@field cond? boolean|fun():boolean 
--- Events that will trigger the loading of this plugin   
--- - If it's a string/list of strings, the strings can be a simple VimEvent like `BufEnter`, or with patterns like `BufEnter *.vim`
--- - If a function, then the second argument of the function are the list of event(s) that defined the loading of this plugin by NvChad (if any)
---     - The first argument is reserved for internal use, it should not be used under normal circumstances
---
--- The list of available events are:
---     - `VeryLazy`: Special event. Will be loaded after initial UI rendering
---     - `:h events`: Vim Events 
---     - `:h lsp-events`
---     - `:h diagnostics-events`
---@field event? '"VeryLazy"'|string|string[]|fun(_: LazyPlugin, event: string[]): string[]
--- Whether to load a plugin by default on opening Neovim or not
--- By default, all NvChad plugins have `lazy = true`, meaning it will not be loaded unless
---   - the module related to a plugin is called
---   - Have either `dependencies`, `keys`, `ft`, `event` set
---   - Have `lazy` to be `false` instead of `true`
---@field lazy? boolean

--- Docs adopted from Lazy.nvim
--- Check `:h lazy.nvim` for more information
--- Check lua/plugins directory for the default config of plugins
--- By default, all NvChad plugins has `lazy = true`, which means it will not be loaded automatically 
--- unless you specify an event for it to load, or to set `lazy = false` for it to load on startup
---@alias NvPluginSpec string|LazyPluginSpecExtra|NvImportSpec|NvPluginSpec[]

---Check `:h vim.keymap.set()` for more information
---@class LazyKeymaps: LazyKeysBase
---@field [1] string lhs of the mapping. Must always exist
---@field [2]? string|fun()|false rhs. Can be a vimscript string or a Lua function
---@field mode? VimKeymapMode|VimKeymapMode[]
---@field id? string