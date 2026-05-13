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
--local bg  = '#0c0d0f' -- background moon blue

config.colors = {
    -- general colors
    foreground = fg,
    background = bg,

    -- cursor
    cursor_bg = fg,
    cursor_border = bg,
}


config.color_schemes = {
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
