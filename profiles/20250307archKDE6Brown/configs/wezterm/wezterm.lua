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
config.color_scheme = 'srsBlue'

-- Time status bar
wezterm.on('update-right-status', function(window, pane)
local date = wezterm.strftime '%Y-%m-%d %H:%M:%S'

-- Make it italic and underlined
window:set_right_status(wezterm.format {
    { Text = '- ' .. date .. ' - '},
})
end)

-- colors
local fg  = '#c3c4c4' -- foreground
local bg  = '#1e1e1e' -- background

config.colors = {
    -- general colors
    foreground = fg,
    background = bg,

    -- cursor
    cursor_bg = fg,
    cursor_border = bg,
}


config.color_schemes = {
    ['srsBlue'] = {
        -- general colors
        foreground = fg,
        background = bg,

        -- selection
        selection_fg = '#090b16',
        selection_bg = '#024E94',

        -- cursor
        cursor_bg = fg,
        cursor_border = bg,

        ansi = {
            '#090b16',
            '#032562',
            '#010B28',-- low%
            '#645e63',
            '#024E94',
            '#318495',
            '#7b8182',
            '#8d8f98',
        },
        brights = {
            '#595b6c',
            '#035B9E',-- high%
            '#2971AE',-- : and categories
            '#867E85',-- ~ and mid%
            '#0EABCD',-- $ and time
            '#42B0C7',
            '#A5ACAE',
            '#c1c2c4',-- headlines
        },

        --tab bar colors
        tab_bar = {
            background = '#032562',
            active_tab = {
                bg_color = '#010B28',
                fg_color = '#A5ACAE',
                intensity = 'Bold',
                underline = 'None',
                italic = false,
                strikethrough = false,
            },
            inactive_tab = {
                bg_color = '#024E94',
                fg_color = '#A5ACAE',
            },
            inactive_tab_hover = {
                bg_color = '#035B9E',
                fg_color = '#090b16',
                italic = false,
            },
            new_tab = {
                bg_color = '#024E94',
                fg_color = '#A5ACAE',
            },
            new_tab_hover = {
                bg_color = '#035B9E',
                fg_color = '#090b16',
                italic = true,
            },
        },
    },
    ['srsGreen'] = {
        -- general colors
        foreground = '#c3c4c4',
            background = '#121413',

            -- selection
            selection_fg = '#4b5a4c',
            selection_bg = '#657c5b',

            -- cursor
            cursor_bg = '#c3c4c4',
            cursor_border = '#121413',

            ansi = {
                '#121413',
                '#4b5a4c',
                '#526851',-- low%
                '#577354',
                '#5d9151',
                '#657c5b',
                '#5d6e61',
                '#8f998f',
            },
            brights = {
                '#5a6f64',
                '#657966',-- high%
                '#6E8B6D',-- : and categories
                '#759A71',-- ~ and mid%
                '#7DC26C',-- $ and time
                '#87A67A',
                '#7D9382',
                '#c3c4c4',-- headlines
            },

            --tab bar colors
            tab_bar = {
                background = '#4b5a4c',
                active_tab = {
                    bg_color = '#526851',
                    fg_color = '#7D9382',
                    intensity = 'Bold',
                    underline = 'None',
                    italic = false,
                    strikethrough = false,
                },
                inactive_tab = {
                    bg_color = '#5d9151',
                    fg_color = '#7D9382',
                },
                inactive_tab_hover = {
                    bg_color = '#657966',
                    fg_color = '#121413',
                    italic = false,
                },
                new_tab = {
                    bg_color = '#5d9151',
                    fg_color = '#7D9382',
                },
                new_tab_hover = {
                    bg_color = '#657966',
                    fg_color = '#121413',
                    italic = true,
                },
            },
    },
    ['srsblueprint'] = {
        background = 'blue',
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
