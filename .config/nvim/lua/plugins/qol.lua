return {
  { -- the beginners' must have
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
  },

  -- C-w hjkl or this
  "christoomey/vim-tmux-navigator",

  -- fix error
  "nvim-lua/plenary.nvim",

  -- comments
  "preservim/nerdcommenter",

  -- netrw replacer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        view = { adaptive_size = true }
      }
    end,
  },

  -- nvim tree dependecies
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "MunifTanjim/nui.nvim",

  { -- theme
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },

  { -- must have esp for web development
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "┊" },
    },
  },

  { -- something about closing brackets, check its docs
    "kylechui/nvim-surround",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    config = true,
  },
}
