[''] = {
    -- general colors
    foreground = '{{colors.on_surface_variant.default.hex}}',
    background = '{{colors.background.default.hex}}',

    -- selection
    selection_fg = '{{colors.on_secondary.default.hex}}',
    selection_bg = '{{colors.secondary_fixed_dim.default.hex}}',

    -- cursor
    cursor_fg = '{{colors.on_secondary.default.hex}}',
    cursor_bg = '{{colors.on_surface.default.hex}}',
    cursor_border = '{{colors.on_surface.default.hex}}',

    -- split
    split = '{{colors.secondary_fixed_dim.default.hex}}',

    ansi = {
        '{{base16.base00.default.hex}}',
        '{{base16.base01.default.hex}}',
        '{{base16.base02.default.hex}}',-- low%
        '{{base16.base03.default.hex}}',
        '{{base16.base04.default.hex}}',
        '{{base16.base05.default.hex}}',
        '{{base16.base06.default.hex}}',
        '{{base16.base07.default.hex}}',
    },
    brights = {
        '{{base16.base08.default.hex}}',
        '{{base16.base09.default.hex}}',-- high%
        '{{base16.base0a.default.hex}}',-- : and categories
        '{{base16.base0b.default.hex}}',-- ~ and mid%
        '{{base16.base0c.default.hex}}',-- $ and time
        '{{base16.base0d.default.hex}}',
        '{{base16.base0e.default.hex}}',
        '{{base16.base0f.default.hex}}',-- headlines
    },

    --tab bar colors
    tab_bar = {
        background = '{{base16.base00.default.hex}}',

        active_tab = {
            bg_color = '{{colors.surface_container.default.hex}}',
            fg_color = '{{colors.on_surface_variant.default.hex}}',
            intensity = 'Bold',
            underline = 'None',
            italic = false,
            strikethrough = false,
        },
        inactive_tab = {
            bg_color = '{{base16.base01.default.hex}}',
            fg_color = '{{colors.on_surface_variant.default.hex}}',
        },
        inactive_tab_hover = {
            bg_color = '{{base16.base05.default.hex}}',
            fg_color = '{{colors.background.default.hex}}',
            italic = false,
        },
        new_tab = {
            bg_color = '{{base16.base01.default.hex}}',
            fg_color = '{{colors.on_surface_variant.default.hex}}',
        },
        new_tab_hover = {
            bg_color = '{{base16.base05.default.hex}}',
            fg_color = '{{colors.background.default.hex}}',
            italic = true,
        },
    },
},
