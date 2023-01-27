local _, L = ...;

WCLRanks = CreateFrame("Frame", "WCLRanks", UIParent);

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
                if type(v) == 'table' then
                        s = s .. '['..k..'] = ' .. dump(v) .. ','
                else
                        s = s .. '['..k..'] = ' .. tostring(v) .. ','
                end

      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function WCLRanks:Init()
  self.debug = false;
  self.defaults = {
    chatExtension = true,
    tooltipExtension = true,
    slashExtension = true,
    showDuringCombat = false,
    show = {},
  };
  self.activityDetails = {
    -- Naxxramas 10-man
    [841] = {
      zone = 1015,
      size = 10,
      encounters = { 101107, 101108, 101109, 101110, 101111, 101112, 101113, 101114, 101115, 101116, 101117, 101118, 101119, 101120, 101121 }
    },
    -- The Obsidian Sanctum 10-man
    [1101] = {
      zone = 1015,
      size = 10,
      encounters = { 742 }
    },
    -- The Eye of Eternity 10-man
    [1102] = {
      zone = 1015,
      size = 10,
      encounters = { 734 }
    },
    -- Vault of Archavon 10-man
    [1095] = {
      zone = 1016,
      size = 10,
      encounters = { 772 }
    },
    -- Naxxramas 25-man
    [1098] = {
      zone = 1015,
      size = 25,
      encounters = { 101107, 101108, 101109, 101110, 101111, 101112, 101113, 101114, 101115, 101116, 101117, 101118, 101119, 101120, 101121 }
    },
    -- The Obsidian Sanctum 25-man
    [1097] = {
      zone = 1015,
      size = 25,
      encounters = { 742 }
    },
    -- The Eye of Eternity 25-man
    [1094] = {
      zone = 1015,
      size = 25,
      encounters = { 734 }
    },
    -- Vault of Archavon 25-man
    [1096] = {
      zone = 1016,
      size = 25,
      encounters = { 772 }
    },
  };
  self.db = CopyTable(self.defaults);
  self.db.show["1015_10"] = true;
  self.db.show["1015_25"] = true;
  self.db.show["1016_10"] = true;
  self.db.show["1016_25"] = true;
  self.db.show["1017_10"] = true;
  self.db.show["1017_25"] = true;
  self:LogDebug("Init");
  self:SetScript("OnEvent", self.OnEvent);
  self:RegisterEvent("ADDON_LOADED");
  self:RegisterEvent("CHAT_MSG_SYSTEM");
  self:RegisterEvent("MODIFIER_STATE_CHANGED");
  self:RegisterEvent("PLAYER_ENTERING_WORLD");
  --self:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
  GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip, ...)
    WCLRanks:OnTooltipSetUnit(tooltip, ...);
  end);
  GameTooltip:HookScript("OnShow", function(tooltip, ...)
    WCLRanks:OnTooltipShow(tooltip, ...);
  end);
end

