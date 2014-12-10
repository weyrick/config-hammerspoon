
-- application titles
a_web     = "Google Chrome"
a_chat    = "Slack"
a_term    = "iTerm"
a_pyide   = "PyCharm"
a_vim     = "MacVim"
a_irc     = "Textual"
a_hermes  = "Hermes"

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
dell = "DELL U2412M"
-- work
asus = "VS24A"

-- layouts will be:
-- 1) n:1 lcd only
-- 2) n:2 lcd plus external (acer or samsung) XX or work
-- 3) n:3 lcd plus 2 external (acer, samsung)
layout_lcd = {
  {a_web, nil, lcd, hs.layout.maximized, nil, nil},
  {a_chat, nil, lcd, hs.layout.maximized, nil, nil},
  {a_term, nil, lcd, hs.layout.maximized, nil, nil},
  {a_pyide, nil, lcd, hs.layout.maximized, nil, nil},
  {a_vim, nil, lcd, hs.layout.maximized, nil, nil},
  {a_irc, nil, lcd, hs.layout.maximized, nil, nil},
}
function get_layout_2(external)
    return {
    {a_web, nil, external, hs.layout.maximized, nil, nil},
    {a_chat, nil, lcd, hs.layout.maximized, nil, nil},
    {a_term, nil, external, hs.layout.maximized, nil, nil},
    {a_pyide, nil, external, hs.geometry.rect(0.15, 0, 0.85, 1), nil, nil},
    {a_vim, nil, external, hs.geometry.rect(0.15, 0, 0.85, 1), nil, nil},
    {a_irc, nil, lcd, hs.layout.maximized, nil, nil},
    {a_hermes, nil, lcd, nil, nil, nil},
    }
end

layout_3 = {
  {a_web, nil, acer, hs.layout.maximized, nil, nil},
  {a_chat, nil, acer, hs.layout.maximized, nil, nil},
  {a_term, nil, samsung, hs.layout.maximized, nil, nil},
  {a_pyide, nil, samsung, hs.layout.maximized, nil, nil},
  {a_vim, nil, samsung, hs.layout.maximized, nil, nil},
  {a_irc, nil, acer, hs.layout.maximized, nil, nil},
  {a_hermes, nil, lcd, nil, nil, nil},
}


-- screen watcher 
function mon_change()
    print("monitor list")
    local count = 0
    for k,v in pairs(hs.screen:allScreens()) do 
        print(k, v:name())
        count = count + 1
    end
    if count == 1 then
        hs.alert.show("LCD Layout")
        hs.layout.apply(layout_lcd)
    elseif count == 2 then
        hs.alert.show("2 Monitor Layout")
        -- have to figure out which external
        hs.layout.apply(get_layout_2(dell))
    elseif count == 3 then
        hs.layout.apply(layout_3)
        hs.alert.show("3 Monitor Layout")
    else
        hs.alert.show("Unknown Monitor Layout")
    end
end
-- hs.screen.watcher.new(mon_change):start()

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "L", function()
    mon_change()
end)


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

