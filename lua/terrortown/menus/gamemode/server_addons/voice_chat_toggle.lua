CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "Voice Chat Toggle"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "General Settings")

    form:MakeCheckBox({
        serverConvar = "voice_toggle_auto_enable",
        label = "Automatically enable voice chat for players when they join."
    })
end
