local utils = require("config.utils")

-- Remove all trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    pcall(function()
      vim.cmd([[%s/\s\+$//e]])
    end)
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Enter insert mode when switching to terminal buffer
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "term://*",
  callback = function()
    vim.opt_local.spell = false
    vim.cmd("startinsert")
  end,
})

-- Plugin autocmds ------------------------------------------------------------

if package.loaded["lazy"] then
  if utils.is_plugin_registered("nvim-lint") then
    vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
      callback = function()
        local lint_status, lint = pcall(require, "lint")
        if lint_status then
          lint.try_lint()
        end
      end,
    })
  end

  if utils.is_plugin_registered("nvim-treesitter") then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "<filetype>" },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end

  if utils.is_plugin_registered("conform.nvim") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        if vim.g.enable_conform then
          require("conform").format({ bufnr = args.buf })
        end
      end,
    })
  end
end
