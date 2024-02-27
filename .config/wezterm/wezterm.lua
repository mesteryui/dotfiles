-- Pull in the wezterm API
local wezterm = require 'wezterm'

local act = wezterm.action

return {
enable_wayland = true,
    window_background_opacity = 0.90,
    font = wezterm.font({
        family="JetBrainsMono Nerd Font Mono",
        harfbuzz_features={"calt=1", "clig=1", "liga=1"}
    }),
    font_size = 12,
    color_scheme = "Catppuccin Mocha",
    use_fancy_tab_bar = false,
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    warn_about_missing_glyphs = false,


}
