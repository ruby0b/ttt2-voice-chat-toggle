AddCSLuaFile()

local cv_auto_enable = CreateConVar("voice_toggle_auto_enable", 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Automatically enable voice chat for players when they join.")
local cv_hide_panels = CreateConVar("voice_toggle_hide_panels", 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Hide the voice panels in the top-left corner that show who else is talking.")
local cv_show_dead = CreateConVar("voice_toggle_show_dead", 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "When spectating, show voice panels for fellow dead players.")

if CLIENT then
    local sandbox_is_speaking
    local function voice_enable()
        if TTT2 then
            if not VOICE.CanSpeak() or not VOICE.CanEnable() then return false end
            VOICE.isTeam = false
        else
            if not GetGlobalBool("sv_voiceenable", true) then return false end
            sandbox_is_speaking = true
        end
        permissions.EnableVoiceChat(true)
        return true
    end
    local function voice_disable()
        if not TTT2 then sandbox_is_speaking = false end
        permissions.EnableVoiceChat(false)
        return true
    end
    local function voice_toggle()
        if (TTT2 and not VOICE.IsSpeaking()) or (not TTT2 and not sandbox_is_speaking) then
            return voice_enable()
        else
            return voice_disable()
        end
    end

    hook.Add("InitPostEntity", "voice_toggle/AutoEnableVoiceChat",
        function() if cv_auto_enable:GetBool() then voice_enable() end end)

    concommand.Add("voice_toggle", voice_toggle, nil, "Toggle Global Voice Chat")

    hook.Add("TTT2Initialize", "voice_toggle/TTT2Initialize", function()
        -- key binding for toggling voice chat
        bind.Register(
            "voice_toggle",
            voice_toggle,
            function() return true end,
            "header_bindings_ttt2",
            "Toggle Global Voice Chat",
            KEY_H
        )

        -- disable top-left voice panels that show who else is talking
        local old_PlayerStartVoice = GAMEMODE.PlayerStartVoice
        function GAMEMODE:PlayerStartVoice(ply)
            old_PlayerStartVoice(self, ply)

            if not cv_hide_panels:GetBool() then return end

            local client = LocalPlayer()
            if not IsValid(g_VoicePanelList) or not IsValid(ply) or not IsValid(client) then return end

            -- show dead players' voice panels when spectating
            if cv_show_dead:GetBool() and not client:Alive() and not ply:Alive() then return end

            -- get the newly created voice panel to hide it
            local new_panel_index = g_VoicePanelList:ChildCount() - 1
            local pnl = g_VoicePanelList:GetChild(new_panel_index)
            if pnl.ply ~= client then
                -- immediately hide and delete all other players' panels
                pnl:SetAlpha(0)
                pnl:Remove()
            end
        end
    end)
end
