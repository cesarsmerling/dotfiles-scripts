return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons", -- or 'nvim-mini/mini.icons'
  },
  ft = { "markdown" }, -- lazy load on markdown files
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    -- renders in normal mode by default, which is what you want
    render_modes = { "n", "c" },
  },
  keys = {
    {
      "<leader>md",
      "<cmd>RenderMarkdown toggle<cr>",
      desc = "Toggle Markdown Render",
      ft = "markdown",
    },
    {
      "<leader>mp",
      "<cmd>RenderMarkdown preview<cr>",
      desc = "Markdown Preview (side-by-side)",
      ft = "markdown",
    },
  },
}
