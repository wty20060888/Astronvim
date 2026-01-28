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
      local run = require "micropython_nvim.run"
      local Config = require "micropython_nvim.config"
      local UI = require "micropython_nvim.ui"

      -- 直接覆盖 M.open 函数
      repl_module.open = function()
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

      run.list_files = function()
        --  ---@return boolean
        --  local function _check_port_configured()
        --    if not Config.is_port_configured() then
        --      vim.notify("No port configured. Run :MPSetPort first.", vim.log.levels.WARN, { title = "micropython.nvim" })
        --      return false
        --    end
        --    return true
        --  end

        --  if not _check_port_configured() then return end

        --  local command = string.format("%sfs ls :; %s", Utils.get_mpremote_base(), Utils.PRESS_ENTER_PROMPT)
        --  vim.cmd("vsplit | ter " .. command)
        local Terminal = require("toggleterm.terminal").Terminal

        --- Lists files and directories in the MicroPython filesystem over the specified port.
        local function list_files_in_directory(path)
          local command = string.format("mpremote fs ls %s", path)
          local pfile = io.popen(command)
          if not pfile then
            vim.notify("Failed to execute command.", vim.log.levels.ERROR)
            return {}
          end

          local files = {}
          for filename in pfile:lines() do
            table.insert(files, filename)
          end
          pfile:close()
          return files
        end

        --- Opens the selected file in a new terminal.
        local function open_file_in_new_tab(file)
          local command = string.format("mpremote edit %s", file)
          local term = Terminal:new { cmd = command, direction = "float" }
          term:toggle()
        end

        --- Displays a list of files and directories in the MicroPython filesystem.
        run.list_files = function()
          -- 检查端口是否配置
          if not Config.is_port_configured() then
            vim.notify("No port configured. Run :MPSetPort first.", vim.log.levels.WARN, { title = "micropython.nvim" })
            return
          end

          -- 从根目录开始列出文件
          local files = list_files_in_directory ""

          -- 当前目录的绝对路径
          local current_path = "./" -- 初始化为根目录

          -- Function to handle file selection
          local function handle_selection(selected)
            if not selected then
              print "No selection made"
              return
            end

            -- 截取最后一个空格后的部分
            local last_part = selected:match "([^ ]+)$"

            -- Check if the selected item is a directory
            local is_directory = selected:sub(-1) == "/" -- Assuming directories end with '/'

            if is_directory then
              -- 更新当前路径为选择的目录的绝对路径
              current_path = current_path .. last_part -- 生成新的绝对路径
              -- Recursively list files in the selected directory
              local sub_files = list_files_in_directory(current_path:sub(1, -2)) -- 使用 fs ls <file_folder>
              if #sub_files > 0 then
                vim.ui.select(sub_files, {
                  prompt = "Select a file in " .. current_path .. ":",
                }, handle_selection)
              else
                vim.notify("No files found in directory: " .. current_path, vim.log.levels.INFO)
              end
            else
              -- Open the selected file in a new tab using edit command
              local absolute_file_path = current_path .. last_part -- 生成绝对文件路径
              open_file_in_new_tab(absolute_file_path) -- 使用 edit <file>
            end
          end

          -- Display the initial list of files and directories
          vim.ui.select(files, {
            prompt = "Select a file or directory:",
          }, handle_selection)
        end
      end
    end,
  },
}