function WCLRanks:InitOptions()
  self.optionsPanel = CreateFrame("Frame");
  self.optionsPanel.name = "WCLRanks";
  InterfaceOptions_AddCategory(self.optionsPanel);
  pos_y = -20
  -- Chat integration
  self.optionCheckChat = CreateFrame("CheckButton", nil, self.optionsPanel, "InterfaceOptionsCheckButtonTemplate");
	self.optionCheckChat:SetPoint("TOPLEFT", 20, pos_y);
	self.optionCheckChat.Text:SetText(L["OPTION_CHAT"]);
	self.optionCheckChat:SetScript("OnClick", function()
		self.db.chatExtension = self.optionCheckChat:GetChecked();
	end)
	self.optionCheckChat:SetChecked(self.db.chatExtension);
	pos_y = pos_y - 20
  -- Player tooltip integration
  self.optionCheckTooltip = CreateFrame("CheckButton", nil, self.optionsPanel, "InterfaceOptionsCheckButtonTemplate");
	self.optionCheckTooltip:SetPoint("TOPLEFT", 20, pos_y);
	self.optionCheckTooltip.Text:SetText(L["OPTION_TOOLTIP"]);
	self.optionCheckTooltip:SetScript("OnClick", function()
		self.db.tooltipExtension = self.optionCheckTooltip:GetChecked();
	end)
	self.optionCheckTooltip:SetChecked(self.db.tooltipExtension);
	pos_y = pos_y - 20
  -- Slash command
  self.optionCheckSlash = CreateFrame("CheckButton", nil, self.optionsPanel, "InterfaceOptionsCheckButtonTemplate");
	self.optionCheckSlash:SetPoint("TOPLEFT", 20, pos_y);
	self.optionCheckSlash.Text:SetText(L["OPTION_SLASH_CMD"]);
	self.optionCheckSlash:SetScript("OnClick", function(_, value)
		self.db.slashExtension = self.optionCheckSlash:GetChecked();
	end)
	self.optionCheckSlash:SetChecked(self.db.slashExtension);
	pos_y = pos_y - 20
  -- Show tooltip logs During combat
  self.optionDuringCombat = CreateFrame("CheckButton", nil, self.optionsPanel, "InterfaceOptionsCheckButtonTemplate");
	self.optionDuringCombat:SetPoint("TOPLEFT", 20, pos_y);
	self.optionDuringCombat.Text:SetText(L["OPTION_DURING_COMBAT"]);
	self.optionDuringCombat:SetScript("OnClick", function(_, value)
		self.db.showDuringCombat = self.optionDuringCombat:GetChecked();
	end)
	self.optionDuringCombat:SetChecked(self.db.showDuringCombat);
	pos_y = pos_y - 20
  -- Show NAXX/Sarth/Maly 10 player logs
  self.optionShow_1015_10 = CreateFrame("CheckButton", nil, self.optionsPanel, "InterfaceOptionsCheckButtonTemplate");
	self.optionShow_1015_10:SetPoint("TOPLEFT", 20, pos_y);
	self.optionShow_1015_10.Text:SetText(L["OPTION_SHOW_1015_10"]);
	self.optionShow_1015_10:SetScript("OnClick", function(_, value)
		self.db.show["1015_10"] = self.optionShow_1015_10:GetChecked();
	end)
	self.optionShow_1015_10:SetChecked(self.db.show["1015_10"]);
	pos_y = pos_y - 20
  -- Show NAXX/Sarth/Maly 25 player logs
  self.optionShow_1015_25 = CreateFrame("CheckButton", nil, self.optionsPanel, "InterfaceOptionsCheckButtonTemplate");
	self.optionShow_1015_25:SetPoint("TOPLEFT", 20, pos_y);
	self.optionShow_1015_25.Text:SetText(L["OPTION_SHOW_1015_25"]);
	self.optionShow_1015_25:SetScript("OnClick", function(_, value)
		self.db.show["1015_25"] = self.optionShow_1015_25:GetChecked();
	end)
	self.optionShow_1015_25:SetChecked(self.db.show["1015_25"]);
	pos_y = pos_y - 20
  -- Show Vault of Archavon 10 player logs
  self.optionShow_1016_10 = CreateFrame("CheckButton", nil, self.optionsPanel, "InterfaceOptionsCheckButtonTemplate");
	self.optionShow_1016_10:SetPoint("TOPLEFT", 20, pos_y);
	self.optionShow_1016_10.Text:SetText(L["OPTION_SHOW_1016_10"]);
	self.optionShow_1016_10:SetScript("OnClick", function(_, value)
		self.db.show["1016_10"] = self.optionShow_1016_10:GetChecked();
	end)
	self.optionShow_1016_10:SetChecked(self.db.show["1016_10"]);
	pos_y = pos_y - 20
  -- Show Vault of Archavon 25 player logs
  self.optionShow_1016_25 = CreateFrame("CheckButton", nil, self.optionsPanel, "InterfaceOptionsCheckButtonTemplate");
	self.optionShow_1016_25:SetPoint("TOPLEFT", 20, pos_y);
	self.optionShow_1016_25.Text:SetText(L["OPTION_SHOW_1016_25"]);
	self.optionShow_1016_25:SetScript("OnClick", function(_, value)
		self.db.show["1016_25"] = self.optionShow_1016_25:GetChecked();
	end)
	self.optionShow_1016_25:SetChecked(self.db.show["1016_25"]);
	pos_y = pos_y - 20
  -- Show Ulduar 10 player logs
  self.optionShow_1017_10 = CreateFrame("CheckButton", nil, self.optionsPanel, "InterfaceOptionsCheckButtonTemplate");
	self.optionShow_1017_10:SetPoint("TOPLEFT", 20, pos_y);
	self.optionShow_1017_10.Text:SetText(L["OPTION_SHOW_1017_10"]);
	self.optionShow_1017_10:SetScript("OnClick", function(_, value)
		self.db.show["1017_10"] = self.optionShow_1017_10:GetChecked();
	end)
	self.optionShow_1017_10:SetChecked(self.db.show["1017_10"]);
	pos_y = pos_y - 20
  -- Show Ulduar 25 player logs
  self.optionShow_1017_25 = CreateFrame("CheckButton", nil, self.optionsPanel, "InterfaceOptionsCheckButtonTemplate");
	self.optionShow_1017_25:SetPoint("TOPLEFT", 20, pos_y);
	self.optionShow_1017_25.Text:SetText(L["OPTION_SHOW_1017_25"]);
	self.optionShow_1017_25:SetScript("OnClick", function(_, value)
		self.db.show["1017_25"] = self.optionShow_1017_25:GetChecked();
	end)
	self.optionShow_1017_25:SetChecked(self.db.show["1017_25"]);
	pos_y = pos_y - 20
