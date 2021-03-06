
local lua52 = os.getenv("LUA52")

local mt = { __len = function(o, o2)
  if lua52 then
    assert(o2 == o)
  else
    assert(o2 == nil)
  end
  return 42
end }

do
  local t = {1,2,3}
  assert(#t == 3)
  assert(#"abcdef" == 6)

  setmetatable(t, { __foo = function() end })
  assert(#t == 3)
  assert(#t == 3)

  setmetatable(t, mt)
  if lua52 then
    assert(#t == 42) -- __len DOES work on tables.
    assert(rawlen(t) == 3)
  else
    assert(#t == 3) -- __len does NOT work on tables.
  end
end

do
  local u = newproxy(true)
  getmetatable(u).__len = function(o) return 42 end
  assert(#u == 42)
  local x = 0
  for i=1,100 do x = x + #u end
  assert(x == 4200)
end

debug.setmetatable(0, mt)
assert(#1 == 42)
debug.setmetatable(0, nil)

