-- Quest hyperlink details for Vanilla/Turtle chat links.
--
-- pfQuest-classicAPI historically replaced the tiny native quest-link popup
-- with a full ItemRefTooltip containing the quest title, status, objective,
-- description and level requirements. Questie-Octo restores that presentation
-- while preserving Questie-Octo's Quest Log interaction contract:
--   * Shift + left-click on a Quest Log quest tracks/untracks it normally.
--   * If the chat edit box is open, the same Shift + left-click inserts a
--     clickable quest hyperlink instead, matching pfQuest's Vanilla behavior.
--
-- ItemRefTooltip is intentional: pfUI already skins that native tooltip frame,
-- while non-pfUI users retain the normal Blizzard ItemRefTooltip appearance.

QuestieOcto.QuestLinkTooltip = QuestieOcto.QuestLinkTooltip or {}
local Q=QuestieOcto.QuestLinkTooltip

Q.started=Q.started or false
Q.hooked=Q.hooked or false
Q.originalSetItemRef=Q.originalSetItemRef
Q.lastQuestLink=Q.lastQuestLink

local function Settings()
  return QuestieOcto.MinimapSettings
end

local function FormatQuestText(text)
  if not text or text=="" then return nil end
  local player=(UnitName and UnitName("player")) or "adventurer"
  local race=(UnitRace and UnitRace("player")) or ""
  local class=(UnitClass and UnitClass("player")) or ""
  text=string.gsub(text,"%$N",player); text=string.gsub(text,"%$n",player)
  text=string.gsub(text,"%$R",race); text=string.gsub(text,"%$r",race)
  text=string.gsub(text,"%$C",class); text=string.gsub(text,"%$c",class)
  text=string.gsub(text,"%$B","\n"); text=string.gsub(text,"%$b","\n")
  return text
end

local function LinkTitle(text)
  if not text then return nil end
  local _,_,title=string.find(text,"|h%[(.-)%]|h")
  return title
end

local function ResolveQuestID(link,text)
  if type(link)~="string" then return nil end

  local _,_,id=string.find(link,"^quest:(%d+)")
  id=tonumber(id)
  if id and id>0 then return id end

  -- Older pfQuest/Turtle link formats can carry only a title (quest2:*).
  -- Resolve those by exact localized title, matching pfQuest's old behavior.
  local isQuest2=string.find(link,"^quest2:")
  if not isQuest2 then return nil end
  local wanted=LinkTitle(text)
  if not wanted or not QuestieOcto.DatabaseAPI or not QuestieOcto.DatabaseAPI:IsReady() then return nil end
  local ids=QuestieOcto.DatabaseAPI:GetQuestIDs()
  for i=1,table.getn(ids) do
    local questID=tonumber(ids[i])
    if questID and QuestieOcto.DatabaseAPI:GetQuestTitle(questID)==wanted then return questID end
  end
  return nil
end

local function IsQuestLink(link)
  if type(link)~="string" then return false end
  if string.find(link,"^quest:") then return true end
  if string.find(link,"^quest2:") then return true end
  return false
end

local function AnyModifierDown()
  if IsShiftKeyDown and IsShiftKeyDown() then return true end
  if IsControlKeyDown and IsControlKeyDown() then return true end
  if IsAltKeyDown and IsAltKeyDown() then return true end
  return false
end

local function DifficultyColor(level,questID)
  if QuestieOcto.GetNativeQuestDifficultyColor then
    local r,g,b=QuestieOcto:GetNativeQuestDifficultyColor(level,questID)
    if r then return r,g,b end
  end
  return 1,1,0
end

local function ClampByte(value)
  value=tonumber(value) or 0
  if value<0 then value=0 elseif value>1 then value=1 end
  return math.floor(value*255+0.5)
end

local function DifficultyHex(level,questID)
  local r,g,b=DifficultyColor(level,questID)
  return string.format("|cff%02x%02x%02x",ClampByte(r),ClampByte(g),ClampByte(b))
end

function Q:BuildQuestLink(questID,title,level)
  questID=tonumber(questID)
  if not questID or questID<=0 then return nil end

  level=tonumber(level) or 0
  if not title or title=="" then
    if QuestieOcto.DatabaseAPI and QuestieOcto.DatabaseAPI:IsReady() then
      title=QuestieOcto.DatabaseAPI:GetQuestTitle(questID)
    end
  end
  if not title or title=="" then title="Quest "..tostring(questID) end

  return DifficultyHex(level,questID).."|Hquest:"..tostring(questID)..":"..tostring(level).."|h["..tostring(title).."]|h|r"
end

function Q:InsertQuestLink(questID,title,level)
  if not ChatFrameEditBox or not ChatFrameEditBox.IsVisible or not ChatFrameEditBox:IsVisible() then return false end
  local link=self:BuildQuestLink(questID,title,level)
  if not link then return false end
  ChatFrameEditBox:Insert(link)
  return true
end

local function QuestStatus(questID)
  local active=QuestieOcto.QuestLog and QuestieOcto.QuestLog.active and QuestieOcto.QuestLog.active[questID]
  if active then return "active" end
  local completed=QuestieOcto.Completion and QuestieOcto.Completion.history and QuestieOcto.Completion.history[questID]
  if completed then return "completed" end
  local available=QuestieOcto.AvailableQuests and QuestieOcto.AvailableQuests.available and QuestieOcto.AvailableQuests.available[questID]
  if available then return "available" end
  return "unavailable"
