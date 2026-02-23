return {
  "yuukiflow/Arduino-Nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "neovim/nvim-lspconfig",
  },
  ft = { "arduino" },
  config = function()
    -- Load Arduino plugin for .ino files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "arduino",
      callback = function() require "Arduino-Nvim" end,
    })
    -- keymap
    -- require "Arduino-Nvim"
    -- vim.keymap.del("n", "<Leader>au")
    -- vim.keymap.set("n", "<Leader>ad", ":InoUpload<CR>", { silent = true }) -- Upload code
    -- 这样修改配置
    -- local arduino_nvim = require "Arduino-Nvim"
    -- arduino_nvim.upload = function() vim.notify "hahaha" end
  end,
}