end

function WCLRanks:LogOutput(...)
  print("|cffff0000WCLRanks|r", ...);
end

function WCLRanks:LogDebug(...)
  if self.debug then
    print("|cffff0000WCLRanks|r", "|cffffff00Debug|r", ...);
  end
end

function WCLRanks:AddPlayerInfoToTooltip(targetName)
  local playerData, playerName, playerRealm = self:GetPlayerData(targetName);
  self:LogDebug("playerData = " .. dump(playerData))
  if playerData then
    self:LogDebug("WCLRanks:AddPlayerInfoToTooltip!!")
    self:SetPlayerInfoTooltip(playerData, playerName, playerRealm);
  end
end

function WCLRanks:OnSlashCommand(cmd)
  if not self.db.slashExtension then
    return;
  end
  if not cmd or cmd == ""  or cmd == "help" or cmd == "?" then
    print("|cFFE5CC7F[WCLRanks]|r " .. "Shows player's WCL scores")
    print("|cFFE5CC7F[WCLRanks]|r " .. "|cFFFFFF00/WCLRanks or /wr CHAR_NAME|r to query CHAR_NAME's score")
    print("|cFFE5CC7F[WCLRanks]|r " .. "|cFFFFFF00/WCLRanks or /wr help|?|r to show this help")
    return;
  end
  --self:LogOutput("OnSlashCommand", arguments);
  local playerData, playerName, playerRealm = self:GetPlayerData(cmd);
  if playerData then
    self:SendSystemChatLine(L["CHAT_PLAYER_DETAILS"].." |Hplayer:"..playerName.."-"..playerRealm.."|h"..playerName.."|h");
    self:SendPlayerInfoToChat(playerData, playerName, playerRealm, true);
  else
    self:SendSystemChatLine(L["CHAT_PLAYER_NOT_FOUND"].. ": " .. cmd.."|h");
  end
end

