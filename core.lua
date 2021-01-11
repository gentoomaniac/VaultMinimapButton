local addon = LibStub("AceAddon-3.0"):NewAddon("VaultMinimapIcon", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("VaultMinimapIcon", true)

local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("VaultMinimapIcon", {
	type = "data source",
	text = "VaultMinimapIcon",
    icon = "Interface\\ICONS\\Inv_legion_chest_KirinTor",
    OnClick = function()
    	if button == "RightButton" then
            -- InterfaceOptionsFrame_OpenToCategory(addonName)
            -- InterfaceOptionsFrame_OpenToCategory(addonName)
        else
            if WeeklyRewardsFrame:IsShown() then
                WeeklyRewardsFrame:Hide()
            else
                WeeklyRewardsFrame:Show()
            end
        end    
    end,
    OnTooltipShow = function(tt)
        local hasAvailableRewards = C_WeeklyRewards.HasAvailableRewards();
        local couldClaimRewardsInOnShow = C_WeeklyRewards.CanClaimRewards();

        tt:AddLine(addonName)
		if hasAvailableRewards then
            tt:AddLine(L["REWARDS_AVAILABLE"])
        elseif C_WeeklyRewards.HasGeneratedRewards() then
			tt:AddLine(L["HAS_GENERATED_REWARDS"])
		else
			tt:AddLine(L["NO_REWARDS"])
        end
	end
})

local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize() -- Obviously you'll need a ## SavedVariables: BunniesDB line in your TOC, duh!
    self.db = LibStub("AceDB-3.0"):New("VaultMinimapIcon", { profile = { minimap = { hide = false, }, }, })
    icon:Register("VaultMinimapIcon", ldb, self.db.profile.minimap)
    self:RegisterChatCommand("vault", "ToggleVaultMinimapIcon")

    LoadAddOn("Blizzard_WeeklyRewards")
end

function addon:ToggleVaultMinimapIcon()
    self.db.profile.minimap.hide = not self.db.profile.minimap.hide
    if self.db.profile.minimap.hide then
        icon:Hide("VaultMinimapIcon") else icon:Show("VaultMinimapIcon")
    end
end

