-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- Required for mouse bindings
local act = wezterm.action
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

-- Time status bar
wezterm.on('update-right-status', function(window, pane)
local date = wezterm.strftime '%Y-%m-%d %H:%M:%S'

-- Make it italic and underlined
window:set_right_status(wezterm.format {
    { Text = '- ' .. date .. ' - '},
})
end)

-- Font size and color scheme.
config.font_size = 10
config.font = wezterm.font 'Hack'
config.color_scheme = 'srsGray'

-- color overrides
--local fg  = '#c3c4c4' -- foreground
--local bg  = '#1e1e1e' -- background flat gray
local bg  = '#0c0d0f' -- background moon blue

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
        foreground = '#c4c6cf',
        background = '#111318',

        -- selection
        selection_fg = '#090b16',
        selection_bg = '#024E94',

        -- cursor
        cursor_bg = foreground,
        cursor_border = background,

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
        foreground = '#c0c9c0',
        background = '#0f1511',

        -- selection
        selection_fg = '#213528',
        selection_bg = '#b5ccba',

        -- cursor
        cursor_fg = '#213528',
        cursor_bg = '#dfe4dd',
        cursor_border = '#dfe4dd',

        -- split
        split = '#b5ccba',

        ansi = {
            '#2a2d2b',
            '#333a34',
            '#3c463d',-- low%
            '#465346',
            '#4f5f4e',
            '#586c57',
            '#617860',
            '#6b8569',
        },
        brights = {
            '#6a8469',
            '#516452',-- high%
            '#425044',-- : and categories
            '#3a443d',-- ~ and mid%
            '#363d38',-- $ and time
            '#333935',
            '#313733',
            '#303531',-- headlines
        },

        --tab bar colors
        tab_bar = {
            background = '#2a2d2b',

            active_tab = {
                bg_color = '#1c211d',
                fg_color = '#c0c9c0',
                intensity = 'Bold',
                underline = 'None',
                italic = false,
                strikethrough = false,
            },
            inactive_tab = {
                bg_color = '#333a34',
                fg_color = '#c0c9c0',
            },
            inactive_tab_hover = {
                bg_color = '#586c57',
                fg_color = '#0f1511',
                italic = false,
            },
            new_tab = {
                bg_color = '#333a34',
                fg_color = '#c0c9c0',
            },
            new_tab_hover = {
                bg_color = '#586c57',
                fg_color = '#0f1511',
                italic = true,
            },
        },
    },
    ['srsPurple'] = {
        -- general colors
        foreground = '#c3c1c4',
        background = '#120814',

        -- selection
        selection_fg = '#3b0938',
        selection_bg = '#613112',

        -- cursor
        cursor_bg = '#c3c1c4',
        cursor_border = '#120814',

        ansi = {
            '#120814',
            '#3b0938',
            '#510b3b',-- low%
            '#89125D',
            '#652124',
            '#613112',
            '#660d45',
            '#958c97',
        },
        brights = {
            '#66586b',
            '#4F0D4B',-- high%
            '#6D0F4F',-- : and categories
            '#6F0F69',-- ~ and mid%
            '#872C31',-- $ and time
            '#824218',
            '#89125D',
            '#c3c1c4',-- headlines
        },

        --tab bar colors
        tab_bar = {
            background = '#3b0938',
            active_tab = {
                bg_color = '#510b3b',
                fg_color = '#958c97',
                intensity = 'Bold',
                underline = 'None',
                italic = false,
                strikethrough = false,
            },
            inactive_tab = {
                bg_color = '#530b4e',
                fg_color = '#89125D',
            },
            inactive_tab_hover = {
                bg_color = '#4F0D4B',
                fg_color = '#120814',
                italic = false,
            },
            new_tab = {
                bg_color = '#120814',
                fg_color = '#958c97',
            },
            new_tab_hover = {
                bg_color = '#4F0D4B',
                fg_color = '#120814',
                italic = true,
            },
        },
    },
    ['srsGray'] = {
        -- general colors
        foreground = '#c0c1c3',
        background = '#000000',

        -- selection
        selection_fg = '#494846',
        selection_bg = '#63605e',

        -- cursor
        cursor_bg = '#c0c1c3',
        cursor_border = '#06080f',

        ansi = {
            '#06080f',
            '#494846',
            '#45464b',-- low%
            '#535150',
            '#605d5d',
            '#63605e',
            '#506274',
            '#8a8d96',
        },
        brights = {
            '#565969',
            '#62605E',-- high%
            '#5C5E64',-- : and categories
            '#6F6C6B',-- ~ and mid%
            '#817D7C',-- $ and time
            '#84817E',
            '#6B839B',
            '#c0c1c3',-- headlines
        },

        --tab bar colors
        tab_bar = {
            background = '#1e1e1e',
            active_tab = {
                bg_color = '#0c0d0f',
                fg_color = '#c0c1c3',
                intensity = 'Bold',
                underline = 'None',
                italic = false,
                strikethrough = false,
            },
            inactive_tab = {
                bg_color = '#1e1e1e',
                fg_color = '#c0c1c3',
            },
            inactive_tab_hover = {
                bg_color = '#62605E',
                fg_color = '#06080f',
                italic = false,
            },
            new_tab = {
                bg_color = '#1e1e1e',
                fg_color = '#c0c1c3',
            },
            new_tab_hover = {
                bg_color = '#62605E',
                fg_color = '#06080f',
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

-- bind rightclick to paste
config.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
        local has_selection = window:get_selection_text_for_pane(pane) ~= ""
        if has_selection then
            window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
            window:perform_action(act.ClearSelection, pane)
            else
                window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
                end
                end),
    },
}

-- Finally, return the configuration to wezterm:
return config
