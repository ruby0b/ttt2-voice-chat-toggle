CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "Voice Chat Toggle"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "General Settings")

    form:MakeCheckBox({
        serverConvar = "voice_toggle_auto_enable",
        label = "Automatically enable voice chat for players when they join."
    })

    local hide_panels = form:MakeCheckBox({
        serverConvar = "voice_toggle_hide_panels",
        label = "Hide the voice panels that show who else is talking."
    })

    form:MakeCheckBox({
        serverConvar = "voice_toggle_show_panels_spectator",
        label = "Show voice panels for fellow dead players while spectating.",
        master = hide_panels
    })
end
