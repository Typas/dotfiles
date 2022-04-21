---@diagnostic disable: undefined-global
-- https://github.com/wbthomason/packer.nvim

local packer = require("packer")
packer.startup(
{
  function()
    use "wbthomason/packer.nvim"

    use {
      "NTBBloodbath/doom-one.nvim",
      config = function()
        require("doom-one").setup({
            terminal_colors = false,
            italic_comments = false,
            enable_treesitter = true,
            transparent_background = false,
            plugins_integrations = {
              gitsigns = true,
              telescope = true,
              whichkey = true,
            },
        })
      end
    }

    use {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end
    }

    use {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup({
          mappings = {
            extra = false,
          }
        })
      end
    }

    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
    }

    use "gpanders/editorconfig.nvim"

    use {
      "folke/which-key.nvim",
    }
    

    use {
      "nvim-telescope/telescope.nvim",
    }

    use "nvim-lua/plenary.nvim"

    use {
      "nvim-lualine/lualine.nvim",
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
      config = function()
        require("lualine").setup({
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
        })
      end
    }

    use {
      "ms-jpq/coq_nvim",
    }

    use {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({
          check_ts = true,
        })
      end
    }

  end
}
)

return packer
