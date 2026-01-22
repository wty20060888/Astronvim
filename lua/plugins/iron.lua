-- ~/.config/nvim/lua/user/plugins/iron.lua
return {
  {
    "hkupty/iron.nvim",
    ft = { "python", "lua", "javascript", "typescript" }, -- 指定文件类型
    config = function()
      local iron = require "iron.core"

      iron.setup {
        config = {
          -- 是否应该重用窗口
          reuse_windows = true,
          -- REPL 定义
          repl_definition = {
            python = {
              command = { "jupyter", "console" },
            },
            lua = {
              command = { "lua" },
            },
            javascript = {
              command = { "node" },
            },
            typescript = {
              command = { "npx", "ts-node" },
            },
            sh = {
              command = { "zsh" },
            },
          },
          -- REPL 打开时自动聚焦
          repl_open_cmd = "vertical split",
          -- repl_open_cmd = "below 8 split",
        },
        -- 快捷键映射
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_until_cursor = "<space>su",
          send_mark = "<space>sm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      }
    end,
  },
}
