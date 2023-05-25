--localization file for Taiwan
local L = LibStub("AceLocale-3.0"):NewLocale("WCLRanks", "zhTW");
if not L then return end 

L["ADDON_TITLE"] = "WCLRanks"
L["CHAT_PLAYER_DETAILS"] = "角色的 WCL 評分"
L["CHAT_PLAYER_NOT_FOUND"] = "查無此角色資料"
L["SHIFT_FOR_DETAILS"] = "按下 Shift 顯示詊細資料"
L["OPTION_CHAT"] = "聊天整合(/who 及上線通知)，自動查詢角色資料"
L["OPTION_TOOLTIP"] = "滑鼠提示整合(當滑鼠移到人物上或人物框時提示)"
L["OPTION_SLASH_CMD"] = "斜線指令整合(在對話框中輸入 /wr <角色名稱> 或 /wclranks <角色名稱>)"
L["OPTION_DURING_COMBAT"] = "進入戰鬥時也在滑鼠提示上顯示 WCL 評分"
L["OPTION_COMPAT_MODE"] = "在滑鼠提示上顯示簡潔 WCL 評分"
L["OPTION_NUM_SPEC"] = "讀取幾組不同天賦的全明星分數"
L["OPTION_SHOW_1015_10"] = "顯示 NAXX/Sarth/Maly 10 人本的資料"
L["OPTION_SHOW_1015_25"] = "顯示 NAXX/Sarth/Maly 25 人本的資料"
L["OPTION_SHOW_1016_10"] = "顯示 Vault of Archavon 10 人本的資料"
L["OPTION_SHOW_1016_25"] = "顯示 Vault of Archavon 25 人本的資料"
L["OPTION_SHOW_1017_10"] = "顯示 奧杜亞 10 人本的資料"
L["OPTION_SHOW_1017_25"] = "顯示 奧杜亞 25 人本的資料"
L["DATE_UPDATE"] = "更新時間"
L["DATE_FORMAT"] = "%d. %b %Y %H:%M:%S"
L["TACOTIP_GUILD_NAME_WARNING"] = "[WCLRanks] Warning! You have TacoTip installed with the Guild-Name disabled! This can cause misaligned tooltips. Please consider enabling guild names under ESC > Interface > AddOns > TacoTip > UnitTooltips."

L["WCL_URL"] = "https://tw.classic.warcraftlogs.com"
