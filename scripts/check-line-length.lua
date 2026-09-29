-- Copyright (C) 2026 IEEE UFG Computer Society contributors.
-- Distributed under the LaTeX Project Public License 1.3c or later.
-- See LICENSE and MANIFEST.md.

local limit = 80
local failed = false

for _, path in ipairs(arg) do
  local number = 0
  for line in io.lines(path) do
    number = number + 1
    local length = utf8.len(line)
    if not length then
      io.stderr:write(path .. ": invalid UTF-8\n")
      failed = true
    elseif length > limit then
      local message = "%s:%d: line has %d characters (maximum %d)\n"
      io.stderr:write(message:format(path, number, length, limit))
      failed = true
    end
  end
end

if failed then
  os.exit(1)
end
