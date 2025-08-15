local enable_nerd_fonts = true

return {
  {
    "neanias/everforest-nvim",
    init = function() vim.cmd.colorscheme("everforest") end,
    priority = 1000, -- ensure this loads first
  },
  {
    "echasnovski/mini.icons",
    config = { style = enable_nerd_fonts and "default" or "ascii" },
  },
  {
    "echasnovski/mini.statusline",
    dependencies = {
      {
        "echasnovski/mini-git",
        config = function() require("mini.git").setup({}) end,
      },
      {
        "echasnovski/mini.diff",
        config = function() require("mini.diff").setup({}) end,
      },
    },
    config = function()
      require("mini.statusline").setup({ use_icons = enable_nerd_fonts })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    cond = enable_nerd_fonts,
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          max_height = 4,
          max_width = 66,
          render = "wrapped-compact",
          stages = "slide",
          top_down = false,
        },
      },
    },
    config = function()
      require("noice").setup({
        routes = {
          {
            -- Closer to vanilla behavior
            view = "messages",
            filter = {
              event = "msg_show",
              min_height = 2,
              ["not"] = { kind = "confirm" },
            },
          },
        },
        presets = {
          bottom_search = true,
        },
      })
    end,
  },
  { "hiphish/rainbow-delimiters.nvim" },
  -- Only for recordings:
  {
    "NStefan002/screenkey.nvim",
    enabled = false,
    dependencies = {
      "rcarriga/nvim-notify",
      opts = {
        top_down = true
      }
    },
    config = function()
      require("screenkey").setup({
        disable = {
          buftypes = { "terminal" },
        }
      })
      vim.cmd("Screenkey")
    end
  },
}