function WCLRanks:OnEvent(event, ...)
  if (event == "ADDON_LOADED") then
    self:OnAddonLoaded(...);
  elseif (event == "CHAT_MSG_SYSTEM") then
    self:OnChatMsgSystem(...);
  elseif (event == "UPDATE_MOUSEOVER_UNIT") then
    self:OnMouseoverUnit(...);
  elseif (event == "MODIFIER_STATE_CHANGED") then
    self:OnModifierStateChanged(...);
  elseif (event == "PLAYER_ENTERING_WORLD") then
    -- Workaround for misaligned tooltip
    if TacoTipConfig and not TacoTipConfig.show_guild_name then
      print(self:GetColoredText("error", L["TACOTIP_GUILD_NAME_WARNING"]));
    end
  else
    self:LogDebug("OnEvent", event, ...);
  end
end

function WCLRanks:OnAddonLoaded(addonName)
  if (addonName ~= "WCLRanks") then
    return;
  end
  WCLRanksDB = WCLRanksDB or self.db;
  self.db = WCLRanksDB;
  -- Init options panel
  self:InitOptions();
  -- Register shlash command
  if self.db.slashExtension then
    SLASH_LOGTRACKER1, SLASH_LOGTRACKER2 = '/wr', '/wclranks';
    SlashCmdList.LOGTRACKER = function(...)
      WCLRanks:OnSlashCommand(...);
    end
  end
end

function WCLRanks:OnChatMsgSystem(text)
  if not self.db.chatExtension then
    return;
  end
  local _, _, name, linkText = string.find(text, "|Hplayer:([^:]*)|h%[([^%[%]]*)%]?|h");
  if name then
    local playerData, playerName, playerRealm = self:GetPlayerData(name);
    if playerData then
      self:SendPlayerInfoToChat(playerData, playerName, playerRealm);
    end
  end
end

function WCLRanks:OnModifierStateChanged()
  if not self.db.tooltipExtension then
    return;
  end
  if (UnitExists("mouseover")) then
    GameTooltip:SetUnit("mouseover");
  end
end

function WCLRanks:OnTooltipSetUnit(tooltip, ...)
  if not self.db.tooltipExtension then
    return;
  end
  local unitName, unitId = GameTooltip:GetUnit();
  if not UnitIsPlayer(unitId) then
    return;
  end
  if InCombatLockdown() or UnitAffectingCombat("player") then
    if not self.db.showDuringCombat then
    	return
    end
  end
  local unitName, unitRealm = UnitName(unitId);
  local playerData, playerName, playerRealm = self:GetPlayerData(unitName, unitRealm);
  if playerData then
    self:SetPlayerInfoTooltip(playerData, playerName, playerRealm);
  end
end

function WCLRanks:IsTooltipLFGPlayer(tooltip)
  if not self.db.lfgExtension then
    return false;
  end
  if LFGBrowseSearchEntryTooltip and (tooltip == LFGBrowseSearchEntryTooltip) then
    return true;
  else
    return false;
  end
end

function WCLRanks:OnTooltipShow(tooltip, ...)
  if self:IsTooltipLFGPlayer(tooltip) then
    self:OnTooltipShow_LFGPlayer(tooltip, ...);
  end
end

