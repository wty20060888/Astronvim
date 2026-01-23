-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  -- Themes
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  -- Gits
  { import = "astrocommunity.git.codediff-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },
  -- Pack
  { import = "astrocommunity.pack.python" },
  -- Markdown
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
}
