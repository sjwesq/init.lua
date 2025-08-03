-- plugins.lua

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

-- plugin list
require("lazy").setup({
  ------------------------------------------------------------------------------
  --- Navigation/Misc
  ------------------------------------------------------------------------------
  "jghauser/mkdir.nvim",
  "jlanzarotta/bufexplorer",
  "NStefan002/screenkey.nvim",
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup()
    end,
  },
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
      require("mini.files").setup()
    end,
  },
  ------------------------------------------------------------------------------
  --- LSP Setup
  ------------------------------------------------------------------------------
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
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
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
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI
        -- installed locally
        auto_install = true,
      })
    end,
  },
  ------------------------------------------------------------------------------
  --- Delimiter Plugins
  ------------------------------------------------------------------------------
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
      -- spaces in autopairs
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules({
        -- Rule for a pair with left-side ' ' and right side ' '
        Rule(" ", " ")
          -- Pair will only occur if the conditional function returns true
          :with_pair(function(opts)
            -- We are checking if we are inserting a space in (), [], or {}
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          -- We only delete the pair of spaces when the cursor is as such: ( | )
          :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
              brackets[1][1] .. "  " .. brackets[1][2],
              brackets[2][1] .. "  " .. brackets[2][2],
              brackets[3][1] .. "  " .. brackets[3][2],
            }, context)
          end),
      })
      -- For each pair of brackets we will add another rule
      for _, bracket in pairs(brackets) do
        npairs.add_rules({
          -- Each of these rules is for a pair with left-side '( ' and
          -- right-side ' )' for each bracket type
          Rule(bracket[1] .. " ", " " .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts)
              return opts.char == bracket[2]
            end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(function(_)
              return "<C-c>2xi<CR><C-c>O"
            end),
        })
      end
    end,
  },
  ------------------------------------------------------------------------------
  -- Auto-Completion
  ------------------------------------------------------------------------------
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        }),
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = {},
            },
          },
        }),
      })
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },

  {
    "hrsh7th/cmp-cmdline",
    config = function() end,
  },
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-nvim-lsp",
  ------------------------------------------------------------------------------
  -- Eye Candy
  ------------------------------------------------------------------------------
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      vim.cmd([[silent! colorscheme gruvbox]])
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
      local config_buffer_close_icon = buffer_close_icon
      local config_modified_icon = modified_icon
      local config_close_icon = close_icon
      local config_indicator = indicator
      local config_separator_style = "slant"
      if not enable_nerd_fonts then
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
          top_down = true,
        },
      },
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use
          -- **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        popupmenu = {
          backend = "cmp",
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs + signature help
        },
      })
    end,
  },
})
