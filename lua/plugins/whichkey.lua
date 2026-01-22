-- 在对应的配置文件中对 which-key 进行配置
return {
  "folke/which-key.nvim",
  opts = {
    keys = {
      scroll_down = "<C-j>", -- 新的向下滚动快捷键
      scroll_up = "<C-k>", -- 新的向上滚动快捷键
    },
    -- 其他 which-key 配置...
  },
}
