local VaultMinimapButton = LibStub("AceAddon-3.0"):NewAddon("VaultMinimapButton", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("VaultMinimapButton", true)

local MythicPlusRewards = {
    One = 1,
    Two = 4,
    Three = 10,
}

local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("VaultMinimapButton", {
    type = "data source",
    text = "VaultMinimapButton",
    icon = "Interface\\ICONS\\Inv_legion_chest_KirinTor",
    OnClick = function()
        if button ~= "RightButton" then
            if WeeklyRewardsFrame:IsShown() then
                C_WeeklyRewards.CloseInteraction()
                WeeklyRewardsFrame:Hide()
            else
                WeeklyRewardsFrame:Show()
            end
        end    
    end,
    OnTooltipShow = function(tt)
        local activities = GetActivities()

        tt:SetText(L["ADDONNAME"])
        tt:AddLine(L["CLICK_TO_OPEN"])
        tt:AddLine(" ")

        tt:AddLine(L["MYTHICPLUS"])
        for index, activity in pairs(activities[Enum.WeeklyRewardChestThresholdType.MythicPlus]) do
            tt:AddLine(GetMythicPlusActivityString(activity))
        end
        tt:AddLine(" ")

        tt:AddLine(L["RAID"])
        tt:AddLine(" ")

        pvpHeader, pvpText = GetPvPText(activities[Enum.WeeklyRewardChestThresholdType.RankedPvP])
        tt:AddLine(pvpHeader)
        tt:AddLine(pvpText)
        tt:AddLine(" ")

        --GetWeeksMythicPlusRuns()
    end
})

function GetPvPText(activities)
    local header = ""
    local text = ""

    if activities[1].progress >= activities[1].threshold then
        local sampleItem = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activities[1].id)
        local iLvl = GetDetailedItemLevelInfo(sampleItem);
        header = string.format(L["RANKEDPVP_LOOT"], iLvl)
        text = "\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t"
    else
        header = L["RANKEDPVP"]
        text = "|cFFFF9900" .. tostring(activities[1].threshold - activities[1].progress) .. "|r"
    end

    if activities[2].progress >= activities[2].threshold then
        text = text .. "\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t"
    else
        text = text .. " / |cFFFF9900" .. tostring(activities[2].threshold - activities[2].progress) .. "|r"
    end

    if activities[3].progress >= activities[3].threshold then
        text = text .. "\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t"
    else
        text = text .. " / |cFFFF9900" .. tostring(activities[3].threshold-activities[3].progress) .. "|r"
    end

    return header, text
end

local icon = LibStub("LibDBIcon-1.0")

function VaultMinimapButton:ToggleVaultMinimapButton()
    self.db.profile.minimap.hide = not self.db.profile.minimap.hide
    if self.db.profile.minimap.hide then
        icon:Hide("VaultMinimapButton") else icon:Show("VaultMinimapButton")
    end
end

function VaultMinimapButton:OnInitialize() -- Obviously you'll need a ## SavedVariables: BunniesDB line in your TOC, duh!
    self.db = LibStub("AceDB-3.0"):New("VaultMinimapButton", { profile = { minimap = { hide = false, }, }, })
    icon:Register("VaultMinimapButton", ldb, self.db.profile.minimap)
    self:RegisterChatCommand("vault", "ToggleVaultMinimapButton")

    LoadAddOn("Blizzard_WeeklyRewards")
end

function GetActivities()
    activities = {}
    activities[Enum.WeeklyRewardChestThresholdType.None] = {}
    activities[Enum.WeeklyRewardChestThresholdType.MythicPlus] = {}
    activities[Enum.WeeklyRewardChestThresholdType.RankedPvP] = {}
    activities[Enum.WeeklyRewardChestThresholdType.Raid] = {}
    activities[Enum.WeeklyRewardChestThresholdType.AlsoReceive] = {}
    activities[Enum.WeeklyRewardChestThresholdType.Concession] = {}

    for index, activity in pairs(C_WeeklyRewards.GetActivities()) do
        table.insert(activities[activity.type], activity)
    end

    return activities
end

function GetMythicPlusActivityString(activity)
    if activity.progress >= activity.threshold then
        local sampleItem = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activity.id)
        local iLvl = GetDetailedItemLevelInfo(sampleItem);
        nextLvl, nextiLvl = GetNextMythicPlusLootBracket(activity.level)

        return string.format(L["MYTHICPLUS_REACHED"], iLvl, activity.level, nextiLvl, nextLvl)
    else
        return string.format(L["MYTHICPLUS_NOT_REACHED"], 0, activity.progress, activity.threshold)
    end

end

function GetNextMythicPlusLootBracket(currentMax)
    if currentMax < 2 then return 2, 200
    elseif currentMax < 3 then return 3, 203
    elseif currentMax < 4 then return 4, 207
    elseif currentMax < 5 then return 5, 210
    elseif currentMax < 7 then return 7, 213
    elseif currentMax < 8 then return 8, 216
    elseif currentMax < 10 then return 10, 220
    elseif currentMax < 12 then return 12, 223
    elseif currentMax < 14 then return 14, 226
    else return nil
    end
end

function GetIncompleteMythicPlusActivityILvl(rewardLevel)
    mythicPlusRuns = C_MythicPlus.GetRunHistory(false, true)
    print(dump(mythicPlusRuns))

end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