function WCLRanks:OnTooltipShow_LFGPlayer(tooltip, resultID)
  local logTargets = nil;
  local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID);
  if #searchResultInfo.activityIDs > 0 then
    for i, activityID in ipairs(searchResultInfo.activityIDs) do
      self:LogDebug("activityID = " .. activityID);
      local activityDetails = self.activityDetails[activityID];
      if activityDetails then
        local activityKey = activityDetails.zone.."_"..activityDetails.size;
        if not logTargets then
          logTargets = {};
        end
        if not logTargets[activityKey] then
          logTargets[activityKey] = {};
        end
        for e, encounterID in ipairs(activityDetails.encounters) do
          if not tContains(logTargets[activityKey], encounterID) then
            tinsert(logTargets[activityKey], encounterID);
          end
        end
      end
    end
  end
  -- Tooltip for lead / single player
  local tooltipName = tooltip:GetName();
  local playerLine = tooltip.Leader.Name:GetText();
  local playerNameTooltip = strsplit("_", playerLine);
  playerNameTooltip = strtrim(playerNameTooltip);
  local playerData, playerName, playerRealm = self:GetPlayerData(playerNameTooltip);
  if playerData then
    -- Add instance top rank for leader
    if not tooltip.Leader.Logs then
      tooltip.Leader.Logs = tooltip.Leader:CreateFontString(nil, "ARTWORK", "GameFontNormal");
      tooltip.Leader.Logs:SetPoint("TOPLEFT", tooltip.Leader.Role, "TOPRIGHT", 32, -2)
    end
    tooltip.Leader.Logs:SetText(self:GetPlayerOverallPerformance(playerData, logTargets));
    -- Add tooltip for leader
    GameTooltip:ClearLines();
    GameTooltip:SetOwner(LFGBrowseSearchEntryTooltip);
    GameTooltip:SetText(playerNameTooltip);
    self:SetPlayerInfoTooltip(playerData, playerName, playerRealm, true);
    -- TODO: Solve positioning cleaner
    C_Timer.After(0, function()
      GameTooltip:ClearAllPoints();
      GameTooltip:SetPoint("TOPLEFT", LFGBrowseSearchEntryTooltip, "BOTTOMLEFT");
    end);
  else
    GameTooltip:ClearLines();
    GameTooltip:Hide();
  end
  -- Tooltip for additional members
  for frame in tooltip.memberPool:EnumerateActive() do
    self:OnTooltipShow_LFGMember(frame, logTargets);
  end
  -- Increase width to prevent overlap
  tooltip:SetWidth( tooltip:GetWidth() + 32 );
end

function WCLRanks:OnTooltipShow_LFGMember(frame, logTargets)
  if not frame.Logs then
    frame.Logs = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    frame.Logs:SetPoint("TOPLEFT", frame.Role, "TOPRIGHT", 32, -2)
  end
  local memberName = frame.Name:GetText();
  local playerData, playerName, playerRealm = self:GetPlayerData(memberName);
  if playerData then
    frame.Logs:SetText(self:GetPlayerOverallPerformance(playerData, logTargets));
  else
    frame.Logs:SetText(self:GetColoredText("muted", "--"));
  end
end

function WCLRanks:GetIconSized(iconTemplate, width, height)
  local iconString = gsub(gsub(iconTemplate, "%%w", width), "%%h", height);
  return "|T"..iconString.."|t";
end

-- /script print(WCLRanks:GetClassIcon("Priest"))
-- /script print("\124TInterface/AddOns/WCLRanks/Icons/classes:36:36:0:0:256:512:180:216:36:72\124t")
-- /script print("\124TInterface/InventoryItems/WoWUnknownItem01\124t")
function WCLRanks:GetClassIcon(classNameOrId, width, height)
  if not width then
    width = 14;
  end
  if not height then
    height = 14;
  end
  --local addonLoaded = LoadAddOn("WCLRanks_BaseData");
  --if not addonLoaded or not WCLRanks_BaseData or not WCLRanks_BaseData.classes or not WCLRanks_BaseData.classes[classNameOrId] then
  --  return self:GetIconSized("Interface/InventoryItems/WoWUnknownItem01:%w:%h", width, height);
  --end
  local classData = WCLRanks_BaseData.classes[classNameOrId];
  return self:GetIconSized(classData.icon, width, height);
end

function WCLRanks:GetSpecIcon(classNameOrId, specNameOrId, width, height)
  if not width then
    width = 14;
  end
  if not height then
    height = 14;
  end
  --local addonLoaded = LoadAddOn("WCLRanks_BaseData");
  --if not addonLoaded or not WCLRanks_BaseData or not WCLRanks_BaseData.classes or not WCLRanks_BaseData.classes[classNameOrId]
  --    or not WCLRanks_BaseData.classes[classNameOrId].specs or not WCLRanks_BaseData.classes[classNameOrId].specs[specNameOrId] then
  --  return self:GetIconSized("Interface/InventoryItems/WoWUnknownItem01:%w:%h", width, height);
  --end
  local classData = WCLRanks_BaseData.classes[classNameOrId];
  local specData = classData.specs[specNameOrId];
  return self:GetIconSized(specData.icon, width, height);
