--localization file for english/United States
local L = LibStub("AceLocale-3.0"):NewLocale ("WCLRanks", "enUS", true) 
if not L then return end 

-- Addon translations
L["ADDON_TITLE"] = "WCLRanks"
L["CHAT_PLAYER_DETAILS"] = "Log details for player"
L["CHAT_PLAYER_NOT_FOUND"] = "No log details found for player"
L["SHIFT_FOR_DETAILS"] = "Shift for more details"
L["OPTION_CHAT"] = "Chat-Integration (/who and Online-Alerts)"
L["OPTION_TOOLTIP"] = "Tooltip-Integration (On mouseover of players/unitframes)"
L["OPTION_SLASH_CMD"] = "Slash-Commands (Chat commands via /wr <playername> or /wclranks <playername>)"
L["OPTION_DURING_COMBAT"] = "Show logs on tooltip during combat"
L["OPTION_COMPAT_MODE"] = "Show compat info on the tooltip"
L["OPTION_NUM_SPEC"] = "Read how many all star specs"
L["OPTION_SHOW_1015_10"] = "Show NAXX/Sarth/Maly 10-player logs"
L["OPTION_SHOW_1015_25"] = "Show NAXX/Sarth/Maly 25-player logs"
L["OPTION_SHOW_1016_10"] = "Show Vault of Archavon 10-player logs"
L["OPTION_SHOW_1016_25"] = "Show Vault of Archavon 25-player logs"
L["OPTION_SHOW_1017_10"] = "Show Ulduar 10-player logs"
L["OPTION_SHOW_1017_25"] = "Show Ulduar 25-player logs"
L["DATE_UPDATE"] = "Last update"
L["DATE_FORMAT"] = "%d. %b %Y %H:%M:%S"
L["TACOTIP_GUILD_NAME_WARNING"] = "[WCLRanks] Warning! You have TacoTip installed with the Guild-Name disabled! This can cause misaligned tooltips. Please consider enabling guild names under ESC > Interface > AddOns > TacoTip > UnitTooltips."
