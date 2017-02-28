-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Plugin library
local lain = require("lain")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.getdir("config") .. "/themes/default/theme.lua")

terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts =
{
    lain.layout.termfair.center,
    awful.layout.suit.fair,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.floating,
}
-- }}}
-- TODO What?
local function client_menu_toggle_fn()
    local instance = nil
    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

--
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wallpaper
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end
screen.connect_signal("property::geometry", set_wallpaper)


-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

spacebox = wibox.widget.textbox()
spacebox:set_text(" | ")

mybattery=lain.widget.bat({
    settings = function()
        batterystring=""
        if bat_now.status=="Discharging" then
            batterystring="\226\150\188"
        else if bat_now.status=="Charging" then
            batterystring="\226\150\178"
        end
    end
    batterystring= batterystring .."  ".. bat_now.perc .. "%, " .. bat_now.time
    widget:set_markup(batterystring)
end
})

cpu=lain.widget.cpu({
    settings = function()
        widget:set_markup("CPU: " .. cpu_now.usage)
    end
})

lain.widget.calendar({
    attach_to = {mytextclock},
    followtag=true
})

fsusage=lain.widget.fs({
    settings = function()
        widget:set_markup(fs_now.used .."% of " .. fs_now.size_gb .. " GB")
    end
})

mpdwidget = lain.widget.mpd({
    host="10.0.0.30",
    settings= function()
        widget:set_markup("Now playing: " .. mpd_now.title .. " by " .. mpd_now.artist)
    end
})

--TODO
volumewidget = lain.widget.pulsebar({
    settings = function()
        vlevel = volume_now.left .. "-" .. volume_now.right .. "%"
        if volume_now.muted == "yes" then
            vlevel = vlevel .. " M"
        end

        --widget:set_markup(lain.util.markup("#7493d2", vlevel))
    end
})

weather = lain.widget.weather({
city_id = 2643743, -- placeholder (London)
settings = function()
units = math.floor(weather_now["main"]["temp"])
widget:set_markup(" " .. units .. " ")
end
})
myweather = lain.widget.weather({
city_id=2801117, --Brasschaat
--weather_na_markup="No Forecast Available",
followtag=true,
 --   settings=function()
  --  descr = weather_now["weather"][1]["description"]:lower()
  --  units = math.floor(weather_now["main"]["temp"])
  --  widget:set_markup("Today's weather: " .. descr .. " @ " .. units .. "°C ")
  --  end
})

--}}}

-- @DOC_FOR_EACH_SCREEN@
-- TODO check if all works
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    quotes={
        {"Smile,", "Just", "To", "Oppose", "Those", "Who", "Defy", "You"},
        {"Aut", "Viam", "Inveniam", "Aut", "Faciam"},
        {"Don't", "Forget:", "You're", "Here", "Forever"},
        {"Pie", "Jesu", "Domine,", "Dona", "Eis", "Requiem"},
        {"Tempus", "Fugit,", "Keeper.", "You", "Have", "Been", "Warned"},
        {"Ave", "Imperator,", "Morituri", "Te", "Salutant"},
        {"Entia", "Non", "Sunt", "Multiplicanda", "Praeter", "Necessitatem"}
    }
    math.randomseed(os.time())
    q=quotes[math.random(#quotes)]
    awful.tag(
    q,
    s,
    awful.layout.layouts[1]
    )

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- @DOC_WIBAR@
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- @DOC_SETUP_WIDGETS@
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        s.mytaglist,
        s.mypromptbox,
        spacebox,
    },
    {
    align  = "center",
    mpdwidget, -- Middle widget
     layout=wibox.layout.flex.horizontal,
},
    { -- Right widgets
    layout = wibox.layout.fixed.horizontal,
    spacebox,
--    myweather,
-- 00   weather,
    spacebox,
    --volumewidget,
    spacebox,
    --fsusage,
    spacebox,
    cpu,
    spacebox,
    mybattery,
    spacebox,
    mytextclock,
    spacebox,
    wibox.widget.systray(),
},
}
end)

-- {{{ Key bindings
-- -- @DOC_GLOBAL_KEYBINDINGS@
globalkeys = awful.util.table.join(

awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
{description = "go back", group = "tag"}),
awful.key({ modkey,           }, "j",
function ()
    awful.client.focus.byidx( 1)
end,
{description = "focus next by index", group = "client"}
),
awful.key({ modkey,           }, "k",
function ()
    awful.client.focus.byidx(-1)
end,
{description = "focus previous by index", group = "client"}
),
awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
{description = "show main menu", group = "awesome"}),

-- Layout manipulation
awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
{description = "swap with next client by index", group = "client"}),
awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
{description = "swap with previous client by index", group = "client"}),
awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
{description = "focus the next screen", group = "screen"}),
awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
{description = "focus the previous screen", group = "screen"}),
awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
{description = "jump to urgent client", group = "client"}),
awful.key({ modkey,           }, "Tab",
function ()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end,
{description = "go back", group = "client"}),

-- Standard program
awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
{description = "open a terminal", group = "launcher"}),
awful.key({ modkey, "Control" }, "r", awesome.restart,
{description = "reload awesome", group = "awesome"}),
awful.key({ modkey, "Shift"   }, "c", awesome.quit,
{description = "quit awesome", group = "awesome"}),

awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
{description = "increase master width factor", group = "layout"}),
awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
{description = "decrease master width factor", group = "layout"}),
awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
{description = "increase the number of master clients", group = "layout"}),
awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
{description = "decrease the number of master clients", group = "layout"}),
awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
{description = "increase the number of columns", group = "layout"}),
awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
{description = "decrease the number of columns", group = "layout"}),
awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
{description = "select next", group = "layout"}),
awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
{description = "select previous", group = "layout"}),


