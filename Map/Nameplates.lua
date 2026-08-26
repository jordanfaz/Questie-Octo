QuestieOcto.Nameplates = QuestieOcto.Nameplates or {}
local NP = QuestieOcto.Nameplates

--------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------

local ICON_SIZE = 16

-- Using Questie-Octo's own bundled Slay/Loot icons so nameplate icons match
-- the map/minimap objective icon style.
local SWORD_ICON = "Interface\\AddOns\\Questie-Octo\\Img\\slay.blp"
local BAG_ICON = "Interface\\AddOns\\Questie-Octo\\Img\\loot.blp"

local NAMEPLATE_BORDER = "Interface\\Tooltips\\Nameplate-Border"
local NAME_REGION_INDEX = 3

--------------------------------------------------------------------------
-- Per-character settings (self-contained, mirrors QuestLog.lua's
-- CollapsedHeaderDB pattern rather than reusing MinimapSettings, since this
-- module's toggle/scale/offset values have nothing to do with map/minimap).
--------------------------------------------------------------------------

-- x/y are an offset from the icon's default anchor: to the left of the
-- nameplate name (RIGHT of the icon pinned to LEFT of the nameplate),
-- matching retail WoW/Questie's nameplate icon placement.
local DEFAULTS = { enabled = true, scale = 1, x = -4, y = 0 }

local function SettingsDB()
  QuestieOctoDB = QuestieOctoDB or {}
  QuestieOctoDB.nameplates = QuestieOctoDB.nameplates or {}
  local db = QuestieOctoDB.nameplates
  for key, default in pairs(DEFAULTS) do
    if db[key] == nil then db[key] = default end
  end
  return db
end

function NP:IsEnabled()
  return SettingsDB().enabled and true or false
end

function NP:GetScale()
  return tonumber(SettingsDB().scale) or DEFAULTS.scale
end

function NP:GetOffset()
  local db = SettingsDB()
  return tonumber(db.x) or DEFAULTS.x, tonumber(db.y) or DEFAULTS.y
end

function NP:SetEnabled(value)
  value = value and true or false
  local db = SettingsDB()
  if db.enabled == value then return false end
  db.enabled = value
  if value then
    self:Start()
    self:RebuildIconMap()
    self:UpdateAllNameplates()
  else
    self:Stop()
    for frame in pairs(self.iconFrames or {}) do
      self:RemoveIconFrame(frame)
    end
  end
  return true
end

function NP:SetScale(value)
  value = tonumber(value)
  if not value then return false end
  local db = SettingsDB()
  if db.scale == value then return false end
  db.scale = value
  self:Redraw()
  return true
end

function NP:SetOffset(x, y)
  x = tonumber(x)
  y = tonumber(y)
  if not x or not y then return false end
  local db = SettingsDB()
  if db.x == x and db.y == y then return false end
  db.x = x
  db.y = y
  self:Redraw()
  return true
end

function NP:ResetPosition()
  local db = SettingsDB()
  db.scale, db.x, db.y = DEFAULTS.scale, DEFAULTS.x, DEFAULTS.y
  self:Redraw()
end

--------------------------------------------------------------------------
-- Icon map: which nameplate name should show which icon.
-- Built from QuestieOcto.Objectives.byQuest, which already resolves live
-- objective IDs to real creature/item names and tracks completion per row,
-- so there is no need to duplicate any quest-log/database parsing here.
--------------------------------------------------------------------------

NP.iconMap = {}

function NP:RebuildIconMap()
  local map = {}

  if QuestieOcto.DatabaseAPI and QuestieOcto.DatabaseAPI:IsReady() and QuestieOcto.Objectives then
    for _, resolved in pairs(QuestieOcto.Objectives.byQuest or {}) do
      -- Kill/slay objectives first ...
      for _, entry in pairs(resolved.creature or {}) do
        if not entry.complete then
          local name = QuestieOcto.DatabaseAPI:GetCreatureName(entry.id)
          if name and name ~= "" then
            map[name] = SWORD_ICON
          end
        end
      end

      -- ... then loot objectives, which can overwrite a kill icon on the same
      -- NPC with a loot icon. This matches the original pfQuest-turtle
      -- nameplate module's precedence (units pass, then items pass).
      for _, entry in pairs(resolved.item or {}) do
        if not entry.complete then
          for _, source in pairs(entry.sources or {}) do
            if source.kind == "creature" then
              local name = QuestieOcto.DatabaseAPI:GetCreatureName(source.id)
              if name and name ~= "" then
                map[name] = BAG_ICON
              end
            end
          end
        end
      end
    end
  end

  self.iconMap = map
  if self:IsEnabled() then
    self:UpdateAllNameplates()
  end
end

QuestieOcto:RegisterMessage("OBJECTIVES_READY", NP, "RebuildIconMap")
QuestieOcto:RegisterMessage("OBJECTIVES_CHANGED", NP, "RebuildIconMap")

--------------------------------------------------------------------------
-- Nameplate detection (generic Vanilla/Turtle nameplate-frame heuristics;
-- unrelated to any specific quest addon, kept close to the original).
--------------------------------------------------------------------------

local function IsNameplate(frame)
  if not frame then return false end

  if frame.UnitFrame or frame.extended or frame.aloftData or frame.kui then
    return true
  end

  if frame:GetObjectType() ~= "Button" then return false end

  local borderRegion = frame:GetRegions()
  if borderRegion and borderRegion.GetObjectType and borderRegion:GetObjectType() == "Texture" then
    local texture = borderRegion:GetTexture()
    if texture == NAMEPLATE_BORDER then
      return true
    end

    if texture == "" or texture == nil then
      local nameRegion = select(NAME_REGION_INDEX, frame:GetRegions())
      if nameRegion and nameRegion.GetObjectType and nameRegion:GetObjectType() == "FontString" then
        return true
      end
    end
  end

  return false
end

--------------------------------------------------------------------------
-- Icon frame pooling
--------------------------------------------------------------------------

NP.nameplateFrames = {}
NP.iconFrames = {}
NP.unusedIconFrames = {}
NP.frameCount = 0

function NP:GetIconFrame(nameplateFrame)
  if self.iconFrames[nameplateFrame] then
    return self.iconFrames[nameplateFrame]
  end

  if self.frameCount >= 300 then
    return nil
  end

  local frame = tremove(self.unusedIconFrames)

  if not frame then
    frame = CreateFrame("Frame")
    frame.Icon = frame:CreateTexture(nil, "ARTWORK")
    frame.Icon:SetAllPoints(frame)
    self.frameCount = self.frameCount + 1
  end

  local scale = self:GetScale()
  local x, y = self:GetOffset()

  frame:SetParent(nameplateFrame)
  frame:SetFrameStrata("HIGH")
  frame:SetFrameLevel(nameplateFrame:GetFrameLevel() + 5)
  frame:SetWidth(ICON_SIZE * scale)
  frame:SetHeight(ICON_SIZE * scale)
  frame:ClearAllPoints()
  frame:SetPoint("RIGHT", nameplateFrame, "LEFT", x, y)
  frame:EnableMouse(false)

  self.iconFrames[nameplateFrame] = frame
  return frame
end

function NP:RemoveIconFrame(nameplateFrame)
  local frame = self.iconFrames[nameplateFrame]
  if not frame then return end

  frame.Icon:SetTexture(nil)
  frame:Hide()
  frame.lastIcon = nil
  tinsert(self.unusedIconFrames, frame)
  self.iconFrames[nameplateFrame] = nil
end

function NP:OnNameplateShow(nameplateFrame)
  if not self:IsEnabled() then return end

  local nameText = self.nameplateFrames[nameplateFrame]
  if not nameText then return end

  local unitName = nameText:GetText()
  if not unitName then return end

  local icon = self.iconMap[unitName]

  if icon then
    local frame = self:GetIconFrame(nameplateFrame)
    if frame then
      if frame.lastIcon ~= icon then
        frame.Icon:SetTexture(icon)
        frame.lastIcon = icon
      end
      frame:Show()
    end
  else
    self:RemoveIconFrame(nameplateFrame)
  end
end

function NP:OnNameplateHide(nameplateFrame)
  self:RemoveIconFrame(nameplateFrame)
end

function NP:ScanWorldFrameChildren(...)
  local numFrames = select('#', ...)

  for i = 1, numFrames do
    local frame = select(i, ...)

    if frame and not self.nameplateFrames[frame] and IsNameplate(frame) then
      local nameText = select(NAME_REGION_INDEX, frame:GetRegions())
      if nameText and nameText:GetObjectType() == "FontString" then
        self.nameplateFrames[frame] = nameText

        frame:HookScript("OnShow", function() NP:OnNameplateShow(frame) end)
        frame:HookScript("OnHide", function() NP:OnNameplateHide(frame) end)

        if frame:IsShown() then
          self:OnNameplateShow(frame)
        end
      end
    end
  end
end

function NP:UpdateAllNameplates()
  for frame in pairs(self.nameplateFrames) do
    if frame:IsShown() then
      self:OnNameplateShow(frame)
    end
  end
end

function NP:Redraw()
  local scale = self:GetScale()
  local x, y = self:GetOffset()

  for nameplateFrame, iconFrame in pairs(self.iconFrames) do
    iconFrame:SetWidth(ICON_SIZE * scale)
    iconFrame:SetHeight(ICON_SIZE * scale)
    iconFrame:ClearAllPoints()
    iconFrame:SetPoint("RIGHT", nameplateFrame, "LEFT", x, y)
  end
end

--------------------------------------------------------------------------
-- Watcher
--------------------------------------------------------------------------

local lastNumChildren = 0
local SCAN_INTERVAL = 0.05

function NP:Start()
  if self.ticker then return end

  self.ticker = CreateFrame("Frame")
  self.ticker.elapsed = 0
  self.ticker:SetScript("OnUpdate", function()
    this.elapsed = (this.elapsed or 0) + arg1

    if this.elapsed >= SCAN_INTERVAL then
      local numChildren = WorldFrame:GetNumChildren()
      if numChildren ~= lastNumChildren then
        lastNumChildren = numChildren
        NP:ScanWorldFrameChildren(WorldFrame:GetChildren())
      end
      this.elapsed = 0
    end
  end)
end

function NP:Stop()
  if self.ticker then
    self.ticker:SetScript("OnUpdate", nil)
    self.ticker = nil
  end
end

--------------------------------------------------------------------------
-- Diagnostics
--------------------------------------------------------------------------

function NP:Status()
  local tracked = 0
  for _ in pairs(self.iconMap or {}) do tracked = tracked + 1 end
  local plates = 0
  for _ in pairs(self.nameplateFrames or {}) do plates = plates + 1 end
  local shown = 0
  for frame in pairs(self.iconFrames or {}) do
    if frame:IsShown() then shown = shown + 1 end
  end

  QuestieOcto:Print("Nameplates enabled="..tostring(self:IsEnabled())..
    " watcherRunning="..tostring(self.ticker ~= nil)..
    " iconsTracked="..tostring(tracked)..
    " nameplatesSeen="..tostring(plates)..
    " iconsShown="..tostring(shown))

  if tracked > 0 then
    local sample = 0
    for name, icon in pairs(self.iconMap) do
      QuestieOcto:Print("  "..name.." -> "..(icon == SWORD_ICON and "SWORD" or "BAG"))
      sample = sample + 1
      if sample >= 8 then break end
    end
  end
end

-- Hover the mouse directly over a nameplate's health bar/name, then run
-- /qo nameplates inspect. Reports whether the frame under the mouse is being
-- recognized as a nameplate at all, and whether its name matches iconMap.
function NP:Inspect()
  local focus = GetMouseFocus and GetMouseFocus()
  if not focus or focus == WorldFrame then
    QuestieOcto:Print("No frame under your mouse. Hover directly over a nameplate, then run /qo nameplates inspect")
    return
  end

  local frame = focus
  local depth = 0
  while frame and frame:GetParent() ~= WorldFrame and depth < 10 do
    frame = frame:GetParent()
    depth = depth + 1
  end

  QuestieOcto:Print("Inspecting frame under mouse (walked up "..depth.." parent(s))")
  QuestieOcto:Print("  ObjectType="..tostring(frame:GetObjectType()).." ParentIsWorldFrame="..tostring(frame:GetParent()==WorldFrame))
  QuestieOcto:Print("  IsNameplate()="..tostring(IsNameplate(frame)))
  QuestieOcto:Print("  AlreadyRegistered="..tostring(self.nameplateFrames[frame] ~= nil))

  local nameText = self.nameplateFrames[frame] or select(NAME_REGION_INDEX, frame:GetRegions())
  local name = nameText and nameText.GetText and nameText:GetText() or nil
  QuestieOcto:Print("  Name="..tostring(name))
  if name then
    QuestieOcto:Print("  In iconMap="..tostring(self.iconMap[name] ~= nil))
  end
end

--------------------------------------------------------------------------
-- Startup / lifecycle
--------------------------------------------------------------------------

function NP:OnFoundationReady()
  if self:IsEnabled() then
    self:Start()
    self:RebuildIconMap()
  end
end

QuestieOcto:RegisterMessage("FOUNDATION_READY", NP, "OnFoundationReady")

-- If FOUNDATION_READY already fired before this file loaded for some reason,
-- fall back to starting immediately when enabled.
if QuestieOcto.ready and NP:IsEnabled() then
  NP:Start()
  NP:RebuildIconMap()
end
