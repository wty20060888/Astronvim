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
      -- M.init函数
      pyright_config.TEMPLATES = {
        pyright_config = [[
{
  "reportMissingModuleSource": false,
  "typeCheckingMode": "off"
}
]],

        micropython_config = [[
# MicroPython project configuration
# PORT can be: auto, /dev/ttyUSB0, /dev/ttyACM0, id:<serial>, etc.
PORT=auto
# BAUD is optional - mpremote auto-detects, but can be set for edge cases
BAUD=115200
]],

        main = [[
from machine import Pin
from time import sleep

led = Pin("LED", Pin.OUT)

while True:
    led.value(not led.value())
    print("LED is ON" if led.value() else "LED is OFF")
    sleep(0.5)
]],

        gitignore = [[
.venv/
__pycache__/
*.pyc
]],
      }

      ---@param project_name string
      ---@param stub_package string
      ---@return string
      local function _generate_pyproject(project_name, stub_package)
        return string.format(
          [[
[project]
name = "%s"
version = "0.1.0"
requires-python = ">=3.10"
dependencies = [
    "mpremote",
    "ruff",
]

[dependency-groups]
dev = [
    "%s",
]
]],
          project_name,
          stub_package
        )
      end

      ---@param path string
      ---@param content string
      ---@return boolean
      local function _write_file_safe(path, content)
        local result = vim.fn.writefile(vim.fn.split(content, "\n"), path)
        if result == -1 then
          vim.notify("Failed to write " .. path, vim.log.levels.ERROR, { title = "micropython.nvim" })
          return false
        end
        return true
      end

      ---@param cwd string
      local function _run_uv_sync(cwd)
        vim.notify("Running uv sync...", vim.log.levels.INFO, { title = "micropython.nvim" })
        vim.fn.jobstart("uv sync", {
          cwd = cwd,
          on_exit = function(_, code, _)
            vim.schedule(function()
              if code == 0 then
                vim.notify("Dependencies installed", vim.log.levels.INFO, { title = "micropython.nvim" })
              else
                vim.notify("uv sync failed (exit " .. code .. ")", vim.log.levels.ERROR, { title = "micropython.nvim" })
              end
            end)
          end,
        })
      end

      ---@param cwd string
      local function _prompt_uv_sync(cwd)
        if Utils.uv_available() then
          UI.select({ "Yes", "No" }, {
            prompt = "Run `uv sync` to install dependencies?",
          }, function(choice)
            if choice == "Yes" then _run_uv_sync(cwd) end
          end)
        else
          vim.notify(
            "uv not found. Install: curl -LsSf https://astral.sh/uv/install.sh | sh",
            vim.log.levels.INFO,
            { title = "micropython.nvim" }
          )
        end
      end

      local function _check_legacy_files()
        if Utils.requirements_exists() then
          vim.notify(
            "Found legacy requirements.txt. Consider removing after migration.",
            vim.log.levels.WARN,
            { title = "micropython.nvim" }
          )
        end

        if Utils.ampy_config_exists() then
          vim.notify(
            "Found legacy .ampy file. Consider removing it.",
            vim.log.levels.WARN,
            { title = "micropython.nvim" }
          )
        end
      end

      ---@param board table
      local function _create_project_files(board)
        local cwd = Utils.get_cwd()
        local project_name = Utils.get_directory_name()

        local files_to_create = {
          {
            path = cwd .. "/pyproject.toml",
            content = _generate_pyproject(project_name, board.stub),
            name = "pyproject.toml",
          },
          {
            path = cwd .. "/pyrightconfig.json",
            content = pyright_config.TEMPLATES.pyright_config,
            name = "pyrightconfig.json",
          },
          { path = cwd .. "/main.py", content = pyright_config.TEMPLATES.main, name = "main.py" },
          {
            path = cwd .. "/.micropython",
            content = pyright_config.TEMPLATES.micropython_config,
            name = ".micropython",
          },
          {
            path = cwd .. "/.gitignore",
            content = pyright_config.TEMPLATES.gitignore,
            name = ".gitignore",
          },
        }

        for _, file in ipairs(files_to_create) do
          _write_file_safe(file.path, file.content)
        end

        _check_legacy_files()

        vim.notify(
          "Project created with " .. board.name .. " stubs",
          vim.log.levels.INFO,
          { title = "micropython.nvim" }
        )

        _prompt_uv_sync(cwd)
      end

      local function _select_board_and_create()
        local board_names = {}
        for _, board in ipairs(pyright_config.BOARDS) do
          table.insert(board_names, board.name)
        end

        UI.select(board_names, {
          prompt = "Select target board:",
        }, function(choice)
          if not choice then
            vim.notify("Project init cancelled", vim.log.levels.INFO, { title = "micropython.nvim" })
            return
          end

          local selected_board = nil
          for _, board in ipairs(pyright_config.BOARDS) do
            if board.name == choice then
              selected_board = board
              break
            end
          end

          if selected_board then _create_project_files(selected_board) end
        end)
      end

      ---@param force? boolean
      function pyright_config.init(force)
        force = force or false
        local cwd = Utils.get_cwd()

        local files_to_check = {
          "pyproject.toml",
          "pyrightconfig.json",
          "main.py",
          ".micropython",
          ".gitignore",
        }

        local existing_files = {}
        for _, filename in ipairs(files_to_check) do
          if vim.fn.filereadable(cwd .. "/" .. filename) == 1 then table.insert(existing_files, filename) end
        end

        if #existing_files > 0 and not force then
          UI.select({ "Yes", "No" }, {
            prompt = "Files exist (" .. table.concat(existing_files, ", ") .. "). Overwrite?",
          }, function(choice)
            if choice == "Yes" then
              _select_board_and_create()
            else
              vim.notify("Project init cancelled", vim.log.levels.INFO, { title = "micropython.nvim" })
            end
          end)
          return
        end

        _select_board_and_create()
      end

      function pyright_config.install()
        local cwd = Utils.get_cwd()

        if not Utils.uv_available() then
          vim.notify(
            "uv not found. Install: curl -LsSf https://astral.sh/uv/install.sh | sh",
            vim.log.levels.ERROR,
            { title = "micropython.nvim" }
          )
          return
        end

        if not Utils.pyproject_exists() then
          vim.notify(
            "No pyproject.toml found. Run :MPInit first.",
            vim.log.levels.ERROR,
            { title = "micropython.nvim" }
          )
          return
        end

        _run_uv_sync(cwd)
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
