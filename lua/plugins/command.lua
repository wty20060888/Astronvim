return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        -- first key is the augroup name
        im_switch = {
          -- the value is a list of autocommands to create
          {
            -- event is added here as a string or a list-like table of events
            event = "InsertLeave",
            command = "silent !im-select com.apple.keylayout.ABC",
            desc = "Automatically switch to English when entering Normal mode",
          },
        },
      },
    },
  },
}
