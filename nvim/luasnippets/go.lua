local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local parse = ls.parser.parse_snippet

return {
  parse(
    "ife",
    [[
if err != nil {
  return err
}
]]
  ),
  parse(
    "ifne",
    [[
if err != nil {
  return nil, err
}
]]
  ),
  parse(
    "iff",
    [[
if err != nil {
  log.Fatal(err)
}
]]
  ),
  parse("pl", "fmt.Println($0)"),
  parse("pr", "fmt.Printf(\"$0 = %+v\\n\", $0)"),
  parse("st", [[
type $1 struct {
	$0
}]]),
  parse("int", [[
type $1 interface {
	$0
}]]),
}
