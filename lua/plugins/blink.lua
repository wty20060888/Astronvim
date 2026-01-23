return {
  "blink.cmp",
  opts = {
    keymap = {
      ["<A-k>"] = {
        function() require("blink.cmp").scroll_documentation_up(1) end,
      },
      ["<A-j>"] = { function() require("blink.cmp").scroll_documentation_down(1) end },
    },
  },
}
