AddCSLuaFile()

local cv_auto_enable = CreateConVar("voice_toggle_auto_enable", 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Automatically enable voice chat for players when they join.")

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
        bind.Register(
            "voice_toggle",
            voice_toggle,
            function() return true end,
            "header_bindings_ttt2",
            "Toggle Global Voice Chat",
            KEY_H
        )
    end)
end
