
-- application titles
a_web     = "Google Chrome"
a_chat    = "Slack"
a_term    = "iTerm"
a_pyide   = "PyCharm"
a_vim     = "MacVim"
a_irc     = "Textual"

local appkeys = {}
appkeys["1"] = a_web
appkeys["3"] = a_chat
appkeys["4"] = a_term 
appkeys["5"] = a_pyide
appkeys["6"] = a_vim
appkeys["7"] = a_irc

-- monitors
lcd = "Color LCD"
-- home
acer = "V223W"
samsung = "SyncMaster"

-- application hotkeys
for key, title in pairs(appkeys) do 
    -- three key version
    hs.hotkey.bind({"cmd","alt"}, key, function()
    local app = hs.appfinder.appFromName(title)
    if app then 
        app:activate()
    end
    end)
    -- one key version on numpad
    hs.hotkey.bind({}, "pad" .. key, function()
    local app = hs.appfinder.appFromName(title)
    if app then 
        app:activate()
    end
    end)
end

-- maximize active window
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M", function()
  local win = hs.window.focusedWindow()
  win:maximize(f)
end)

-- config autoreload
function reload_config(files)
    hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")
