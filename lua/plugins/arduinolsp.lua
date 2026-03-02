if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- 删除上面这行注释以激活此文件
return {
  "AstroNvim/astrolsp",
  opts = function(plugin, opts)
    -- 插入 "arduino_language_server" 到服务器列表
    opts.servers = opts.servers or {}
    table.insert(opts.servers, "arduino_language_server")

    -- 扩展配置表以包含新的 arduino 服务器
    opts.config = require("astrocore").extend_tbl(opts.config or {}, {
      arduino_language_server = {
        -- 启动服务器的命令
        cmd = {
          "arduino-language-server",
          "-cli-config",
          "/Users/wangtianyu/Library/Arduino15/arduino-cli.yaml",
          "-fqbn",
          "arduino:avr:uno",
          "-cli",
          "arduino-cli",
          "-clangd",
          "clangd",
        },
        -- 服务器支持的文件类型
        filetypes = { "arduino", "ino" },
        root_dir = require("lspconfig.util").root_pattern("sketch.yaml", ".git"),

        -- 修复：使用安全的方式获取 capabilities
        capabilities = (function()
          -- 尝试从 astrolsp 获取 capabilities
          local ok, astrolsp_cap = pcall(require, "astrolsp")
          if ok and astrolsp_cap.capabilities then
            local cap = vim.deepcopy(astrolsp_cap.capabilities)
            cap.semanticTokensProvider = nil
            return cap
          end

          -- 如果 astrolsp 不可用，则使用默认的 LSP capabilities
          local cap = vim.lsp.protocol.make_client_capabilities()
          -- 添加常见的能力
          cap.textDocument = {
            completion = {
              completionItem = {
                snippetSupport = true,
                commitCharactersSupport = true,
                deprecatedSupport = true,
                preselectSupport = true,
                tagSupport = { valueSet = { 1 } },
                insertReplaceSupport = true,
                resolveSupport = {
                  properties = { "documentation", "detail", "additionalTextEdits" },
                },
              },
            },
          }
          cap.semanticTokensProvider = nil
          return cap
        end)(),
      },
    })
  end,
}
