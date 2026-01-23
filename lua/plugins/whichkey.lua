-- 在对应的配置文件中对 which-key 进行配置
return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    -- opts 是已经合并了默认值的配置
    opts.keys = {
      scroll_down = "<A-j>",
      scroll_up = "<A-k>",
    }
    return opts
  end,
}
-- 或者写成
-- return {
--  "folke/which-key.nvim",
--  opts = {
--    keys = {
--      scroll_down = "<C-j>",  -- 修改滚动快捷键
--      scroll_up = "<C-k>",    -- 修改滚动快捷键
--    },
--  },
-- }
