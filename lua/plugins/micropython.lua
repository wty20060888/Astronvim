-- ~/.config/nvim/lua/user/plugins/micropython.lua
return {
  {
    "jim-at-jibba/micropython.nvim",
    ft = { "python" },

    config = function()
      -- 获取插件模块
      local repl_module = require "micropython_nvim.repl"
      local Utils = require "micropython_nvim.utils"
      local pyright_config = require "micropython_nvim.project"

      -- 直接覆盖 M.open 函数
      repl_module.open = function()
        local Config = require "micropython_nvim.config"

        if not Config.is_port_configured() then
          vim.notify("No port configured. Run :MPSetPort first.", vim.log.levels.WARN, { title = "micropython.nvim" })
          return
        end

        local repl_command = Utils.get_mpremote_base() .. "repl"

        -- 完全替换这两行代码
        local repl_assembled_command = string.format(repl_command)
        -- vim.cmd("new | resize 8 | ter " .. repl_assembled_command)
        -- vim.cmd("split | ter " .. repl_assembled_command)
        vim.cmd("vsplit | ter " .. repl_assembled_command)
      end
    end,
  },
}
