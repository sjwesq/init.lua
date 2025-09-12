-- vim: foldmethod=marker

-- The lazy.vim documentation recommended having a separate plugin folder,
-- but... A single file just loads a bit faster (:

local plugins_dap = {} -- for lazy-loading purposes

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
      keymap = {
        preset = "default",
        ["<C-space"] = false,
        ["<C-j>"] = { "show", "show_documentation", "hide_documentation" },
      },
      fuzzy = { implementation = "prefer_rust" },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },
        menu = { auto_show = false },
      },
    },
  },
  -- }}}
  -- LSP/Linter Configuration {{{----------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
  },
  {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    config = function()
      require("mason").setup()
    end,
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
    config = function()
      require("mason-nvim-lint").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
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
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- }}}
  -- Debugging {{{-------------------------------------------------------------
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      require("lazy").load({ plugins = plugins_dap })
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    dependencies = {
      { "mfussenegger/nvim-dap" },
    },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
    init = table.insert(plugins_dap, "nvim-dap-virtual-text"),
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    lazy = true,
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup({
        automatic_installation = true,
        ensure_installed = {},
        handlers = {},
      })
    end,
    init = table.insert(plugins_dap, "mason-nvim-dap.nvim"),
  },

  -- }}}
  -- Text Editing {{{----------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      local fmt = {}
      local fmt_multiassign = function(table_input, formatter)
        for _, ft in ipairs(table_input) do
          fmt[ft] = { formatter }
        end
      end

      local ft_clang = { "c", "cpp", "cs", "java" }
      fmt_multiassign(ft_clang, "clang_format")
      local ft_prettier = { "html", "css", "javascript", "typescript", "json" }
      fmt_multiassign(ft_prettier, "prettier")
      fmt["lua"] = { "stylua" }
      fmt["sh"] = { "shfmt" }
      fmt["python"] = { "black" }
      fmt["go"] = { "gofumpt" }
      fmt["tex"] = { "latexindent" }

      require("conform").setup({ formatters_by_ft = fmt })
      require("conform").formatters.stylua = {
        append_args = {
          "--indent-type",
          "Spaces",
          "--indent-width",
          "2",
          "--column-width",
          "80",
        },
      }
      require("conform").formatters.shfmt = {
        append_args = { "-i", "2", "-ci", "-s" },
      }
      require("conform").formatters.clang_format = {
        command = "clang-format",
        append_args = { "--style=Google" },
      }
      require("conform").formatters.latexindent = {
        append_args = { "-g", "/dev/null" },
      }
    end,
  },
  {
    "nvim-mini/mini.align",
    event = "VeryLazy",
    config = function()
      require("mini.align").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup({ respect_selection_type = true })
    end,
  },
  {
    "nvim-mini/mini.splitjoin",
    event = "VeryLazy",
    config = function()
      require("mini.splitjoin").setup()
    end,
  },
  --
  -- }}}
  -- UI Behavior {{{-----------------------------------------------------------
  {
    "nvim-mini/mini.files",
    event = "VeryLazy",
    config = function()
      require("mini.files").setup({
        windows = { preview = true, width_preview = 60 },
      })
    end,
  },
  {
    "nvim-mini/mini.pick",
    event = "VeryLazy",
    config = function()
      require("mini.pick").setup({})
    end,
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({})
    end,
  },
  {
    "psliwka/vim-dirtytalk",
    build = ":DirtytalkUpdate",
    config = function()
      vim.opt.spelllang = { "en", "programming" }
    end,
  },
  -- }}}
  -- UI Appearance {{{---------------------------------------------------------
  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_diagnostic_virtual_text = "highlighted"
      vim.g.everforest_disable_terminal_colors = 1
      vim.g.everforest_better_performance = 1
      vim.cmd.colorscheme("everforest")
    end,
    priority = 1000, -- ensure this loads first
  },
  {
    "nvim-mini/mini.icons",
    event = "VeryLazy",
    config = { style = vim.g.enable_nerd_fonts and "default" or "ascii" },
  },
  {
    "nvim-mini/mini.statusline",
    dependencies = {
      {
        "nvim-mini/mini-git",
        config = function()
          require("mini.git").setup({})
        end,
      },
      {
        "nvim-mini/mini.diff",
        config = function()
          require("mini.diff").setup({})
        end,
      },
    },
    config = function()
      require("mini.statusline").setup({ use_icons = vim.g.enable_nerd_fonts })
    end,
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "VeryLazy",
  },
  {
    "brenoprata10/nvim-highlight-colors",
    ft = { "html", "xml", "conf" },
    config = function()
      require("nvim-highlight-colors").setup({})
    end,
  },

  -- }}}
  -- Only for recordings {{{---------------------------------------------------
  {
    "NStefan002/screenkey.nvim",
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

-- lazy.nvim Boostrap {{{------------------------------------------------------
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
