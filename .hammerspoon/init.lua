local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"
local appfinder = require "mjolnir.cmsj.appfinder"

local appkeys = {}
appkeys["1"] = "Google Chrome"
appkeys["3"] = "Slack"
appkeys["4"] = "iTerm"
appkeys["5"] = "PyCharm"
appkeys["6"] = "MacVim"
appkeys["7"] = "Textual"

-- application hotkeys
for key, title in pairs(appkeys) do 
    -- three key version
    hotkey.bind({"cmd","alt"}, key, function()
    local app = appfinder.app_from_name(title)
    if app then 
        app:activate()
    end
    end)
    -- one key version on numpad
    hotkey.bind({}, "pad" .. key, function()
    local app = appfinder.app_from_name(title)
    if app then 
        app:activate()
    end
    end)
end

-- maximize active window
hotkey.bind({"cmd", "alt", "ctrl"}, "M", function()
  local win = window.focusedwindow()
  win:maximize(f)
end)
