-- FIXME:arduino_language_server 问题
return {
  "AstroNvim/astrolsp",
  -- we need to use the function notation to get access to the `lspconfig` module
  ---@param opts AstroLSPOpts
  opts = function(plugin, opts)
    -- insert "prolog_lsp" into our list of servers
    opts.servers = opts.servers or {}
    table.insert(opts.servers, "arduino_language_server")

    -- extend our configuration table to have our new prolog server
    opts.config = require("astrocore").extend_tbl(opts.config or {}, {
      -- this must be a function to get access to the `lspconfig` module
      arduino_language_server = {
        -- the command for starting the server
        cmd = {
          "/Users/wangtianyu/.local/share/nvim/mason/packages/arduino-language-server/arduino-language-server",
          "-cli-config",
          "/Users/wangtianyu/.arduinoIDE/arduino-cli.yaml",
          "-fqbn",
          "arduino:esp32:nano_nora",
        },
        -- the filetypes to attach the server to
        filetypes = { "arduino" },
      },
    })
  end,
}
