return {
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    cond = not vim.g.neovide,
    config = {
      function() require("mini.animate").setup() end,
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  {
    "echasnovski/mini.files",
    event = "VeryLazy",
    config = function()
      require("mini.files").setup({
        windows = {
          preview = true,
          width_preview = 60,
        },
      })
    end,
  },
  {
    "echasnovski/mini.pick",
    event = "VeryLazy",
    config = function() require("mini.pick").setup({}) end,
  },
}
