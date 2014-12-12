
-- application titles
a_web     = "Google Chrome"
a_chat    = "Slack"
a_term    = "iTerm"
a_pyide   = "PyCharm"
a_vim     = "MacVim"
a_irc     = "Textual"
a_hermes  = "Hermes"
a_mail    = "Mail"

local appkeys = {}
appkeys["1"] = a_web
appkeys["3"] = a_chat
appkeys["4"] = a_term 
appkeys["5"] = a_pyide
appkeys["6"] = a_vim
appkeys["7"] = a_irc
appkeys["8"] = a_mail

-- monitors
lcd = "Color LCD"
-- home
dell = "DELL U2412M"
-- work
asus = "VS24A"

-- layouts will be:
-- 1) n:1 lcd only
-- 2) n:2 lcd plus external (dell or asus)
-- 3) n:1 external only (dell or asus)
layout_lcd = {
  {a_web, nil, lcd, hs.layout.maximized, nil, nil},
  {a_chat, nil, lcd, hs.layout.maximized, nil, nil},
  {a_term, nil, lcd, hs.layout.maximized, nil, nil},
  {a_pyide, nil, lcd, hs.layout.maximized, nil, nil},
  {a_vim, nil, lcd, hs.layout.maximized, nil, nil},
  {a_irc, nil, lcd, hs.layout.maximized, nil, nil},
}
function get_layout_ext(external)
    return {
    {a_web, nil, external, hs.layout.maximized, nil, nil},
    {a_chat, nil, external, hs.layout.left75, nil, nil},
    {a_term, nil, external, hs.layout.maximized, nil, nil},
    {a_pyide, nil, external, hs.geometry.rect(0.15, 0, 0.85, 1), nil, nil},
    {a_vim, nil, external, hs.geometry.rect(0.15, 0, 0.85, 1), nil, nil},
    {a_irc, nil, external, hs.layout.left75, nil, nil},
    {a_hermes, nil, external, nil, nil, nil},
    }
end

-- screen watcher 
function mon_change()
    print("monitor list")
    local count = 0
    local cur_ext = nil
    local have_lcd = false
    for k,v in pairs(hs.screen:allScreens()) do 
        print(k, v:name())
        count = count + 1
        if v:name() == dell then
            cur_ext = dell
        elseif v:name() == asus then
            cur_ext = asus
        elseif v:name() == lcd then
            have_lcd = true
        end
    end
    print("there are " .. count .. " monitors, have_lcd is " .. tostring(have_lcd) .. " and cur_ext is " .. cur_ext)
    if count == 1 then
        if have_lcd then
            hs.alert.show("LCD Layout")
            hs.layout.apply(layout_lcd)
        else
            hs.alert.show("External Layout")
            hs.layout.apply(get_layout_ext(cur_ext))
        end
    elseif count == 2 then
        hs.alert.show("2 Monitor Layout")
        hs.layout.apply(get_layout_ext(cur_ext))
    else
        hs.alert.show("Unknown Monitor Layout")
    end
end

-- enable this to switch layouts automatically when monitors change
-- but i've seen some weirdness where it fires even when they haven't changed
-- leaving manual with keystroke below for now
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

-- function to read a file
function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

-- function to run applescript file
function runAppleScript(file)
    script_body = readAll(file)
    hs.applescript.applescript(script_body)
end

-- special hotkey to run apple script to switch to gmail
hs.hotkey.bind({}, "pad2", function()
    runAppleScript(os.getenv("HOME") .. "/bin/switch_to_gmail.scpt")
end)

-- config autoreload
function reload_config(files)
    hs.reload() 
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")

