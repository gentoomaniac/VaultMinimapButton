local VaultMinimapButton = LibStub("AceAddon-3.0"):NewAddon("VaultMinimapButton", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("VaultMinimapButton", true)

local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("VaultMinimapButton", {
    type = "data source",
    text = "VaultMinimapButton",
    icon = "Interface\\ICONS\\Inv_legion_chest_KirinTor",
    OnClick = function()
        if button ~= "RightButton" then
            if WeeklyRewardsFrame:IsShown() then
                WeeklyRewardsFrame:Hide()
            else
                WeeklyRewardsFrame:Show()
            end
        end    
    end,
    OnTooltipShow = function(tt)
        local activities = GetActivities()

        tt:SetText(L["ADDONNAME"])
        tt:AddDoubleLine(L["MYTHICPLUS"])
        for index, activity in pairs(activities[Enum.WeeklyRewardChestThresholdType.MythicPlus]) do
            tt:AddLine(GetMythicPlusActivityString(activity))
        end
    end
})

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

        return "#" .. activity.index .. ": " .. iLvl .. " (+" .. activity.level ..")"
    else
        return "#" .. activity.index .. ": " .. activity.progress .. "/" .. activity.threshold
    end
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

