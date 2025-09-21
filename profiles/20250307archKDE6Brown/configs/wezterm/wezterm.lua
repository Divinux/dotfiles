-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- This will hold the configuration.
local config = wezterm.config_builder()

-- Window style
--config.enable_tab_bar = false
--config.hide_tab_bar_if_only_one_tab = true
config.prefer_to_spawn_tabs = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
--config.window_background_opacity = 0.6
--config.kde_window_background_blur = true

-- Cursor
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = 0
config.cursor_blink_ease_in = 'Linear'
config.cursor_blink_ease_out = 'Linear'

-- Initial geometry for new windows:
config.initial_cols = 130
config.initial_rows = 31

-- Font size and color scheme.
config.font_size = 10
config.font = wezterm.font 'Hack'
config.color_scheme = 'Black Metal (Burzum) (base16)'

-- Time status bar
wezterm.on('update-right-status', function(window, pane)
local date = wezterm.strftime '%Y-%m-%d %H:%M:%S'

-- Make it italic and underlined
window:set_right_status(wezterm.format {
    { Text = '- ' .. date .. ' - '},
})
end)

-- colors
local color1  = '#c3c4c4' -- foreground
local color2  = '#1e1e1e' -- background
local color3  = '#010B28'
local color4  = '#032562'
local color5  = '#024E94'
local color6  = '#D9DFD3'
local color7  = '#1099BF'
local color8  = '#7CC9D3'
local color9  = '#456178'
local color10  = '#7D99A0'

config.colors = {
    -- general colors
    foreground = color1,
    background = color2,

    -- selection
    selection_fg = color1,
    selection_bg = color5,
    -- cursor
    cursor_bg = color1,
    cursor_border = color2,

    ansi = {
        color3,
        color4,
        color5,-- low%
        color6,
        color7,
        color8,
        color9,
        color10,
    },
    brights = {
        color3,
        color4,-- high%
        color5,-- : and categories
        color6,-- ~ and mid%
        color7,-- $ and time
        color8,
        color9,
        color10,-- headlines
    },

    --tab bar colors
    tab_bar = {
        background = color4,
        active_tab = {
            bg_color = color3,
            fg_color = color1,
            intensity = 'Bold',
            underline = 'None',
            italic = false,
            strikethrough = false,
        },
        inactive_tab = {
            bg_color = color3,
            fg_color = color1,
        },
        inactive_tab_hover = {
            bg_color = color10,
            fg_color = color3,
            italic = false,
        },
        new_tab = {
            bg_color = color5,
            fg_color = color1,
        },
        new_tab_hover = {
            bg_color = color10,
            fg_color = color2,
            italic = true,
        },
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
