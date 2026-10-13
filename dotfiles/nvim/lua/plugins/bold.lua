-- Bold markdown in a softer light color instead of nordfox's red
return {
  {
    "LazyVim/LazyVim",
    init = function()
      local function apply()
        if vim.g.colors_name ~= "nordfox" then
          return
        end
        local hl = { fg = "#c2cad9", bold = true } -- slightly darker than Nord snow storm
        for _, g in ipairs({ "@markup.strong", "@markup.strong.markdown_inline", "markdownBold", "markdownBoldDelimiter" }) do
          vim.api.nvim_set_hl(0, g, hl)
        end
      end
      vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })
      vim.schedule(apply)
    end,
  },
}