-- Prompt
awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
{description = "run prompt", group = "launcher"}),

awful.key({ modkey }, "x",
function ()
    awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
end,
{description = "lua execute prompt", group = "awesome"}),
-- Menubar
awful.key({ modkey }, "d", function() menubar.show() end,
{description = "show the menubar", group = "launcher"})
)

-- @DOC_CLIENT_KEYBINDINGS@
clientkeys = awful.util.table.join(
awful.key({ modkey,           }, "f",
function (c)
    c.fullscreen = not c.fullscreen
    c:raise()
end,
{description = "toggle fullscreen", group = "client"}),
awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
{description = "close", group = "client"}),
awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
{description = "toggle floating", group = "client"}),
awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
{description = "move to master", group = "client"}),
awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
{description = "move to screen", group = "client"}),
awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
{description = "toggle keep on top", group = "client"})
)

-- @DOC_NUMBER_KEYBINDINGS@
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
    function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            tag:view_only()
        end
    end,
    {description = "view tag #"..i, group = "tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
    function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end,
    {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end,
    {description = "move focused client to tag #"..i, group = "tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        end
    end,
    {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- @DOC_CLIENT_BUTTONS@
clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}

-- }}}

-- {{{ Rules
-- -- Rules to apply to new clients (through the "manage" signal).
-- -- @DOC_RULES@
awful.rules.rules = {
    -- @DOC_GLOBAL_RULE@
    -- All clients will match this rule.
    { rule = { },
    properties = { border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    focus = awful.client.focus.filter,
    raise = true,
    keys = clientkeys,
    buttons = clientbuttons,
    screen = awful.screen.preferred,
    placement = awful.placement.no_overlap+awful.placement.no_offscreen
}
                                                                            },

                                                                            -- @DOC_FLOATING_RULE@
                                                                            -- Floating clients.
                                                                            { rule_any = {
                                                                                instance = {
                                                                                    "DTA",  -- Firefox addon DownThemAll.
                                                                                    "copyq",  -- Includes session name in class.
                                                                                },
                                                                                class = {
                                                                                    "veromix",
                                                                                    "xtightvncviewer"},

                                                                                    name = {
                                                                                        "Event Tester",  -- xev.
                                                                                    },
                                                                                    role = {
                                                                                        "AlarmWindow",  -- Thunderbird's calendar.
                                                                                        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
                                                                                    }
                                                                                }, properties = { floating = true }},

                                                                                -- @DOC_DIALOG_RULE@
                                                                                -- Add titlebars to normal clients and dialogs
                                                                                { rule_any = {type = { "normal", "dialog" }
                                                                            }, properties = { titlebars_enabled = true }
                                                                        },

                                                                    }
                                                                    -- }}}

                                                                    -- {{{ Signals
                                                                    -- Signal function to execute when a new client appears.
                                                                    -- @DOC_MANAGE_HOOK@
                                                                    client.connect_signal("manage", function (c)
                                                                        -- Set the windows at the slave,
                                                                        -- i.e. put it at the end of others instead of setting it master.
                                                                        -- if not awesome.startup then awful.client.setslave(c) end

                                                                        if awesome.startup and
                                                                            not c.size_hints.user_position
                                                                            and not c.size_hints.program_position then
                                                                            -- Prevent clients from being unreachable after screen count changes.
                                                                            awful.placement.no_offscreen(c)
                                                                        end
                                                                    end)

                                                                    -- @DOC_TITLEBARS@
                                                                    -- Add a titlebar if titlebars_enabled is set to true in the rules.
                                                                    client.connect_signal("request::titlebars", function(c)
                                                                        -- buttons for the titlebar
                                                                        local buttons = awful.util.table.join(
                                                                        awful.button({ }, 1, function()
                                                                            client.focus = c
                                                                            c:raise()
                                                                            awful.mouse.client.move(c)
                                                                        end),
                                                                        awful.button({ }, 3, function()
                                                                            client.focus = c
                                                                            c:raise()
                                                                            awful.mouse.client.resize(c)
                                                                        end)
                                                                        )

                                                                        awful.titlebar(c) : setup {
                                                                            { -- Left

                                                                            layout  = wibox.layout.fixed.horizontal
                                                                        },
                                                                        { -- Middle
                                                                        { -- Title
                                                                        align  = "center",
                                                                        widget = awful.titlebar.widget.titlewidget(c)
                                                                    },
                                                                    layout  = wibox.layout.flex.horizontal
                                                                },
                                                                { -- Right
                                                                layout  = wibox.layout.fixed.horizontal
                                                            },
                                                            layout = wibox.layout.align.horizontal
                                                        }
                                                    end)

                                                    -- Enable sloppy focus, so that focus follows mouse.
                                                    client.connect_signal("mouse::enter", function(c)
                                                        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                                                            and awful.client.focus.filter(c) then
                                                            client.focus = c
                                                        end
                                                    end)

                                                    -- @DOC_BORDER@
                                                    client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
                                                    client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
                                                    -- }}}

                                                    function run_once(prg,arg_string,pname,screen)
                                                        if not prg then
                                                            do return nil end
                                                        end

                                                        if not pname then
                                                            pname = prg
                                                        end

                                                        if not arg_string then 
                                                            awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
                                                        else
                                                            awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
                                                        end
                                                    end

                                                    run_once("chromium",nil,nil,1)
