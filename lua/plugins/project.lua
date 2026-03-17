return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup {
      -- 项目根标志
      detection_methods = { "pattern", "lsp" },
      -- 从当前文件目录向上递归查找，只要找到数组中任意一个标志，就会把该目录认定为项目根目录（数组靠前的标志优先级更高）。
      patterns = { ".git", ".pio" },
      -- 记住最近打开的项目
      show_hidden = false,
      silent_chdir = true, -- 静默切换工作目录
    }
  end,
}
