hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.alert.show("Config loaded")

-- Vim movements
hs.loadSpoon("FnMate")

hs.loadSpoon("Caffeine")
spoon.Caffeine:start()
hs.hotkey.bind({ "alt", "ctrl", "cmd", "shift" }, "ö", function()
  if hs.caffeinate.get("displayIdle") then
    hs.alert.show("Caffeine off")
  else
    hs.alert.show("Caffeine on")
  end

  spoon.Caffeine:clicked()
end)

hyperSpace = hs.hotkey.modal.new({ "ctrl", "alt", "cmd", "shift" }, "space")

function hyperSpace:entered()
  hs.alert.show("Hyper+Space mode")
  hs.timer.doAfter(2, function()
    hs.alert.show("Hyper+Space mode timeout")
    hyperSpace:exit()
  end)
end

function hyperSpace:exited()
  hs.timer.doAfter(0.5, function()
    hs.alert.closeAll()
  end)
end

hyperSpace:bind({}, "f", function()
  hs.alert.show("Hyper+Space+F pressed!")
  hyperSpace:exit()
end)
