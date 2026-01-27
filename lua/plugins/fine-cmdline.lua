return {
  "VonHeikemen/fine-cmdline.nvim",
  opts = {}, -- 这里可以放置插件的配置选项
  config = function()
    -- 这里执行插件的 setup 函数
    require("fine-cmdline").setup()

    -- 这里放你的按键映射
    vim.api.nvim_set_keymap("n", ":", "<cmd>FineCmdline<CR>", { noremap = true })
  end,
}
