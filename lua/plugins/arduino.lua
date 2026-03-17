-- TODO: 用户自定义命令
return {
  vim.api.nvim_create_user_command(
    "Pioinit",
    function(opts) -- 注意这里的 opts 参数，用于接收命令后的输入
      -- 1. 初始化 PlatformIO Uno 工程
      vim.notify("🔧 初始化 Arduino Uno 工程...", vim.log.levels.INFO)
      vim.fn.system "pio project init --board uno"

      -- 2. 生成 compile_commands.json（供 clangd 代码补全）
      vim.notify("🔧 生成编译数据库...", vim.log.levels.INFO)
      vim.fn.system "pio run -t compiledb"

      -- 3. 定义 main.cpp 示例代码内容
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

      -- 4. 写入代码到 src/main.cpp
      local file = io.open("src/main.cpp", "w")
      if file then
        file:write(main_code)
        file:close()
      end

      -- 5. 完成提示
      vim.notify("✅ Arduino Uno 工程初始化完成！", vim.log.levels.SUCCESS)
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
