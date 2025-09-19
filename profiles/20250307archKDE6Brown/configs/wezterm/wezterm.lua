-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Window style
config.enable_tab_bar = false
config.window_background_opacity = 0.95
config.kde_window_background_blur = true

-- Cursor
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = 0
config.cursor_blink_ease_in = 'Linear'
config.cursor_blink_ease_out = 'Linear'

-- Initial geometry for new windows:
config.initial_cols = 135
config.initial_rows = 31

-- Font size and color scheme.
config.font_size = 10
config.font = wezterm.font 'Hack'
config.color_scheme = 'Black Metal (Burzum) (base16)'

-- colors
config.colors = {
    -- general colors
    foreground = '#c3c4c4',
    background = '#1e1e1e',

    -- selection
    selection_fg = 'black',
    selection_bg = '5d9151',
    -- cursor
    cursor_bg = "#ffffff",
    cursor_border = "#1e1e1e",

    -- other unused for reference
    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = '#222222',
    -- The color of the split lines between panes
    split = '#444444',

    ansi = {
        '#121413',
        '#4b5a4c',
        '#526851',
        '#577354',
        '#5d9151',
        '#657c5b',
        '#5d6e61',
        '#8f998f',
    },
    brights = {
        '#5a6f64',
        '#657966',
        '#6e8b6d',
        '#759a71',
        '#7dc26c',
        '#87a67a',
        '#7d9382',
        '#c3c4c4',
    },
}

-- Session config
config.unix_domains = {
    {
        name = 'unix',
    },
}
config.default_gui_startup_args = { 'connect', 'unix' }

-- Auto reset window size whenever the config is (re)loaded
wezterm.on('window-config-reloaded', function(window, pane)
window:perform_action(wezterm.action.ResetFontAndWindowSize, pane)
end)

-- Finally, return the configuration to wezterm:
return config
