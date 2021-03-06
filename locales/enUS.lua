local L = LibStub("AceLocale-3.0"):NewLocale("VaultMinimapButton", "enUS", true, debug)
if L then
    L["ADDONNAME"] = "VaultMinimapButton"

    L["CLICK_TO_OPEN"] = "|cFFFFFFFFclick to open Great Vault|r"

    L["MYTHICPLUS"] = "Mythic+"
    L["MYTHICPLUS_REACHED"] = "|cFF006600%d|r (|cFFFFFFFF+%d|r)"
    L["MYTHICPLUS_NOT_REACHED"] = "%s (|cFFFF9900%d|r/|cFFFFFFFF%d|r)"
    L["MYTHICPLUS_NEXT_REWARD_ESTIMATE"] = "|cFFFF9900%d|r (|cFFFFFFFF+%d|r)"

    L["RAID"] = "Raid"
    L["RAID_REACHED"] = "|cFF006600%d|r (|cFFFFFFFF+%d|r)"
    L["RAID_NOT_REACHED"] = "%s (|cFFFF9900%d|r/|cFFFFFFFF%d|r)"
    L["RAID_NEXT_REWARD_ESTIMATE"] = "|cFFFF99000|r (|cFFFFFFFFHC|r)"

    L["RANKEDPVP"] = "PvP"
    L["RANKEDPVP_LOOT"] = "PvP (|cFFFFFFFF%d|r)"
    L["RANKEDPVP_REACHED"] = "|cFF006600%d|r"
    L["RANKEDPVP_NOT_REACHED"] = "|cFFFF9900%d|r estimated"
end
