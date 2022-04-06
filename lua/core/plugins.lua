---@diagnostic disable: undefined-global
-- https://github.com/wbthomason/packer.nvim

local packer = require("packer")
packer.startup(
{
  function()
    use "wbthomason/packer.nvim"

    use {
      "rmehri01/onenord.nvim",
      config = function()
        require("onenord").setup({
          borders = true,
          styles = {
            comments = "italic",
            strings = "NONE",
            keywords = "NONE",
            functions = "NONE",
            variables = "NONE",
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
        require("lualine").setup()
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
