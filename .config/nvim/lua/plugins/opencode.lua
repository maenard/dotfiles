return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },

  config = function() end,

  keys = {
    -- 🔹 Ask (general)
    {
      "<leader>oa",
      function()
        require("opencode").ask()
      end,
      desc = "OpenCode: Ask",
      mode = { "n", "x" },
    },

    -- 🔹 Ask with current selection/context
    {
      "<leader>oo",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      desc = "OpenCode: Ask about selection",
      mode = { "n", "x" },
    },

    -- 🔹 Select / execute action
    {
      "<leader>os",
      function()
        require("opencode").select()
      end,
      desc = "OpenCode: Select action",
      mode = { "n", "x" },
    },

    -- 🔹 Toggle UI
    {
      "<leader>ot",
      function()
        require("opencode").toggle()
      end,
      desc = "OpenCode: Toggle",
      mode = { "n", "t" },
    },

    -- 🔹 Operator (motion-based, like `d`, `y`)
    {
      "go",
      function()
        return require("opencode").operator("@this ")
      end,
      desc = "OpenCode: Apply to motion",
      expr = true,
      mode = "n",
    },

    -- 🔹 Current line shortcut
    {
      "goo",
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      desc = "OpenCode: Apply to line",
      expr = true,
      mode = "n",
    },

    -- 🔹 Scroll inside OpenCode
    {
      "<leader>ou",
      function()
        require("opencode").command("session.half.page.up")
      end,
      desc = "OpenCode: Scroll up",
      mode = "n",
    },
    {
      "<leader>od",
      function()
        require("opencode").command("session.half.page.down")
      end,
      desc = "OpenCode: Scroll down",
      mode = "n",
    },
  },
}
