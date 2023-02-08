---@diagnostic disable: undefined-global
-- https://github.com/folke/lazy.nvim

return {
  {
    "navarasu/onedark.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      style = "light",
      term_colors = false,
    },
    config = function()
      vim.cmd([[colorscheme onedark]])
    end
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
    lazy = true,
  },

  {
    "folke/which-key.nvim",
    lazy = true,
  },

  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    config = true,
  },

  {
    "numToStr/Comment.nvim",
    lazy = true,
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
    lazy = true,
  },

  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      {
        "kyazdani42/nvim-web-devicons",
        lazy = true,
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

  {
    "ms-jpq/coq_nvim",
    lazy = true,
  },

  {
    "windwp/nvim-autopairs",
    lazy = true,
    opts = {
      check_ts = true,
    },
  },
}
