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
            tt:AddDoubleLine(GetMythicPlusActivityString(activity))
        end
        tt:AddLine(" ")

        tt:AddLine(L["RAID"])
        tt:AddLine(" ")

        pvpHeader, pvpText = GetPvPText(activities[Enum.WeeklyRewardChestThresholdType.RankedPvP])
        tt:AddLine(pvpHeader)
        tt:AddLine(pvpText)
        tt:AddLine(" ")
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
        sampleItem = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activity.id)
        iLvl = GetDetailedItemLevelInfo(sampleItem);
        nextLvl, nextiLvl = GetNextMythicPlusLootBracket(activity.level)

        return
            string.format(L["MYTHICPLUS_REACHED"], iLvl, activity.level, nextiLvl, nextLvl),
            string.format(L["MYTHICPLUS_NEXT_REWARD_ESTIMATE"], nextiLvl, nextLvl)


    elseif activity.progress > 0 then
        nextLvl = GetNextMythicPlusRewardLvl(activity.threshold)
        rewardLvl = C_MythicPlus.GetRewardLevelFromKeystoneLevel(nextLvl)
        return
            string.format(L["MYTHICPLUS_NOT_REACHED"], "\124T" .. READY_CHECK_WAITING_TEXTURE .. ":0|t", activity.progress, activity.threshold),
            string.format(L["MYTHICPLUS_NEXT_REWARD_ESTIMATE"], rewardLvl, nextLvl)
    else
        return string.format(L["MYTHICPLUS_NOT_REACHED"], "\124T" .. READY_CHECK_WAITING_TEXTURE .. ":0|t", activity.progress, activity.threshold), ""
    end
end

function GetNextMythicPlusLootBracket(currentMax)
    if currentMax >= 15 then return nil end

    local currentReward = C_MythicPlus.GetRewardLevelFromKeystoneLevel(currentMax)
    local newMax = currentMax
    repeat
        newMax = newMax + 1
        newReward = C_MythicPlus.GetRewardLevelFromKeystoneLevel(newMax)
    until newReward > currentReward

    return newMax, newReward
end

function GetNextMythicPlusRewardLvl()
    local mythicPlusRuns = C_MythicPlus.GetRunHistory(false, true)

    local mythicPlusLevels = {}

    for index, run in pairs(mythicPlusRuns) do
        table.insert(mythicPlusLevels, run.level)
    end
    table.sort(mythicPlusLevels)

    reult = {}

    return mythicPlusLevels[1], mythicPlusLevels[4] or mythicPlusLevels[-1], mythicPlusLevels[10] or mythicPlusLevels[-1]
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
