local p = require 'neobrutalist.palette'
local function mode(accent)
  return {
    a = { fg = p.ink, bg = accent, gui = 'bold' },
    b = { fg = p.fg, bg = p.raised },
    c = { fg = p.fg, bg = p.panel },
  }
end
return {
  normal = mode(p.peach), insert = mode(p.green), visual = mode(p.lilac),
  replace = mode(p.red), command = mode(p.yellow), terminal = mode(p.blue),
  inactive = { a = { fg = p.muted, bg = p.bg }, b = { fg = p.muted, bg = p.bg }, c = { fg = p.muted, bg = p.bg } },
}
