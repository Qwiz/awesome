-----------------------
-- AwesomeWM widgets --
--    version 3.5    --
--   <tdy@gmx.com>   --
-----------------------

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local naughty = require("naughty")

-- local personal = require("personal")

local net_if = 'wlp2s0'

graphwidth  = 50
graphheight = 14
pctwidth    = 40
netwidth    = 50
mpdwidth    = 365

-- {{{ Spacers
space = wibox.widget.textbox()
space:set_text(" ")

comma = wibox.widget.textbox()
comma:set_markup(",")

pipe = wibox.widget.textbox()
pipe:set_markup("<span color='" .. beautiful.bg_em .. "'>|</span>")

tab = wibox.widget.textbox()
tab:set_text("    ")

at = wibox.widget.textbox()
at:set_text(" @ ")

volspace = wibox.widget.textbox()
volspace:set_text(" ")
-- }}}

-- {{{ Processor
-- Cache
vicious.cache(vicious.widgets.cpu)
vicious.cache(vicious.widgets.cpuinf)

-- Cpu icon
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)

-- Cpu graph
cpugraph = awful.widget.graph()
cpugraph:set_width(graphwidth):set_height(graphheight)
cpugraph:set_border_color(nil)
cpugraph:set_border_color(beautiful.bg_widget)
cpugraph:set_background_color(beautiful.bg_widget)
cpugraph:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, beautiful.fg_widget },
    { 0.25, beautiful.fg_center_widget },
    { 1, beautiful.fg_end_widget } } })
vicious.register(cpugraph, vicious.widgets.cpu, "$2", 2)

-- Cpu usage
cpuusage = wibox.widget.textbox()
vicious.register(cpuusage, vicious.widgets.cpu, "$2%", 2)

-- Cpu freq
cpufreq = wibox.widget.textbox()
vicious.register(cpufreq, vicious.widgets.cpuinf,
  function(widget, args)
    return string.format("%1.1fGHz", args["{cpu0 ghz}"])
  end, 3000)

-- }}}

-- {{{ Memory
-- Cache
vicious.cache(vicious.widgets.mem)

-- RAM Icon
ramicon = wibox.widget.imagebox()
ramicon:set_image(beautiful.widget_ram)

-- RAM used
memused = wibox.widget.textbox()
vicious.register(memused, vicious.widgets.mem,
  "$2MB", 5)

-- RAM bar
membar = awful.widget.progressbar()
membar:set_vertical(false):set_width(graphwidth):set_height(graphheight)
membar:set_ticks(false):set_ticks_size(2)
membar:set_border_color(nil)
membar:set_background_color(beautiful.bg_widget)
membar:set_color({
  type = "linear",
  from = { 0, 0 },
  to = { graphwidth, 0 },
  stops = {
    { 0, beautiful.fg_widget },
    { 0.25, beautiful.fg_center_widget },
    { 1, beautiful.fg_end_widget } } })
vicious.register(membar, vicious.widgets.mem, "$1", 13)

-- RAM %
mempct = wibox.widget.textbox()
mempct.width = pctwidth
vicious.register(mempct, vicious.widgets.mem, "$1%", 5)

-- {{{ Network
-- Cache
vicious.cache(vicious.widgets.net)

-- TX Icon
txicon = wibox.widget.imagebox()
txicon:set_image(beautiful.widget_up)

-- TX graph
txgraph = awful.widget.graph()
txgraph:set_width(graphwidth):set_height(graphheight)
txgraph:set_border_color(nil)
txgraph:set_background_color(beautiful.bg_widget)
txgraph:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, beautiful.fg_widget },
    { 0.25, beautiful.fg_center_widget },
    { 1, beautiful.fg_end_widget } } })
vicious.register(txgraph, vicious.widgets.net, "${" .. net_if .. " up_kb}")

-- TX speed
txspeed = wibox.widget.textbox()
txspeed.fit =
  function(box, w, h)
    local w, h = wibox.widget.textbox.fit(box, w, h)
    return math.max(netwidth, w), h
  end
vicious.register(txspeed, vicious.widgets.net, "${" .. net_if .. " up_kb}", 2)

-- RX Icon
rxicon = wibox.widget.imagebox()
rxicon:set_image(beautiful.widget_down)

-- RX graph
rxgraph = awful.widget.graph()
rxgraph:set_width(graphwidth):set_height(graphheight)
rxgraph:set_border_color(nil)
rxgraph:set_background_color(beautiful.bg_widget)
rxgraph:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, beautiful.fg_widget },
    { 0.25, beautiful.fg_center_widget },
    { 1, beautiful.fg_end_widget } } })
vicious.register(rxgraph, vicious.widgets.net, "${" .. net_if .. " down_kb}")

-- RX speed
rxspeed = wibox.widget.textbox()
rxspeed.fit =
  function(box, w, h)
    local w, h = wibox.widget.textbox.fit(box, w, h)
    return math.max(netwidth, w), h
  end
vicious.register(rxspeed, vicious.widgets.net, "${" .. net_if .. " down_kb}", 2)
-- }}}

-- {{{ Weather
weather = wibox.widget.textbox()
vicious.register(weather, vicious.widgets.weather,
  "<span color='" .. beautiful.fg_em .. "'>${sky}</span> @ ${tempc}°C on",
  1501, "ULLI")
weather:buttons(awful.util.table.join(awful.button({ }, 1,
  function() vicious.force({ weather }) end)))
-- }}}

