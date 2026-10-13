return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  keys = {
    {
      "<leader>Rs",
      function()
        require("kulala").run()
      end,
      desc = "Send request",
    },
    {
      "<leader>Ra",
      function()
        require("kulala").run_all()
      end,
      desc = "Send all requests",
    },
    {
      "<leader>Rb",
      function()
        require("kulala").scratchpad()
      end,
      desc = "Open scratchpad",
    },
    {
      "<leader>Rc",
      function()
        require("kulala").copy()
      end,
      desc = "Copy as cURL",
    },
    {
      "<leader>Ri",
      function()
        require("kulala").inspect()
      end,
      desc = "Inspect request",
    },
    {
      "<leader>Rn",
      function()
        require("kulala").jump_next()
      end,
      desc = "Next request",
    },
    {
      "<leader>Rp",
      function()
        require("kulala").jump_prev()
      end,
      desc = "Prev request",
    },
    {
      "<leader>Rq",
      function()
        require("kulala").close()
      end,
      desc = "Close response",
    },
    {
      "<leader>Re",
      function()
        require("kulala").set_selected_env()
      end,
      desc = "Select environment",
    },
  },
  opts = {
    global_keymaps = false,
  },
}
