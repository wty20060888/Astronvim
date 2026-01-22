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
          ["<leader>s"] = {"yy<C-w>lpi<cr><C-\\><C-N><C-w>h", desc = "sendline"},
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
            function ()
              local buffers = vim.api.nvim_list_bufs()
              local repl_exist = false
              local keys

              for _, buf in ipairs(buffers) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf):match("jupyter") then
                  repl_exist = true
                  break
                end
              end
              if repl_exist then
                keys = 'y<C-w>lpi<CR><C-\\><C-N><C-w>h'
              else
                keys = 'y<C-w>li<cr><C-e><C-\\><C-N>p<C-\\><C-N>i<C-d><C-\\><C-N><C-w>h'
              end
              -- 需要正确转译keys
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes(keys,true, false, true),
                  "n",
                  false
              )
            end, desc = "sendvisual"
          },
        },
      },
      autocmds = {
        -- TODO:测试在自动命令下，keymap映射
      },
    },
  },
}