end

function WCLRanks:GetColoredText(type, text)
  if (type == "zone") then
    return "|cffdd60ff"..text.."|r";
  elseif (type == "spec") then
    return "|cffffffff"..text.."|r";
  elseif (type == "muted") then
    return "|cff808080"..text.."|r";
  elseif (type == "error") then
    return "|cffff0000"..text.."|r";
  else
    return text;
  end
end

function WCLRanks:GetColoredProgress(done, overall)
  if (done == 0) then
    return "|cffd00000"..done.."/"..overall.."|r";
  elseif (done < overall) then
    return "|cffd0d000"..done.."/"..overall.."|r";
  else
    return "|cff00d000"..done.."/"..overall.."|r";
  end
end

function WCLRanks:GetColoredPercent(value, text)
  value = floor(value);
  if (value >= 100) then
    return "|cFFE5CC80"..text.."|r";
  elseif (value >= 99) then
    return "|cFFE26880"..text.."|r";
  elseif (value >= 95) then
    return "|cFFFF8000"..text.."|r";
  elseif (value >= 85) then
    return "|cFFBE8200"..text.."|r";
  elseif (value >= 75) then
    return "|cFFA335EE"..text.."|r";
  elseif (value >= 50) then
    return "|cFF0070FF"..text.."|r";
  elseif (value >= 25) then
    return "|cFF1EFF00"..text.."|r";
  else
    return "|cFF666666"..text.."|r";
  end
end

function WCLRanks:GetPlayerLink(playerName)
  return self:GetColoredText("player", "|Hplayer:"..playerName.."|h["..playerName.."]|h");
end

