return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<C-j>"] = { "scroll_documentation_down", "fallback" },
      ["<C-k>"] = { "scroll_documentation_up", "fallback" },
      -- FIXME: 这里无法实现滚动1行
      -- ["<C-j>"] = { function(cmp) cmp.scroll_documentation_down(1) end, "fallback" },
      -- ["<C-k>"] = { function(cmp) cmp.scroll_documentation_up(1) end, "fallback" },
      -- ["<C-j>"] = {
      --   function()
      --     local cmp = require "blink-cmp"
      --     cmp.scroll_documentation_down(1)
      --   end,
      -- },
      -- ["<C-k>"] = {
      --   function()
      --     local cmp = require "blink-cmp"
      --     cmp.scroll_documentation_up(1)
      --   end,
      -- },
    },
  },
}
