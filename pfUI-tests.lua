local modules = {}
local print = function(msg)
  DEFAULT_CHAT_FRAME:AddMessage(msg)
end


SLASH_PFTEST1 = '/test'
function SlashCmdList.PFTEST(msg)
  if msg == "help" then
    print("|cffffffffpf|cff33ffccUI|r Test-Suite. Type `/test <module>` to run a test.")
    print("Available modules:")
    for name in pairs(modules) do print(" - " .. name) end
  elseif not modules[msg] then
    message("ERROR: no unit found: " .. msg)
  else
    modules[msg]()
  end
end

-- unit tests for the cmatch function
-- probing several locales and patterns
modules["cmatch"] = function()
  local tests = {
    -- deDE
    { name = "SPELLCASTOTHERSTART (deDE)", str = "FIRST beginnt SECOND zu wirken.", pat = "%1$s beginnt %2$s zu wirken." },
    { name = "SPELLINTERRUPTSELFOTHER (deDE)", str = "Ihr unterbrecht SECOND von FIRST.", pat =  "Ihr unterbrecht %2$s von %1$s." },
    { name = "SPELLLOGABSORBOTHEROTHER (deDE)", str = "SECOND von FIRST wird absorbiert von: THIRD.", pat = "%2$s von %1$s wird absorbiert von: %3$s." },

    -- ruRU
    { name = "SPELLCASTOTHERSTART (ruRU)", str = "FIRST начинает использовать \"SECOND\".", pat = "%s начинает использовать \"%s\"." },
    { name = "SPELLINTERRUPTSELFOTHER (ruRU)", str = "Вы прервали заклинание \"SECOND\" FIRST.", pat = "Вы прервали заклинание \"%2$s\" %1$s." },
    { name = "SPELLLOGABSORBOTHEROTHER (ruRU)", str = "THIRD поглощает заклинание \"SECOND\" FIRST.", pat = "%3$s поглощает заклинание \"%2$s\" %1$s." },
    { name = "SPELLLOGCRITSCHOOLOTHEROTHER (ruRU)", str = "\"SECOND\" FIRST наносит THIRD 444 ед. урона (FIFTH): критический эффект.", pat = "\"%2$s\" %1$s наносит %3$s %4$d ед. урона (%5$s): критический эффект." },

    -- zhCN
    { name = "HEALEDSELFOTHER (zhCN)", str = "你的FIRST治疗了SECOND333点生命值。", pat = "你的%s治疗了%s%d点生命值。" },
  }

  for _, test in pairs(tests) do
    local first, second, third, fourth, fifth = pfUI.api.cmatch(test.str, test.pat)
    print("|r-> |cff33ffcc" .. test.name)
    print("pattern: |r" .. test.pat)
    print("string: |r" .. test.str)
    print("values: |r%1=" .. ( first and ( (first == "FIRST" or first == "111") and "|cff33ffcc"..first or "|cffff5555" .. first ) or "nil" ) .. "|cffaaaaaa :: |r" ..
                      "%2=" .. ( second and ( (second == "SECOND" or second == "222") and "|cff33ffcc"..second or "|cffff5555" .. second ) or "nil" ) .. "|cffaaaaaa :: |r" ..
                      "%3=" .. ( third and ( (third == "THIRD" or third == "333") and "|cff33ffcc"..third or "|cffff5555" .. third ) or "nil" ) .. "|cffaaaaaa :: |r" ..
                      "%4=" .. ( fourth and ( (fourth == "FOURTH" or fourth == "444") and "|cff33ffcc"..fourth or "|cffff5555" .. fourth ) or "nil" ) .. "|cffaaaaaa :: |r" ..
                      "%5=" .. ( fifth and ( (fifth == "FIFTH" or fifth == "555") and "|cff33ffcc"..fifth or "|cffff5555" .. fifth ) or "nil" ))
    if ( first and (first == "FIRST" or first == "111") or first == nil ) and
    ( second and (second == "SECOND" or second == "222") or second == nil ) and
    ( third and (third == "THIRD" or third == "333") or third == nil ) and
    ( fourth and (fourth == "FOURTH" or fourth == "444") or fourth == nil ) and
    ( fifth and (fifth == "FIFTH" or fifth == "555") or fifth == nil ) then
      print("|r[|cff33ffccOK|r]")
    else
      print("|r[|cffff5555ERROR|r]")
    end

    print(" ")
  end

  -- probe execution time
  local time = GetTime()
  for i=1,1000000 do
    local first, second, third, fourth, fifth = pfUI.api.cmatch(tests[8].str, tests[8].pat)
  end
  print("1000000 runs took: " .. GetTime() - time .. " seconds.")
end