function WCLRanks:GetPlayerData(playerFull, realmNameExplicit)
  local playerName, realmName = strsplit("_", playerFull);
  if not realmName then
    if not realmNameExplicit or (realmNameExplicit == "") then
      realmName = GetRealmName();
    else
      realmName = realmNameExplicit
    end
  end
  self:LogDebug("playerName = " .. playerName);

  if type(WP_Database) ~= "table" then
    self:LogDebug("WP_Database is NOT a table!!")
    return nil
  end
  if not WP_Database[playerName] then
    return nil
  end

  local characterDataRaw = WP_Database[playerName]
  local characterData = nil;
  -- Unpack character data into a more accessible format
  if characterDataRaw then
    local characterPerformance = {};
    for zoneIdSize, zonePerformance in pairs(characterDataRaw[3]) do
      local zoneId, zoneSize = strsplit("_", zoneIdSize);
      zoneId = tonumber(zoneId);
      zoneSize = tonumber(zoneSize);
      if not self.db.show[zoneIdSize] then
        self:LogDebug(zoneIdSize .. " is disabled")
      else
        self:LogDebug("zoneId = " .. zoneId .. ", zoneSize = " .. zoneSize)
        -- Zone name
        local zoneName = "Unknown ("..zoneSize..")";
        if WCLRanks_BaseData.zoneNames and WCLRanks_BaseData.zoneNames[zoneId] then
          zoneName = WCLRanks_BaseData.zoneNames[zoneId]['name'].."("..zoneSize..")";
        end
        self:LogDebug("zoneName = " .. zoneName)
        -- Allstars rankings {A,1,703.76,47.53,153,944,56202} (color, spec_id, points, rank_percent, server_rank, region_rank, rank)
        local zoneAllstars = {};
        for _, zoneAllstarsRaw in ipairs(zonePerformance[3]) do
          tinsert(zoneAllstars, {
            ['color'] = zoneAllstarsRaw[1],
            ['spec'] = tonumber(zoneAllstarsRaw[2]),
            ['points'] = zoneAllstarsRaw[3],
            ['percentRank'] = zoneAllstarsRaw[4],
            ['serverRank'] = zoneAllstarsRaw[5],
            ['regionRank'] = zoneAllstarsRaw[6],
            ['rank'] = zoneAllstarsRaw[7]
          });
          self:LogDebug("zoneAllstarsRaw = " .. dump(zoneAllstarsRaw))
        end
        -- Encounters 3,82.67,80.44,38,135,9381
        local zoneEncounters = {};
        if zonePerformance[4] ~= "" then
          local zoneEncountersStr = { strsplit("|", zonePerformance[4]) };
          for zoneEncounterIndex, zoneEncountersRaw in ipairs(zoneEncountersStr) do
            if (zoneEncountersRaw ~= "") then
              zoneEncountersRaw = { strsplit(",", zoneEncountersRaw) };
            else
              zoneEncountersRaw = { 0, 0, 0, 0, 0, 0 };
            end
            tinsert(zoneEncounters, {
              ['spec'] = tonumber(zoneEncountersRaw[1]),
              ['encounter'] = WCLRanks_BaseData.zoneEncounters[zoneId][zoneEncounterIndex],
              ['points'] = zoneEncountersRaw[2],
              ['percentRank'] = zoneEncountersRaw[3],
              ['serverRank'] = zoneEncountersRaw[4],
              ['regionRank'] = zoneEncountersRaw[5],
              ['rank'] = zoneEncountersRaw[6]
            });
          end
        end
        -- Zone details
        characterPerformance[zoneIdSize] = {
          ['zoneName'] = zoneName,
          ['zoneEncounters'] = zonePerformance[1],
          ['encountersKilled'] = zonePerformance[2],
          ['allstars'] = zoneAllstars,
          ['encounters'] = zoneEncounters
        }
      end
    end
    -- Character details
    characterData = {
      ['class'] = tonumber(characterDataRaw[1]),
      ['last_update'] = characterDataRaw[2],
      ['performance'] = characterPerformance,
    };
  end
  return characterData, playerName, realmName;
end

function WCLRanks:GetPlayerOverallPerformance(playerData, logTargets)
  local logScoreValue = 0;
  local logScoreCount = 0;
  for zoneId, zoneData in pairs(playerData['performance']) do
    for _, encounterData in ipairs(zoneData['encounters']) do
      local targetEncounters = nil;
      if logTargets and logTargets[zoneId] then
        targetEncounters = logTargets[zoneId];
      end
      if not logTargets or (targetEncounters and tContains(targetEncounters, encounterData['encounter']['id'])) then
        -- logTargets is either nil (include every encounter) or it contains the given encounter
        logScoreValue = logScoreValue + encounterData['percentRank'];
        logScoreCount = logScoreCount + 1;
      end
    end
  end
  if (logScoreCount > 0) then
    percent = logScoreValue / logScoreCount
    return self:GetColoredPercent(percent, percent);
  else
    return self:GetColoredText("muted", "--");
  end
end

function WCLRanks:GetPlayerZonePerformance(zone, playerClass)
  local zoneName = zone.zoneName;
  local zoneProgress = self:GetColoredProgress(tonumber(zone.encountersKilled), tonumber(zone.zoneEncounters));
  local zoneRatingsStr = "";
  local zoneRatings = {};
  for _, allstarsRating in ipairs(zone.allstars) do
    percent = allstarsRating.percentRank
    text = allstarsRating.points .. '/' .. percent .. '% Ranks:' .. allstarsRating.serverRank .. '/' .. allstarsRating.regionRank .. '/' .. allstarsRating.rank
    if allstarsRating.color == 'A' then
       percent = 100
    end
    tinsert(zoneRatings, self:GetSpecIcon(playerClass, allstarsRating.spec).." "..self:GetColoredPercent(percent, text));
  end
  if #(zoneRatings) > 0 then
    zoneRatingsStr = strjoin(" ", unpack(zoneRatings));
  end
  return self:GetColoredText("zone", zoneName), self:GetColoredText("progress", zoneProgress), zoneRatingsStr;
