-- vim: foldmethod=marker

-- The lazy.vim documentation recommended having a separate plugin folder,
-- but... A single file just loads a bit faster (:

local plugin_list = {
  -- Completion {{{------------------------------------------------------------
  {
    "saghen/blink.cmp",
    event = "VeryLazy",
    version = "1.*",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        run = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
      },
      {
        "neovim/nvim-lspconfig",
        config = function()
          local capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          }
          capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
        end,
      },
    },
    opts = {
      snippets = { preset = "luasnip" },
      keymap = { preset = "default" },
      fuzzy = { implementation = "prefer_rust" },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },
      },
    },
  },
  -- }}}
  -- LSP/Linter Configuration {{{----------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    config = function() require("mason").setup() end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        automatic_enable = true,
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "flake8" },
      }
    end,
  },
  {
    "rshkarin/mason-nvim-lint",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-lint" },
    config = function() require("mason-nvim-lint").setup() end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter.install").prefer_git = false
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
        },

        auto_install = true,
      })
    end,
  },
  -- }}}
  -- Text Editing {{{----------------------------------------------------------
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    config = {
      function() require("mini.comment").setup() end,
    },
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function() require("mini.pairs").setup({}) end,
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup({ respect_selection_type = true })
    end,
  },
  --}}}
  -- UI Behavior {{{-----------------------------------------------------------
  {
    "folke/noice.nvim",
    event = "VeryLazy",
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
  -- }}}
  -- UI Appearance {{{---------------------------------------------------------
  {
    "sainnhe/everforest",
    init = function() vim.cmd.colorscheme("everforest") end,
    priority = 1000, -- ensure this loads first
  },
  {
    "echasnovski/mini.icons",
    event = "VeryLazy",
    config = { style = ENABLE_NERD_FONTS and "default" or "ascii" },
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
      require("mini.statusline").setup({ use_icons = ENABLE_NERD_FONTS })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    cond = ENABLE_NERD_FONTS,
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "VeryLazy",
  },
  -- }}}
  -- Only for recordings {{{---------------------------------------------------
  {
    "NStefan002/screenkey.nvim",
    event = "VeryLazy",
    enabled = false,
    dependencies = {
      "rcarriga/nvim-notify",
      opts = {
        top_down = true,
      },
    },
    config = function()
      require("screenkey").setup({
        disable = {
          buftypes = { "terminal" },
        },
      })
      vim.cmd("Screenkey")
    end,
  },
  -- }}}
}

--- lazy.nvim Boostrap {{{-----------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
-- }}}

-- lazy.nvim Setup {{{---------------------------------------------------------
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { plugin_list },
  checker = {
    enabled = false,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
-- }}}
