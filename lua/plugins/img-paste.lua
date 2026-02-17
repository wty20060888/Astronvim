return {
  "img-paste-devs/img-paste.vim",
  ft = { "markdown" }, -- 指定文件类型
  keys = {
    {
      "<leader>Mv",
      function() vim.cmd "call mdip#MarkdownClipboardImage()" end,
      desc = "Paste image",
      mode = "n",
    },
  },
}