end

local function AddStatusLine(tooltip,status)
  if status=="active" then
    tooltip:AddLine("You are on this quest.",1,1,0.5)
  elseif status=="completed" then
    tooltip:AddLine("You already completed this quest.",0.5,1,0.5)
  elseif status=="available" then
    tooltip:AddLine("This quest is available.",0.3,1,0.3)
  else
    tooltip:AddLine("You don't have this quest.",1,0.5,0.5)
  end
end

local function AddLevelLine(tooltip,label,level,questID)
  level=tonumber(level)
  if not level or level<=0 then return end
  local r,g,b=DifficultyColor(level,questID)
  tooltip:AddLine(label..": "..tostring(level),r,g,b)
end

function Q:ShowQuest(questID,text)
  questID=tonumber(questID)
  if not questID or questID<=0 or not ItemRefTooltip then return false end
  if not QuestieOcto.QuestModel then return false end

  local quest=QuestieOcto.QuestModel:Get(questID)
  if not quest then return false end

  local signature="quest:"..tostring(questID)
  if ItemRefTooltip:IsShown() and self.lastQuestLink==signature then
    if HideUIPanel then HideUIPanel(ItemRefTooltip) else ItemRefTooltip:Hide() end
    self.lastQuestLink=nil
    return true
  end

  if ItemRefTooltip.ClearLines then ItemRefTooltip:ClearLines() end
  if ShowUIPanel then ShowUIPanel(ItemRefTooltip) end
  if ItemRefTooltip.SetOwner then ItemRefTooltip:SetOwner(UIParent,"ANCHOR_PRESERVE") end

  local title=quest.title or LinkTitle(text) or ("Quest "..tostring(questID))
  local r,g,b=DifficultyColor(quest.level,questID)
  ItemRefTooltip:AddLine(title,r,g,b)
  AddStatusLine(ItemRefTooltip,QuestStatus(questID))

  local objective=FormatQuestText(quest.objectiveText)
  local description=FormatQuestText(quest.descriptionText)
  if objective then
    ItemRefTooltip:AddLine(" ",0,0,0)
    ItemRefTooltip:AddLine(objective,1,1,1,true)
  end
  if description then
    ItemRefTooltip:AddLine(" ",0,0,0)
    ItemRefTooltip:AddLine(description,0.8,0.8,0.8,true)
  end

  if (quest.requiredLevel and tonumber(quest.requiredLevel)>0) or (quest.level and tonumber(quest.level)>0) then
    ItemRefTooltip:AddLine(" ",0,0,0)
    AddLevelLine(ItemRefTooltip,"Required Level",quest.requiredLevel,questID)
    AddLevelLine(ItemRefTooltip,"Quest Level",quest.level,questID)
  end

  if Settings() and Settings().Get and Settings():Get("enableTooltipsQuestID") then
    ItemRefTooltip:AddLine("Quest ID: "..tostring(questID),0.65,0.65,0.65)
  end

  ItemRefTooltip:Show()
  self.lastQuestLink=signature
  return true
end

function Q:HandleSetItemRef(link,text,button)
  -- Quest Log Shift+click-to-chat is handled by TrackerDriver before a link
  -- exists. Once a hyperlink is clicked in chat, keep modifier-click behavior
  -- available to Blizzard/other addons rather than replacing it here.
  if AnyModifierDown() then return false end

  -- Normal left- or right-click opens quest details, matching pfQuest's
  -- Vanilla behavior. Modifier clicks were already returned above.
  if button and button~="LeftButton" and button~="RightButton" then return false end

  if IsQuestLink(link) then
    local questID=ResolveQuestID(link,text)
    if questID and Q:ShowQuest(questID,text) then return true end
  else
    -- A normal item/player/etc. hyperlink replaces ItemRefTooltip ownership.
    -- Forget the previous quest signature so returning to that quest does not
    -- incorrectly look like a second click on an already-open quest tooltip.
    Q.lastQuestLink=nil
  end
  return false
end

function Q:InstallHook()
  if self.hooked or type(SetItemRef)~="function" then return end

  -- Prefer an additive post-hook. This lets Blizzard, pfUI and other addons
  -- keep ownership of their SetItemRef chain while Questie-Octo replaces only
  -- the final quest-link presentation. It also avoids cutting off wrappers
  -- installed before us. The current Turtle/ClassicAPI environment exposes
  -- hooksecurefunc; retain the old forwarding wrapper only as a compatibility
  -- fallback for clients where it is unavailable.
  if type(hooksecurefunc)=="function" then
    hooksecurefunc("SetItemRef",function(link,text,button)
      Q:HandleSetItemRef(link,text,button)
    end)
    self.hookMode="post"
    self.hooked=true
    return
  end

  local original=SetItemRef
  self.originalSetItemRef=original

  SetItemRef=function(link,text,button)
    if Q:HandleSetItemRef(link,text,button) then return end
    return original(link,text,button)
  end

  self.hookMode="wrapper"
  self.hooked=true
end

function Q:Start()
  if self.started then return end
  self.started=true
  self:InstallHook()
end

QuestieOcto:RegisterMessage("FOUNDATION_READY",Q,"Start")
