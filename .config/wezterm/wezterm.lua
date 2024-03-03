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
    font_size = 11,
    color_scheme = "Catppuccin Mocha",
    use_fancy_tab_bar = true,
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    warn_about_missing_glyphs = true,
    keys = {
	{key="t", mods="CTRL|SUPER|ALT", action=act.CloseCurrentTab{confirm = true}},
        {key="1", mods="CTRL|SUPER", action=act{ActivateTab=0}},
        {key="2", mods="CTRL|SUPER", action=act{ActivateTab=1}},
        {key="3", mods="CTRL|SUPER", action=act{ActivateTab=2}},
        {key="4", mods="CTRL|SUPER", action=act{ActivateTab=3}},
        {key="5", mods="CTRL|SUPER", action=act{ActivateTab=4}},
        {key="6", mods="CTRL|SUPER", action=act{ActivateTab=5}},
        {key="7", mods="CTRL|SUPER", action=act{ActivateTab=6}},
        {key="8", mods="CTRL|SUPER", action=act{ActivateTab=7}},
        {key="9", mods="CTRL|SUPER", action=act{ActivateTab=8}},
        {key="0", mods="CTRL|SUPER", action=act{ActivateTab=9}},
}
}
