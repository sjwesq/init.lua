-- lua/user/plugins.lua

-- Plugin settings
local enable_nerd_fonts = true

-- Bootstrap Lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Plugin list starts here ----------------------------------------------------
require("lazy").setup({
  -- Navigation/Misc ----------------------------------------------------------
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup()
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  },
  -- mini.nvim ----------------------------------------------------------------
  {
    "echasnovski/mini.nvim",
    config = function()
      if enable_nerd_fonts then
        require("mini.icons").setup()
      else
        require("mini.icons").setup({
          style = "ascii",
        })
      end
      require("mini.comment").setup()
      require("mini.files").setup({
        windows = {
          preview = true,
          width_preview = 60,
        },
      })
      require("mini.surround").setup({
        respect_selection_type = true,
      })
      if not vim.g.neovide then
        require("mini.animate").setup()
      end
      require("mini.pick").setup()
      require("mini.pairs").setup()
    end,
  },
  --- LSP/Linter Setup -------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
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
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
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
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "flake8" },
      }
    end,
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-lint" },
    config = function()
      require("mason-nvim-lint").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
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
  {
    "bakpakin/janet.vim",
  },
  -- Auto-Completion/Snippets -------------------------------------------------
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        run = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
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
  -- Visual changes -----------------------------------------------------------
  {
    "neanias/everforest-nvim",
    init = function()
      vim.cmd.colorscheme("everforest")
    end,
    priority = 1000, -- ensure this loads first
  },
  {
    "nvim-tree/nvim-web-devicons",
    cond = enable_nerd_fonts,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local config_component_separators
      local config_section_separators
      if enable_nerd_fonts then
        -- Use defaults
        config_component_separators = component_separators
        config_section_separators = section_separators
      else
        -- Ascii-friendly alternatives
        config_component_separators = { left = "|", right = "|" }
        config_section_separators = { left = "", right = "" }
      end
      require("lualine").setup({
        options = {
          icons_enabled = enable_nerd_fonts,
          component_separators = config_component_separators,
          section_separators = config_section_separators,
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      -- Use defaults
      local config_buffer_close_icon = buffer_close_icon
      local config_modified_icon = modified_icon
      local config_close_icon = close_icon
      local config_indicator = indicator
      local config_separator_style = "slant"
      if not enable_nerd_fonts then
        -- Ascii-friendly alternatives
        config_buffer_close_icon = "x"
        config_modified_icon = "o"
        config_close_icon = "X"
        config_indicator = { style = "underline" }
        config_separator_style = separator_style
      end
      require("bufferline").setup({
        options = {
          buffer_close_icon = config_buffer_close_icon,
          modified_icon = config_modified_icon,
          close_icon = config_close_icon,
          indicator = config_indicator,
          separator_style = config_separator_style,
        },
      })
    end,
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
            filter = { event = "msg_show", min_height = 2 },
          },
        },
        presets = {
          bottom_search = true,
        },
      })
    end,
  },
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10,
    opts = {
      overwrite = {
        undo = {
          enabled = true,
        },
        redo = {
          enabled = true,
        },
      },
    },
  },
  {
    "xiyaowong/virtcolumn.nvim",
    init = function()
      vim.opt.cc = "80"
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    "hiphish/rainbow-delimiters.nvim",
  },
  -- Only for recordings:
  -- {
  --   "NStefan002/screenkey.nvim",
  --   dependencies = {
  --     "rcarriga/nvim-notify",
  --     opts = {
  --       top_down = true
  --     }
  --   },
  --   config = function()
  --     require("screenkey").setup({
  --       disable = {
  --         buftypes = { "terminal" },
  --       }
  --     })
  --     vim.cmd("Screenkey")
  --   end
  -- },
})
