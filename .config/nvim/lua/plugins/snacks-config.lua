-- ── real-time clock ─────────────────────────────────────────────────────────
-- A timer ticks once a second and asks the dashboard to re-resolve its
-- sections, so the clock section below renders the current time each tick.
local clock = {}

-- 3x5 bitmap font; each '#' becomes a full block, each space a blank column.
local font = {
  ["0"] = { "###", "# #", "# #", "# #", "###" },
  ["1"] = { "  #", "  #", "  #", "  #", "  #" },
  ["2"] = { "###", "  #", "###", "#  ", "###" },
  ["3"] = { "###", "  #", "###", "  #", "###" },
  ["4"] = { "# #", "# #", "###", "  #", "  #" },
  ["5"] = { "###", "#  ", "###", "  #", "###" },
  ["6"] = { "###", "#  ", "###", "# #", "###" },
  ["7"] = { "###", "  #", "  #", "  #", "  #" },
  ["8"] = { "###", "# #", "###", "# #", "###" },
  ["9"] = { "###", "# #", "###", "  #", "###" },
  [":"] = { " ", "#", " ", "#", " " },
}

---@param str string
---@return string
function clock.art(str)
  local rows = { "", "", "", "", "" }
  for ch in str:gmatch(".") do
    local glyph = font[ch]
    if glyph then
      for r = 1, 5 do
        rows[r] = rows[r] .. glyph[r]:gsub("#", "██"):gsub(" ", "  ") .. "  "
      end
    end
  end
  -- every glyph contributes the same number of columns to each row, so the
  -- rows stay equal width and centre as one block
  return table.concat(rows, "\n")
end

---@return snacks.dashboard.Section
function clock.section()
  return {
    pane = 2,
    padding = 1,
    align = "center",
    text = {
      {
        clock.art(os.date("%H:%M:%S") --[[@as string]]),
        hl = "SnacksDashboardHeader",
      },
      { "\n\n" .. os.date("%A, %d %B %Y"), hl = "SnacksDashboardDesc" },
    },
  }
end

function clock.start()
  if clock.timer then
    return
  end
  clock.timer = vim.uv.new_timer()
  clock.timer:start(
    1000,
    1000,
    vim.schedule_wrap(function()
      Snacks.dashboard.update()
    end)
  )
end

function clock.stop()
  if clock.timer then
    clock.timer:stop()
    clock.timer:close()
    clock.timer = nil
  end
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    local group = vim.api.nvim_create_augroup("dashboard_clock", { clear = true })
    vim.api.nvim_create_autocmd("User", { group = group, pattern = "SnacksDashboardOpened", callback = clock.start })
    vim.api.nvim_create_autocmd("User", { group = group, pattern = "SnacksDashboardClosed", callback = clock.stop })
  end,
  opts = {

    bigfile = { enabled = true },

    ---@class snacks.dashboard.Config
    ---@field enabled? boolean
    ---@field sections snacks.dashboard.Section
    ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
    dashboard = {
      width = 60,
      row = nil, -- dashboard position. nil for center
      col = nil, -- dashboard position. nil for center
      pane_gap = 4, -- empty columns between vertical panes
      autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
      -- These settings are used by some built-in sections
      preset = {
        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        ---@type fun(cmd:string, opts:table)|nil
        pick = nil,
        -- Used by the `keys` section to show keymaps.
        -- Set your custom keymaps here.
        -- When using a function, the `items` argument are the default keymaps.
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        -- Used by the `header` section
        header = [[
                                                         ░██    
░█████████████   ░██████    ░███████  ░████████           ░██   
░██   ░██   ░██       ░██  ░██    ░██ ░██    ░██    ░██     ░██ 
░██   ░██   ░██  ░███████  ░█████████ ░██    ░██            ░██ 
░██   ░██   ░██ ░██   ░██  ░██        ░██    ░██            ░██ 
░██   ░██   ░██  ░█████░██  ░███████  ░██    ░██    ░██   ░██   
                                                         ░██    
]],
      },
      -- item field formatters
      formats = {
        icon = function(item)
          if item.file and item.icon == "file" or item.icon == "directory" then
            return Snacks.dashboard.icon(item.file, item.icon)
          end
          return { item.icon, width = 2, hl = "icon" }
        end,
        footer = { "%s", align = "center" },
        header = { "%s", align = "center" },
        file = function(item, ctx)
          local fname = vim.fn.fnamemodify(item.file, ":~")
          fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
          if #fname > ctx.width then
            local dir = vim.fn.fnamemodify(fname, ":h")
            local file = vim.fn.fnamemodify(fname, ":t")
            if dir and file then
              file = file:sub(-(ctx.width - #dir - 2))
              fname = dir .. "/…" .. file
            end
          end
          local dir, file = fname:match("^(.*)/(.+)$")
          return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
        end,
      },
      sections = {
        { section = "header" },
        clock.section,
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },
    indent = { enabled = false },
    input = { enabled = true },
    picker = {
      enabled = true,
      hidden = true,
      ignored = true,
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
}
