---@diagnostic disable: undefined-global
-- https://github.com/folke/lazy.nvim

return {
  {
    "deparr/tairiki.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tairiki").setup({
        palette = "light",
        default_dark = "dimmed",
        default_light = "light",
      })
      vim.cmd([[colorscheme tairiki]])
    end,
  },

  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = {
      style = "light",
      term_colors = false,
    },
  },

  {
    "NTBBloodbath/doom-one.nvim",
    lazy = true,
    init = function()
      vim.g.doom_one_cursor_coloring = false
      vim.g.doom_one_terminal_colors = false
      vim.g.doom_one_italic_comments = true
      vim.g.doom_one_enable_treesitter = true
      vim.g.doom_one_diagnostics_text_color = false
      vim.g.doom_one_transparent_background = false
      vim.g.doom_one_plugin_gitsigns = true
      vim.g.doom_one_plugin_telescope = true
      vim.g.doom_one_plugin_whichkey = true
    end,
  },

  {
    "gpanders/editorconfig.nvim",
    lazy = false,
  },

  {
    "folke/which-key.nvim",
    lazy = false,
  },

  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = true,
  },

  {
    "numToStr/Comment.nvim",
    lazy = false,
    opts = {
      mappings = {
        extra = false,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
  },

  {
    "nvim-lua/plenary.nvim",
    lazy = false,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      {
        "kyazdani42/nvim-web-devicons",
        lazy = false,
      },
    },
    opts = {
      options = {
        theme = "onelight",
        icons_enabled = false,
        component_separators = {left = "|", right = "|"},
        section_separators = {left = "", right = ""},
      },
      sections = {
        lualine_a = {{
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end
        }},
      },
    },
  },

  --[[
      Auto Completion
      Using saghen/blink.cmp instead of built-in LSP completion

      References:
      https://gpanders.com/blog/whats-new-in-neovim-0-11/#lspa
      https://vi.stackexchange.com/questions/46749
  --]]
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*",
    opts = {
      keymap = { preset = "enter" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = false },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      fuzzy = { implementation = "rust" },
    },
  },

  {
    "windwp/nvim-autopairs",
    lazy = false,
    opts = {
      check_ts = true,
    },
  },
}
