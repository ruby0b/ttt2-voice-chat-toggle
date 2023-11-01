AddCSLuaFile()

local cv_auto_enable = CreateConVar("voice_toggle_auto_enable", 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Automatically enable voice chat players when they join.")
local cv_hide_panels = CreateConVar("voice_toggle_hide_panels", 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Hide the voice panels in the top-left corner that show who else is talking.")

if CLIENT then
    local function voice_enable()
        if not VOICE.CanSpeak() then return false end
        local client = LocalPlayer()
        if hook.Run("TTT2CanUseVoiceChat", client, false) == false then
            return false
        end
        VOICE.isTeam = false
        permissions.EnableVoiceChat(true)
        return true
    end
    local function voice_disable()
        permissions.EnableVoiceChat(false)
        return true
    end
    local function voice_toggle()
        if not VOICE.IsSpeaking() then
            return voice_enable()
        else
            return voice_disable()
        end
    end

    hook.Add("InitPostEntity", "proximity_voice/AutoEnableVoiceChat",
        function() if cv_auto_enable:GetBool() then voice_enable() end end)

    concommand.Add("voice_toggle", function(_ply, _cmd, _args, _argStr)
        voice_toggle()
    end, nil, "Toggle Global Voice Chat")

    hook.Add("TTT2Initialize", "proximity_voice/TTT2Initialize", function()
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

            -- get the newly created voice panel
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