end

function WCLRanks:GetPlayerEncounterPerformance(encounter, playerClass, reversed)
  local encounterName = encounter.encounter.name;
  if (encounter.spec == 0) then
    return self:GetColoredText("encounter", encounterName), "---";
  end
  local encounterRating = self:GetSpecIcon(playerClass, encounter.spec).." "..self:GetColoredPercent(encounter.percentRank, encounter.percentRank);
  if (reversed) then
    percent = encounter.percentRank
    text = encounter.points .. '/' .. encounter.percentRank .. '% (' .. encounter.serverRank .. '/' .. encounter.regionRank .. '/' .. encounter.rank .. ')'
    encounterRating = self:GetColoredPercent(percent, text).." "..self:GetSpecIcon(playerClass, encounter.spec);
  end
  return self:GetColoredText("encounter", encounterName), encounterRating;
end

function WCLRanks:SendSystemChatLine(text)
  local chatInfo = ChatTypeInfo["SYSTEM"];
  local i;
  for i=1, 16 do
    local chatFrame = _G["ChatFrame"..i];
    if (chatFrame) then
      chatFrame:AddMessage(text, chatInfo.r, chatInfo.g, chatInfo.b, chatInfo.id);
    end
  end
end

function WCLRanks:SendPlayerInfoToChat(playerData, playerName, playerRealm, showEncounters)
  for zoneId, zone in pairs(playerData.performance) do
    local zoneName, zoneProgress, zoneSpecs = self:GetPlayerZonePerformance(zone, playerData.class);
    self:SendSystemChatLine( self:GetPlayerLink(playerName).." "..strjoin(" ", self:GetPlayerZonePerformance(zone, playerData.class)) );
    if showEncounters then
      for _, encounter in ipairs(zone.encounters) do
        local encounterName, encounterRating = self:GetPlayerEncounterPerformance(encounter, playerData.class);
        self:SendSystemChatLine("  "..encounterName..": "..encounterRating);
      end
    end
  end
  self:SendSystemChatLine(L["DATE_UPDATE"]..": "..date(L["DATE_FORMAT"], playerData.last_update));
end

function WCLRanks:SetPlayerInfoTooltip(playerData, playerName, playerRealm, disableShiftNotice)
  self:LogDebug("WCLRanks:SetPlayerInfoTooltip")
  for zoneIdSize, zone in pairs(playerData.performance) do
    local zoneId, zoneSize = strsplit("_", zoneIdSize);
    local zoneName, zoneProgress, zoneSpecs = self:GetPlayerZonePerformance(zone, playerData.class);
    GameTooltip:AddDoubleLine(
      zoneName.." "..zoneProgress, zoneSpecs,
      1, 1, 1, 1, 1, 1
    );
    if IsShiftKeyDown() then
      for _, encounter in ipairs(zone.encounters) do
        local encounterName, encounterRating = self:GetPlayerEncounterPerformance(encounter, playerData.class, true);
        GameTooltip:AddDoubleLine(
          "  "..encounterName, encounterRating,
          1, 1, 1, 1, 1, 1
        );
      end
    end
  end
  if IsShiftKeyDown() then
    GameTooltip:AddDoubleLine(
      L["DATE_UPDATE"], date(L["DATE_FORMAT"], playerData.last_update),
      0.5, 0.5, 0.5, 0.5, 0.5, 0.5
    );
  end
  if not IsShiftKeyDown() and not disableShiftNotice then
    GameTooltip:AddLine(
      self:GetColoredText("muted", L["SHIFT_FOR_DETAILS"]),
      1, 1, 1
    );
  end
  GameTooltip:Show();
end

-- Kickstart the addon
WCLRanks:Init();