-- {{{ ESSID

-- Icon
essidicon = wibox.widget.imagebox()
essidicon:set_image(beautiful.widget_wifi)

-- AP Name
essidwidget = wibox.widget.textbox()
vicious.register(essidwidget, vicious.widgets.wifi, "<span color='" .. beautiful.fg_em .. "'>${ssid}</span> @${sign}", 3, net_if)

-- }}}

-- {{{ Pacman
-- Icon
pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_pac)

-- Upgrades
pacwidget = wibox.widget.textbox()
vicious.register(pacwidget, vicious.widgets.pkg,
  function(widget, args)
    if args[1] > 0 then
      pacicon:set_image(beautiful.widget_pacnew)
    else
      pacicon:set_image(beautiful.widget_pac)
    end

    return args[1]
  end, 1801, "Arch C") -- Arch S for ignorepkg

-- Buttons
function popup_pac()
  local pac_updates = ""
  local f = io.popen("yaourt -Qu --aur")
  if f then
    pac_updates = f:read("*a"):match(".*/(.*)-.*\n$")
  end
  f:close()

  if not pac_updates then pac_updates = "System is up to date" end

  naughty.notify { text = pac_updates }
end
pacwidget:buttons(awful.util.table.join(awful.button({ }, 1, popup_pac)))
pacicon:buttons(pacwidget:buttons())
-- }}}

-- {{{ Volume
-- Cache
vicious.cache(vicious.widgets.volume)

-- Icon
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)

-- Volume Widget

volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume, " $1% ", 1, "Master")

volwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer -q set Master toggle", false) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q set Master 5%+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q set Master 5%-", false) end)
))
volicon:buttons(volwidget:buttons())

-- {{{
-- Keyboard layout widget
kbdwidget = wibox.widget.textbox("Eng")
kbdwidget.border_width = 1
kbdwidget.border_color = beautiful.fg_normal
kbdwidget:set_text("Eng")

kbdstrings = {[0] = "Eng", [1] = "Рус"}
dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", function(...)
    local data = {...}
    local layout = data[2]
    kbdwidget:set_markup(kbdstrings[layout])
end
)
-- }}}

-- {{{ Battery
-- Battery attributes
local bat_state  = ""
local bat_charge = 0
local bat_time   = 0
local blink      = true

-- Icon
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batfull)

-- Charge %
batpct = wibox.widget.textbox()
vicious.register(batpct, vicious.widgets.bat,
  function(widget, args)
    bat_state  = args[1]
    bat_charge = args[2]
    bat_time   = args[3]

    if args[1] == "-" then
      if bat_charge > 70 then
        baticon:set_image(beautiful.widget_batfull)
      elseif bat_charge > 30 then
        baticon:set_image(beautiful.widget_batmed)
      elseif bat_charge > 10 then
        baticon:set_image(beautiful.widget_batlow)
      else
        baticon:set_image(beautiful.widget_batempty)
      end
    else
      baticon:set_image(beautiful.widget_ac)
      if args[1] == "+" then
        blink = not blink
        if blink then
          baticon:set_image(beautiful.widget_acblink)
        end
      end
    end

    return args[2] .. "%"
  end, nil, "CMB1")

-- Buttons
function popup_bat()
  local state = ""
  if bat_state == "↯" then
    state = "Full"
  elseif bat_state == "↯" then
    state = "Charged"
  elseif bat_state == "+" then
    state = "Charging"
  elseif bat_state == "-" then
    state = "Discharging"
  elseif bat_state == "⌁" then
    state = "Not charging"
  else
    state = "Unknown"
  end

  naughty.notify { text = "Charge : " .. bat_charge .. "%\nState  : " .. state ..
    " (" .. bat_time .. ")", timeout = 5, hover_timeout = 0.5 }
end
batpct:buttons(awful.util.table.join(awful.button({ }, 1, popup_bat)))
baticon:buttons(batpct:buttons())
-- }}}


-- {{{ Multiple displays configuration

-- Build available choices
local function menu()
  local menu = {}

  menu[1] = { 
      'Work', 
      'xrandr --output LVDS1 --auto --rotate normal --pos 0x0 --output HDMI1 --auto --rotate left --right-of LVDS1',
      '/usr/share/icons/matefaenza/devices/32/display.png' 
  }
  menu[2] = {
      'Home',
      'xrandr --output LVDS1 --auto --rotate normal --pos 0x0 --output VGA1 --auto --rotate normal --right-of LVDS1',
      '/usr/share/icons/matefaenza/devices/32/display.png' 
  }
  menu[3] = {
      'Default',
      'xrandr --output LVDS1 --auto --rotate normal --pos 0x0 --output VGA1 --off --output HDMI1 --off',
      '/usr/share/icons/matefaenza/devices/32/display.png' 
  }
   return menu
end

-- Display xrandr notifications from choices
local state = { iterator = nil, cid = nil }
function displays()

   -- Build the list of choices
   if not state.iterator then
      state.iterator = awful.util.table.iterate(menu(),
          function() return true end)
   end

   -- Select one and display the appropriate notification
   local next  = state.iterator()
   local label, action, icon
   if not next then
      label, icon = "Keep the current configuration", "/usr/share/icons/matefaenza/devices/32/display.png"
      state.iterator = nil
   else
      label, action, icon = unpack(next)
   end
   state.cid = naughty.notify({ text = label,
        icon = icon,
        timeout = 4,
        screen = mouse.screen, -- Important, not all screens may be visible
        font = "Ubuntu Mono 12",
        replaces_id = state.cid }).id

   awful.util.spawn(action, false)
end

-- }}}