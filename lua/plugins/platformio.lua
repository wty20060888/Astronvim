-- TODO: 用户自定义命令
return {
  vim.api.nvim_create_user_command(
    "Pioinit",
    function(opts) -- 注意这里的 opts 参数，用于接收命令后的输入
      vim.ui.input({ prompt = "PlatformIO board: " }, function(board)
        if not board or board == "" then return end
        vim.cmd "silent wall"
        vim.notify(" 🔧 Building project for: " .. board, vim.log.levels.INFO)
        -- 1. 初始化 PlatformIO 工程
        vim.fn.system("pio project init --board=" .. board)
        vim.fn.system "pio run -t compiledb"
      end)
    end,
    {
      desc = "Init Arduino Project",
      nargs = "?", -- 表示命令接受0个或1个参数
    }
  ),
  vim.api.nvim_create_user_command(
    "Pioupload",
    function(opts) -- 注意这里的 opts 参数，用于接收命令后的输入
      -- 1. 保存项目
      vim.cmd "silent wall"

      -- 2. 编译并上传PlatformIO Uno 工程
      vim.cmd "!pio run --target upload"
    end,
    {
      desc = "Upload Arduino Project",
      nargs = "?", -- 表示命令接受0个或1个参数
    }
  ),
  vim.api.nvim_create_user_command(
    "Pioclean",
    function(opts) -- 注意这里的 opts 参数，用于接收命令后的输入
      -- 1. 保存项目
      vim.cmd "silent wall"

      -- 2. 清理编译
      vim.cmd "!pio run --target clean"
    end,
    {
      desc = "Clean Build",
      nargs = "?", -- 表示命令接受0个或1个参数
    }
  ),
  vim.api.nvim_create_user_command(
    "Piocompiledb",
    function(opts) -- 注意这里的 opts 参数，用于接收命令后的输入
      -- 1. 保存项目
      vim.cmd "silent wall"

      -- 2. 编译数据
      vim.cmd "!pio run --target compiledb"
    end,
    {
      desc = "Compile Database",
      nargs = "?", -- 表示命令接受0个或1个参数
    }
  ),
  vim.api.nvim_create_user_command(
    "Piobuild",
    function(opts) -- 注意这里的 opts 参数，用于接收命令后的输入
      -- 1. 保存项目
      vim.cmd "silent wall"

      -- 2. 编译数据
      vim.cmd "!pio run"
    end,
    {
      desc = "Build",
      nargs = "?", -- 表示命令接受0个或1个参数
    }
  ),
  vim.api.nvim_create_user_command(
    "Piomonitor",
    function(opts) -- 注意这里的 opts 参数，用于接收命令后的输入
      -- 1. 保存项目
      vim.cmd "silent wall"

      -- 2. 编译数据
      vim.cmd "10split | terminal pio run -t monitor"
    end,
    {
      desc = "Monitor",
      nargs = "?", -- 表示命令接受0个或1个参数
    }
  ),
}
