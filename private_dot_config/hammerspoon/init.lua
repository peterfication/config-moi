hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.alert.show("Config loaded")

-- Vim movements
hs.loadSpoon("FnMate")

hs.loadSpoon("Caffeine")
spoon.Caffeine:start()
hs.hotkey.bind({ "alt", "ctrl", "cmd", "shift" }, "y", function()
  if hs.caffeinate.get("displayIdle") then
    hs.alert.show("Caffeine off")
  else
    hs.alert.show("Caffeine on")
  end

  spoon.Caffeine:clicked()
end)
