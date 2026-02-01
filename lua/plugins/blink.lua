return {
  "blink.cmp",
  opts = {
    keymap = {
      ["<C-K>"] = { function() require("blink.cmp").scroll_documentation_up(1) end },
      ["<C-J>"] = { function() require("blink.cmp").scroll_documentation_down(1) end },
    },
  },
}
