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
        -- 2. 定义 main.cpp 示例代码内容
        local main_code = table.concat({
          "#include <Arduino.h>",
          "void setup() {",
          "    pinMode(LED_BUILTIN, OUTPUT);",
          "    Serial.begin(9600);",
          "}",
          "void loop() {",
          "    digitalWrite(LED_BUILTIN, HIGH);",
          "    delay(1000);",
          "    digitalWrite(LED_BUILTIN, LOW);",
          "    delay(1000);",
          "}",
        }, "\n")

        -- 3. 写入代码到 src/main.cpp
        local file = io.open("src/main.cpp", "w")
        if file then
          file:write(main_code)
          file:close()
        end
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
      -- 1. 编译 PlatformIO Uno 工程
      vim.cmd "silent wall"
      vim.cmd "!pio run"

      -- 2. 上传PlatformIO Uno 工程
      vim.cmd "!pio run --target upload"
    end,
    {
      desc = "Upload Arduino Project",
      nargs = "?", -- 表示命令接受0个或1个参数
    }
  ),
}
