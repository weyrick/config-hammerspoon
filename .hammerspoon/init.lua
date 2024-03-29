hs.consoleOnTop(true)
hs.application.enableSpotlightForNameSearches(true)

-- window titles (typically browser windows)
w_web     = "^Main Browser.+"
w_mail    = "^Mail.+"
w_cal     = "^Calendar.+"
w_notion  = "^Notion.+"
-- application titles
a_chat    = "Slack"
a_term    = "iTerm2"
a_pyide   = "PyCharm"
a_clion   = "CLion-EAP"
a_sublime = "Sublime Text"
a_goland  = "GoLand"
a_zoom    = "zoom.us"
-- a_linear  = "Linear"
-- a_notion  = "Notion"

local appkeys = {}
appkeys["1"] = w_web
appkeys["2"] = w_cal
appkeys["3"] = a_chat
appkeys["4"] = a_term 
appkeys["5"] = w_mail
appkeys["6"] = a_pyide
appkeys["7"] = a_goland
appkeys["8"] = a_clion
appkeys["9"] = a_zoom
appkeys["0"] = w_notion

-- monitors
lcd = "Built-in Retina Display"
-- home
dell = "DELL U2412M"

-- layouts will be:
-- 1) n:1 lcd only
-- 2) n:2 lcd plus external (dell or asus)
-- 3) n:1 external only (dell or asus)
layout_lcd = {
  {nil, w_web, lcd, hs.layout.maximized, nil, nil},
  {a_chat, nil, lcd, hs.layout.maximized, nil, nil},
  {a_term, nil, lcd, hs.layout.maximized, nil, nil},
  {a_pyide, nil, lcd, hs.layout.maximized, nil, nil},
  {a_goland, nil, lcd, hs.layout.maximized, nil, nil},
  {a_clion, nil, lcd, hs.layout.maximized, nil, nil},
  {a_sublime, nil, lcd, hs.layout.maximized, nil, nil},
}
function get_layout_ext(external)
    return {
    {nil, w_web, external, hs.layout.maximized, nil, nil},
    {nil, w_mail, external, hs.geometry.rect(0.15, 0, 0.85, 1), nil, nil},
--    {a_chat, nil, external, hs.geometry.rect(0.15, 0, 0.85, 1), nil, nil},
    {a_chat, nil, external, hs.layout.maximized, nil, nil}, 
    {a_term, nil, external, hs.layout.maximized, nil, nil},
    {a_pyide, nil, external, hs.layout.maximized, nil, nil},
    {a_goland, nil, external, hs.layout.maximized, nil, nil},
    {a_clion, nil, external, hs.layout.maximized, nil, nil},
    {a_sublime, nil, external, hs.geometry.rect(0.15, 0, 0.85, 1), nil, nil},
    }
end

-- screen watcher 
function mon_change()
    print("monitor list")
    local count = 0
    local cur_ext = ''
    local have_lcd = false
    for k,v in pairs(hs.screen.allScreens()) do 
        print(k, v:name())
        count = count + 1
        if v:name() == dell then
            cur_ext = dell
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
    else
        hs.alert.show("Unknown Monitor Layout")
    end
end

-- enable this to switch layouts automatically when monitors change
-- but i've seen some weirdness where it fires even when they haven't changed
-- leaving manual with keystroke below for now
-- hs.screen.watcher.new(mon_change):start()

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "K", function()
    mon_change()
end)


-- application hotkeys
for key, title in pairs(appkeys) do 
    -- three key version
    hs.hotkey.bind({"cmd","alt"}, key, function()
    print('starting application.get: ' .. title)
    local app = hs.application.find(title,true,true)
    if app then 
        print(app)
        app:activate()
    else
        print('starting window.get: ' .. title)
        local win = hs.window.find(title)
        if win then 
            win:focus()
        end
    end
    end)
    -- one key version on numpad
    hs.hotkey.bind({}, "pad" .. key, function()
    print('starting application.get: ' .. title)
    local app = hs.application.find(title,true,true)
    if app then 
        print(app)
        app:activate()
    else
        print('starting window.get: ' .. title)
        local win = hs.window.find(title)
        if win then 
            win:focus()
        end
    end
    end)
end

-- maximize active window
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M", function()
  local win = hs.window.focusedWindow()
  win:maximize(f)
end)

-- left active window
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "L", function()
  local win = hs.window.focusedWindow()
  win:moveToUnit(hs.layout.left50)
end)

-- right active window
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  local win = hs.window.focusedWindow()
  win:moveToUnit(hs.layout.right50)
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

-- config autoreload
function reload_config(files)
    hs.reload() 
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()

-- set up your instance(s)
expose = hs.expose.new(nil,{showThumbnails=true}) -- default windowfilter, no thumbnails
--expose_app = hs.expose.new(nil,{onlyActiveApplication=true}) -- show windows for the current application
--expose_space = hs.expose.new(nil,{includeOtherSpaces=false}) -- only windows in the current Mission Control Space
--expose_browsers = hs.expose.new{'Safari','Google Chrome'} -- specialized expose using a custom windowfilter
-- for your dozens of browser windows :)


