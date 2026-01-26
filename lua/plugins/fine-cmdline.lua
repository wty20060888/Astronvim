return {
  "VonHeikemen/fine-cmdline.nvim",
  config = {
    vim.api.nvim_set_keymap("n", ":", "<cmd>FineCmdline<CR>", { noremap = true }),
  },
}
