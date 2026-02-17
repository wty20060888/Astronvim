return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          -- second key is the lefthand side of the map
          -- mappings seen under group name "Buffer"
          ["H"] = { "0", desc = "Move to the beginning of the line" },
          ["L"] = { "$", desc = "Move to the end of the line" },
          ["J"] = { "5j", desc = "Move up 5 lines" },
          ["K"] = { "5k", desc = "Move down 5 lines" },
          ["<leader>s"] = { "yy<C-w>lpi<cr><C-\\><C-N><C-w>h", desc = "Sendline" },
          ["<leader>j"] = { "", desc = " Jupyter" },
          ["<leader>jc"] = { ":IronRepl<cr>", desc = "Toggle Console" },
          ["<leader>m"] = { "", desc = " Microchip" },
          ["<leader>mp"] = {
            function()
              -- 获取所有缓冲区的列表
              local buffers = vim.api.nvim_list_bufs()
              local repl_exists = false

              -- 检查是否有缓冲区名称包含 'mpremote'
              for _, buf in ipairs(buffers) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf):match "mpremote" then
                  repl_exists = true
                  break
                end
              end

              -- 根据检查结果执行相应的操作
              if repl_exists then
                -- 如果 REPL 存在，关闭 REPL
                for _, buf in ipairs(buffers) do
                  if vim.api.nvim_buf_get_name(buf):match "mpremote" then
                    -- 使用 feedkeys 模拟按键操作
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>l", true, false, true), "n", true)
                    --vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i<C-x><Cr><C-\\><C-n>", true, false, true), "n", true)
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i<C-x><cr>", true, false, true), "n", true)
                    vim.defer_fn(
                      function()
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<cr>", true, false, true), "n", true)
                      end,
                      800
                    ) -- 延时800毫秒（ESP关闭速度较慢）
                    print "REPL 已关闭"
                    break
                  end
                end
              else
                -- 如果 REPL 不存在，打开 MPRepl
                vim.cmd "MPRepl"
                -- 切换到插入模式并移动光标
                vim.api.nvim_feedkeys(
                  vim.api.nvim_replace_termcodes("i<C-\\><C-N><C-w>h", true, false, true),
                  "n",
                  true
                )
                print "REPL 已打开"
              end
            end,
            desc = "Toggle MPRepl",
          },
        },
        t = {
          ["H"] = { "0", desc = "Move to the beginning of the line" },
          ["L"] = { "$", desc = "Move to the end of the line" },
          ["J"] = { "5j", desc = "Move up 5 lines" },
          ["K"] = { "5k", desc = "Move down 5 lines" },
        },
        v = {
          ["H"] = { "0", desc = "Move to the beginning of the line" },
          ["L"] = { "$", desc = "Move to the end of the line" },
          ["J"] = { "5j", desc = "Move up 5 lines" },
          ["K"] = { "5k", desc = "Move down 5 lines" },
          ["<leader>s"] = {
            function()
              local buffers = vim.api.nvim_list_bufs()
              local repl_exist = false
              local keys

              for _, buf in ipairs(buffers) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf):match "jupyter" then
                  repl_exist = true
                  break
                end
              end
              if repl_exist then
                keys = "y<C-w>lpi<CR><C-\\><C-N><C-w>h"
              else
                keys = "y<C-w>li<cr><C-e><C-\\><C-N>p<C-\\><C-N>i<C-d><C-\\><C-N><C-w>h"
              end
              -- 需要正确转译keys
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
            end,
            desc = "Sendvisual",
          },
        },
        o = {
          ["H"] = { "0", desc = "Beginning of the line" },
          ["L"] = { "$", desc = "End of the line" },
          ["J"] = { "5j", desc = "Up 5 lines" },
          ["K"] = { "5k", desc = "Down 5 lines" },
        },
      },
      autocmds = {
        -- TODO:测试在自动命令下，keymap映射
        -- NOTE: 后期测试
      },
    },
  },
  -- 自定义快捷键
}
