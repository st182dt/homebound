local HORDE_ICON_TEXTURE = "Interface\\AddOns\\HomeBound\\Assets\\horde"
local ALLIANCE_ICON_TEXTURE = "Interface\\AddOns\\HomeBound\\Assets\\alliance"

local modelPositions = {
  [660974] = { model_x = 0.00, model_z = 4.60, camera_y = 10.20, zoom = 20.0 },
  [577102] = { model_x = 0.00, model_z = 0.00, camera_y = 5.40, zoom = 12.7 },
  [1108752] = { model_x = 0.00, model_z = 0.00, camera_y = 3.60, zoom = 8.7 },
  [1402222] = { model_x = 0.00, model_z = 0.00, camera_y = 2.00, zoom = 3.8 },
  [1349622] = { model_x = 0.00, model_z = 0.60, camera_y = 2.60, zoom = 5.7 },
  [1095305] = { model_x = 0.00, model_z = 0.10, camera_y = 0.00, zoom = 2.2 },
  [1361683] = { model_x = 0.00, model_z = 0.70, camera_y = 7.20, zoom = 10.3 },
  [1319084] = { model_x = 0.00, model_z = 0.10, camera_y = 1.20, zoom = 1.6 },
  [999909] = { model_x = 0.00, model_z = 0.05, camera_y = 1.30, zoom = 2.7 },
  [2745098] = { model_x = 0.00, model_z = 0.50, camera_y = 6.75, zoom = 15.4 },
  [2068146] = { model_x = 0.00, model_z = 0.15, camera_y = 2.30, zoom = 4.4 },
  [1842466] = { model_x = 0.00, model_z = 0.05, camera_y = 1.55, zoom = 2.5 },
  [668138] = { model_x = 0.00, model_z = -0.10, camera_y = 2.30, zoom = 5.5 },
  [2620664] = { model_x = 0.00, model_z = 0.40, camera_y = 7.00, zoom = 4.0 },
  [2432865] = { model_x = 0.00, model_z = 0.10, camera_y = 5.90, zoom = 12.0 },
  [1597477] = { model_x = 0.00, model_z = 0.10, camera_y = 2.70, zoom = 5.8 },
  [1922339] = { model_x = 0.00, model_z = 0.05, camera_y = 0.90, zoom = 2.3 },
  [2481224] = { model_x = 0.00, model_z = 1.55, camera_y = 15.00, zoom = 25.0 },
  [2341255] = { model_x = 0.00, model_z = 0.02, camera_y = 1.80, zoom = 3.3 },
  [2341251] = { model_x = 0.00, model_z = 0.05, camera_y = 1.80, zoom = 3.1 },
  [2351848] = { model_x = 0.00, model_z = 0.25, camera_y = 2.30, zoom = 5.8 },
  [3883455] = { model_x = 0.00, model_z = -0.25, camera_y = 3.60, zoom = 5.5 },
  [3886996] = { model_x = 0.00, model_z = -0.22, camera_y = 5.60, zoom = 9.4 },
  [304638] = { model_x = 0.00, model_z = 0.10, camera_y = 1.80, zoom = 3.3 },
  [5389584] = { model_x = 0.00, model_z = 0.30, camera_y = 3.70, zoom = 7.0 },
  [4904552] = { model_x = 0.00, model_z = 0.30, camera_y = 3.80, zoom = 7.7 },
  [4906427] = { model_x = 0.00, model_z = 3.30, camera_y = 6.50, zoom = 6.8 },
  [5788117] = { model_x = 0.00, model_z = 1.30, camera_y = 12.00, zoom = 17.0 },
  [5464689] = { model_x = 0.00, model_z = 0.00, camera_y = 1.30, zoom = 1.7 },
  [5007024] = { model_x = 0.00, model_z = 0.05, camera_y = 2.60, zoom = 3.7 },
  [5933736] = { model_x = 0.00, model_z = 0.60, camera_y = 9.80, zoom = 17.4 },
  [200273] = { model_x = 0.00, model_z = 0.30, camera_y = 7.80, zoom = 13.4 },
  [200281] = { model_x = 0.00, model_z = 0.65, camera_y = 7.80, zoom = 12.1 },
  [200268] = { model_x = 0.00, model_z = 0.40, camera_y = 6.40, zoom = 10.2 },
  [200276] = { model_x = 0.00, model_z = 0.65, camera_y = 6.40, zoom = 10.8 },
  [304027] = { model_x = 0.00, model_z = -0.20, camera_y = 5.75, zoom = 9.7 },
  [5278833] = { model_x = 0.00, model_z = 0.16, camera_y = 6.50, zoom = 13.1 },
  [5770750] = { model_x = 0.00, model_z = 1.20, camera_y = 5.00, zoom = 9.5 },
  [200283] = { model_x = 0.00, model_z = -0.10, camera_y = 6.40, zoom = 10.2 },
  [200301] = { model_x = 0.00, model_z = 0.30, camera_y = 0.00, zoom = 4.4 },
  [2353835] = { model_x = 0.00, model_z = 5.10, camera_y = 6.25, zoom = 10.7 },
  [2353834] = { model_x = 0.00, model_z = 4.95, camera_y = 6.25, zoom = 10.2 },
  [199687] = { model_x = 0.00, model_z = 4.60, camera_y = 9.05, zoom = 9.6 },
  [414219] = { model_x = 0.00, model_z = 0.40, camera_y = 10.00, zoom = 25.0 },
  [2490319] = { model_x = 0.00, model_z = 0.00, camera_y = 1.70, zoom = 5.0 },
  [2490318] = { model_x = 0.00, model_z = -0.10, camera_y = 1.70, zoom = 4.5 },
  [5916218] = { model_x = 0.00, model_z = 0.00, camera_y = 1.00, zoom = 4.7 },
  [5916220] = { model_x = 0.00, model_z = 0.00, camera_y = 1.70, zoom = 2.3 },
  [1354768] = { model_x = 0.00, model_z = 0.00, camera_y = 0.90, zoom = 1.7 },
  [1018949] = { model_x = 0.00, model_z = 0.80, camera_y = 4.85, zoom = 8.3 },
  [4896167] = { model_x = 0.00, model_z = 0.40, camera_y = 8.15, zoom = 20.0 },
  [965917] = { model_x = 0.00, model_z = 0.15, camera_y = 1.00, zoom = 4.8 },
  [1696757] = { model_x = 0.00, model_z = 3.10, camera_y = 8.70, zoom = 14.0 },
}

local collections = {
  {
    name = "Eastern Kingdoms",
    achievements = {
      { id = 940, texture = "7423955", title = "Nesingwary Elk Trophy" },
      { id = 5442, model3D = 660974, title = "Goldshire Food Cart" },
    }
  },
  {
    name = "Wrath of the Lich King",
    achievements = {
      { id = 4405, texture = "7421869", title = "Head of the Broodmother" },
      { id = 938, texture = "7423951", title = "Nesingwary Shoveltusk Trophy" },
    }
  },
  {
    name = "Mists of Pandaria",
    achievements = {
      { id = 7322, model3D = 577102, title = "Kun-Lai Lacquered Rickshaw" },
      { id = 8316, texture = "3879", title = "Shadowforge Stone Chair" },
    }
  },
  {
    name = "Legion",
    achievements = {
      { id = 10698, model3D = 1108752, title = "Shala'nir Feather Bed" },
      { id = 11124, texture = "7416149", title = "\"Night on the Jeweled Estate\" Painting" },
      { id = 11257, model3D = 1402222, title = "Skyhorn Storage Chest" },
      { id = 11258, model3D = 1349622, title = "Kaldorei Treasure Trove" },
      { id = 10398, texture = "7421600", title = "Skyhorn Arrow Kite" },
      { id = 11699, model3D = 1095305, title = "Murloc's Wind Chimes" },
      { id = 11340, model3D = 1361683, title = "Deluxe Suramar Sleeper" },
      { id = 10996, model3D = 1319084, title = "Tauren Jeweler's Roller" },
    }
  },
  {
    name = "Battle for Azeroth",
    achievements = {
      { id = 13723, model3D = 999909, title = "Gnomish T.O.O.L.B.O.X." },
      { id = 13018, texture = "7417181", title = "Zandalari Wall Shelf" },
      { id = 13473, model3D = 2745098, title = "Redundant Reclamation Rig" },
      { id = 13475, model3D = 2068146, title = "Gnomish Cog Stack" },
      { id = 13477, model3D = 1842466, title = "Screw-Sealed Stembarrel" },
      { id = 12582, texture = "7421917", title = "Old Salt's Fireplace", icon = ALLIANCE_ICON_TEXTURE },
      { id = 12997, texture = "7424987", title = "Proudmoore Green Drape", icon = ALLIANCE_ICON_TEXTURE },
      { id = 13049, texture = "7424983", title = "Tiragarde Treasure Chest", icon = ALLIANCE_ICON_TEXTURE },
      { id = 12479, model3D = 668138, title = "Grand Mask of Bwonsamdi, Loa of Graves", icon = HORDE_ICON_TEXTURE },
      { id = 12509, model3D = 2620664, title = "Lordaeron Rectangular Rug", icon = HORDE_ICON_TEXTURE },
      { id = 12614, model3D = 2432865, title = "Golden Loa's Altar", icon = HORDE_ICON_TEXTURE },
      { id = 13038, model3D = 1597477, title = "Bookcase of Gonk", icon = HORDE_ICON_TEXTURE },
      { id = 13039, model3D = 1922339, title = "Idol of Pa'ku, Master of Winds", icon = HORDE_ICON_TEXTURE },
      { id = 13284, model3D = 2481224, title = "Large Forsaken War Tent", icon = HORDE_ICON_TEXTURE },
      { id = 12867, model3D = 2341255, title = "Lordaeron Banded Barrel", icon = HORDE_ICON_TEXTURE },
      { id = 12869, model3D = 2341251, title = "Lordaeron Banded Crate", icon = HORDE_ICON_TEXTURE },
      { id = 12870, model3D = 2351848, title = "Lordaeron Spiked Weapon Rack", icon = HORDE_ICON_TEXTURE },
    }
  },
  {
    name = "Dragonflight",
    achievements = {
      { id = 17529, texture = "7423851", title = "Dragon's Hoard Chest" },
      { id = 17773, model3D = 3883455, title = "Pentagonal Stone Table" },
      { id = 19507, model3D = 3886996, title = "Valdrakken Sconce" },
      { id = 19719, model3D = 304638, title = "Gilnean Celebration Keg" },
    }
  },
  {
    name = "The War Within",
    achievements = {
      { id = 20595, model3D = 5389584, title = "Boulder Springs Recliner" },
      { id = 40504, model3D = 4904552, title = "Rambleshire Resting Platform" },
      { id = 40859, model3D = 4906427, title = "Dornogal Brazier" },
      { id = 40894, model3D = 5788117, title = "Rocket-Powered Fountain" },
      { id = 41186, model3D = 5464689, title = "Tome of Earthen Directives" },
      { id = 40542, model3D = 5007024, title = "Kaheti Scribe's Records" },
      { id = 41119, model3D = 5933736, title = "Gallagio L.U.C.K. Spinner" },
    }
  },
  {
    name = "PvP",
    achievements = {
      { id = 221, model3D = 200273, title = "Fortified Alliance Banner" },
      { id = 222, model3D = 200281, title = "Fortified Horde Banner" },
      { id = 158, model3D = 200268, title = "Alliance Battlefield Banner" },
      { id = 1153, model3D = 200276, title = "Horde Battlefield Banner" },
      { id = 5245, model3D = 304027, title = "Smoke Lamppost" },
      { id = 40210, model3D = 5278833, title = "Earthen Contender's Target" },
      { id = 40612, model3D = 5770750, title = "Deephaul Crystal" },
      { id = 212, model3D = 200283, title = "Uncontested Battlefield Banner" },
      { id = 213, model3D = 200301, title = "Netherstorm Battlefield Flag" },
      { id = 229, model3D = 2353835, title = "Horde Dueling Flag" },
      { id = 231, model3D = 2353834, title = "Alliance Dueling Flag" },
      { id = 1157, model3D = 199687, title = "Challenger's Dueling Flag" },
      { id = 6981, texture = "7423255", title = "Kotmogu Orb of Power, Kotmogu Pedestal" },
      { id = 5223, model3D = 414219, title = "Iron Dragonmaw Gate" },
      { id = 167, model3D = 2490319, title = "Warsong Outriders Flag" },
      { id = 200, model3D = 2490318, title = "Silverwing Sentinels Flag" },
    }
  },
  {
    name = "Meta Achievements",
    achievements = {
      { id = 40953, texture = "7423186", title = "MOTHER's Titanic Brazier, N'Zoth's Captured Eye" },
      { id = 20501, texture = "7423627", title = "Portal to Damnation" },
      { id = 19458, texture = "7423623", title = "The Great Hoard" },
    }
  },
  {
    name = "Lorewalking",
    achievements = {
      { id = 42187, model3D = 5916218, title = "Scroll of K'aresh's Fall" },
      { id = 42188, model3D = 5916220, title = "Tome of the Survivor" },
      { id = 42189, model3D = 1354768, title = "Tale of the Penultimate Lich King" },
    }
  },
  {
    name = "Professions",
    achievements = {
      { id = 4859, model3D = 1018949, title = "Dark Iron Brazier" },
      { id = 19408, model3D = 4896167, title = "Fallside Storage Tent" },
      { id = 9415, model3D = 965917, title = "Glorious Pendant of Rukhmar" },
      { id = 12746, texture = "7417177", title = "Zuldazar Cook's Griddle", icon = HORDE_ICON_TEXTURE },
      { id = 12733, model3D = 1696757, title = "Dazar'alor Forge", icon = HORDE_ICON_TEXTURE },
    }
  },
}


hb_settings = hb_settings or { scale = 1.0, hideCompleted = false, completedAchievs = {} }
local activeWidgets = {}
local collapsedHeaders = {}

--Check if achievement is complete
local function IsAchievementComplete(achievementID)
  if not achievementID then return false end

  if type(achievementID) == "table" then
    for _, id in ipairs(achievementID) do
      if IsAchievementComplete(id) then return true end
    end
    return false
  end

  if hb_settings.completedAchievs[achievementID] then
    return true
  end

  local _, _, _, completed = GetAchievementInfo(achievementID)
  if completed then
    hb_settings.completedAchievs[achievementID] = true
  end
  return completed or false
end

local function GetFullTexturePath(texturePath)
  if texturePath and not string.match(texturePath, "[\\/]") then
    return "Interface\\AddOns\\HomeBound\\Assets\\" .. texturePath
  end
  return texturePath
end

local frame = CreateFrame("Frame", "HB_MainFrame", UIParent, "BackdropTemplate")
frame:SetSize(650, 500)
frame:SetPoint("CENTER")
frame:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = false,
  edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
frame:SetBackdropColor(0.02, 0.02, 0.02, 0.95)
frame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:Hide()

frame:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" then
    self:StartMoving()
  end
end)
frame:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" then
    self:StopMovingOrSizing()
  end
end)

--Create reusable frame for the texture
local previewFrame = CreateFrame("Frame", "HB_RewardFrame", UIParent, "BackdropTemplate")
previewFrame:SetSize(300, 330)
previewFrame:SetFrameStrata("TOOLTIP")
previewFrame:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = false, edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
previewFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.98)
previewFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
previewFrame:Hide()

local previewTitle = previewFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
previewTitle:SetFont("Fonts\\FRIZQT__.TTF", 15)
previewTitle:SetPoint("TOP", 0, -12)
previewTitle:SetText("Decor Reward")
previewTitle:SetWidth(280)
previewTitle:SetTextColor(1, 0.82, 0)

--Legacy 2D Texture
local previewTexture = previewFrame:CreateTexture(nil, "ARTWORK")
previewTexture:SetSize(288, 288)
previewTexture:SetPoint("BOTTOM", 0, 6)
previewTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
previewFrame.texture = previewTexture

--3D Model Frame
local previewModel = CreateFrame("PlayerModel", nil, previewFrame)
previewModel:SetSize(288, 288)
previewModel:SetPoint("BOTTOM", 0, 6)

previewModel:SetScript("OnModelLoaded", function(self)
  self:MakeCurrentCameraCustom()
  
  local modelID = self:GetModelFileID()
  local posData = modelPositions[modelID]

  self:SetPosition(posData.model_x, 0, posData.model_z)
  self:SetCameraPosition(0, 0, posData.camera_y)
  self:SetCameraDistance(posData.zoom)
end)
previewFrame.model = previewModel
previewModel:Hide()

local rotation = 0
local rotationSpeed = 0.5

previewFrame:SetScript("OnUpdate", function(self, elapsed)
  if self:IsShown() and self.model:IsShown() then
    rotation = rotation + (rotationSpeed * elapsed)
    if rotation >= (math.pi * 2) then
      rotation = rotation - (math.pi * 2)
    end
    self.model:SetFacing(rotation)
  end
end)

local titleBg = frame:CreateTexture(nil, "BACKGROUND")
titleBg:SetTexture("Interface\\Buttons\\WHITE8x8")
titleBg:SetPoint("TOPLEFT", 4, -4)
titleBg:SetPoint("TOPRIGHT", -4, -4)
titleBg:SetHeight(50)
titleBg:SetGradient("VERTICAL", CreateColor(0.15, 0.15, 0.15, 1), CreateColor(0.08, 0.08, 0.08, 1))

local title = frame:CreateFontString(nil, "OVERLAY")
title:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
title:SetPoint("TOP", 0, -14)
title:SetText("Home Bound")
title:SetTextColor(1, 0.85, 0, 1)

local subtitle = frame:CreateFontString(nil, "OVERLAY")
subtitle:SetFont("Fonts\\FRIZQT__.TTF", 11)
subtitle:SetPoint("TOP", title, "BOTTOM", 0, -2)
subtitle:SetText("Track your Player Housing rewards")
subtitle:SetTextColor(0.7, 0.7, 0.7, 1)

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -2, -2)
closeBtn:SetSize(28, 28)

-- Register frame to close on ESC key
tinsert(UISpecialFrames, "HB_MainFrame")

local toggleBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
toggleBtn:SetSize(140, 24)
toggleBtn:SetPoint("TOPLEFT", 10, -60)
toggleBtn:SetText("Hide Completed")

toggleBtn:SetScript("OnClick", function(self)
  hb_settings.hideCompleted = not hb_settings.hideCompleted
  if hb_settings.hideCompleted then
    self:SetText("Show Completed")
  else
    self:SetText("Hide Completed")
  end
  BuildUI()
end)

local scaleSlider = CreateFrame("Slider", "HB_ScaleSlider", frame, "UISliderTemplate")
scaleSlider:SetPropagateMouseMotion(true)
scaleSlider:SetWidth(150)
scaleSlider:SetHeight(22)
scaleSlider:SetMinMaxValues(0.5, 1.5)
scaleSlider:SetValueStep(0.05)
scaleSlider:SetPoint("TOPRIGHT", -120, -60)
scaleSlider:SetValue(hb_settings.scale or 1.0)

local scaleValueText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
scaleValueText:SetFont(STANDARD_TEXT_FONT, 14)
scaleValueText:SetPoint("TOPLEFT", scaleSlider, "TOPRIGHT", 8, -3)

scaleSlider:SetScript("OnValueChanged", function(_, value)
  local roundedValue = tonumber(string.format("%.2f", value))
  scaleValueText:SetText(string.format("UI Scale: %.2f", roundedValue))
end)

scaleSlider:SetScript("OnMouseUp", function(self)
  local value = self:GetValue()
  local roundedValue = tonumber(string.format("%.2f", value))
  hb_settings.scale = roundedValue
  frame:SetScale(roundedValue)
end)

scaleValueText:SetText(string.format("UI Scale: %.2f", hb_settings.scale or 1.0))
local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "ScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 12, -90)
scrollFrame:SetPoint("BOTTOMRIGHT", -32, 12)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(620, 1)
scrollFrame:SetScrollChild(scrollChild)
scrollFrame.ScrollBar:ClearAllPoints()
scrollFrame.ScrollBar:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", 15, -8)
scrollFrame.ScrollBar:SetHeight(385)

local function ClearWidgets()
  for _, widget in ipairs(activeWidgets) do
    widget:Hide()
  end
  wipe(activeWidgets)
end

local function CreateHeader(parent, group, y)
  local total, completed = 0, 0
  for _, ach in ipairs(group.achievements) do
    total = total + 1
    if IsAchievementComplete(ach.id) then
      completed = completed + 1
    end
  end

  if collapsedHeaders[group.name] == nil then
    collapsedHeaders[group.name] = true
  end

  local collapsed = collapsedHeaders[group.name]
  local percent = total > 0 and math.floor((completed / total) * 100) or 0

  local header = CreateFrame("Button", nil, parent)
  header:SetPoint("TOPLEFT", 0, y)
  header:SetSize(600, 32)

  local bg = header:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints()
  bg:SetTexture("Interface\\Buttons\\WHITE8x8")
  bg:SetGradient("HORIZONTAL", CreateColor(0.12, 0.12, 0.12, 0.8), CreateColor(0.08, 0.08, 0.08, 0.8))

  local icon = header:CreateFontString(nil, "OVERLAY")
  icon:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
  icon:SetPoint("LEFT", 8, 0)
  icon:SetText(collapsed and "+" or "−")
  icon:SetTextColor(0.8, 0.8, 0.8, 1)

  local text = header:CreateFontString(nil, "OVERLAY")
  text:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
  text:SetPoint("LEFT", 28, 0)
  text:SetText(group.name)
  text:SetTextColor(1, 1, 1, 1)

  local progress = header:CreateFontString(nil, "OVERLAY")
  progress:SetFont("Fonts\\FRIZQT__.TTF", 11)
  progress:SetPoint("RIGHT", -8, 0)

  local color
  if percent == 100 then
    color = CreateColor(0.2, 1, 0.2, 1)
  elseif percent >= 50 then
    color = CreateColor(1, 0.82, 0, 1)
  else
    color = CreateColor(0.9, 0.9, 0.9, 1)
  end

  progress:SetText(string.format("%d/%d (%d%%)", completed, total, percent))
  progress:SetTextColor(color:GetRGBA())

  header:SetScript("OnClick", function()
    collapsedHeaders[group.name] = not collapsed
    BuildUI()
  end)

  header:SetScript("OnEnter", function(self)
    bg:SetGradient("HORIZONTAL", CreateColor(0.18, 0.18, 0.18, 1), CreateColor(0.12, 0.12, 0.12, 1))
  end)

  header:SetScript("OnLeave", function(self)
    bg:SetGradient("HORIZONTAL", CreateColor(0.12, 0.12, 0.12, 0.8), CreateColor(0.08, 0.08, 0.08, 0.8))
  end)

  table.insert(activeWidgets, header)

  return header, collapsed, y - 36, (completed == total)
end

--Create achievement line
local function CreateAchievementLine(parent, ach, y)
  local primaryID = type(ach.id) == "table" and ach.id[1] or ach.id
  local _, name = GetAchievementInfo(primaryID)
  local displayName = name or "Unknown Achievement"
  local isComplete = IsAchievementComplete(ach.id)

  if hb_settings.hideCompleted and isComplete then return y end

  local line = CreateFrame("Button", nil, parent)
  line:SetPoint("TOPLEFT", 10, y)
  line:SetSize(590, 22)

  local collectedDot = line:CreateTexture(nil, "OVERLAY")
  collectedDot:SetSize(32, 32)
  collectedDot:SetScale(0.3)
  collectedDot:SetPoint("LEFT", 0, 0)

  local text = line:CreateFontString(nil, "OVERLAY")
  text:SetFont("Fonts\\FRIZQT__.TTF", 12)
  text:SetPoint("LEFT", 20, 0)
  text:SetJustifyH("LEFT")
  text:SetText(displayName)

  if isComplete then
    text:SetTextColor(0.5, 0.5, 0.5, 1)
    collectedDot:SetTexture("Interface\\AddOns\\HomeBound\\Assets\\collected")
  else
    text:SetTextColor(0.9, 0.9, 0.9, 1)
    collectedDot:SetTexture("Interface\\AddOns\\HomeBound\\Assets\\progress")
  end

  if ach.icon then
    local specialIcon = line:CreateTexture(nil, "OVERLAY")
    specialIcon:SetSize(22, 22)
    specialIcon:SetPoint("LEFT", text, "RIGHT", 16, 0)
    specialIcon:SetTexture(ach.icon)
  end

  line:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")

  line:SetScript("OnClick", function()
    if not AchievementFrame then AchievementFrame_LoadUI() end
    if not AchievementFrame:IsShown() then AchievementFrame_ToggleAchievementFrame() end
    AchievementFrame_SelectAchievement(primaryID)
  end)

  line:SetScript("OnEnter", function(self)
    if not isComplete then
      text:SetTextColor(1, 0.82, 0, 1)
    end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    local achievementLink = GetAchievementLink(primaryID)
    GameTooltip:SetHyperlink(achievementLink)
    GameTooltip:Show()

    local hasPreview = false
    
    --Try to load 3D model first
    if ach.model3D then
        previewFrame.model:Show()
        previewFrame.texture:Hide()
        
        previewFrame.model:SetModel(ach.model3D)
        
        rotation = 0
        hasPreview = true
    --Fallback to 2D texture
    elseif ach.texture and ach.texture ~= "" then
        previewFrame.model:Hide()
        previewFrame.texture:Show()
        
        local fullTexturePath = GetFullTexturePath(ach.texture)
        if fullTexturePath then
            previewFrame.texture:SetTexture(fullTexturePath)
            hasPreview = true
        end
    end

    if hasPreview then
        if ach.title then
            previewTitle:SetText(ach.title)
        else
            previewTitle:SetText("Decor Reward")
        end
        
        previewFrame:ClearAllPoints()
        local tooltipBottomY = GameTooltip:GetBottom()
        local previewScaledHeight = previewFrame:GetHeight() * previewFrame:GetEffectiveScale()
        
        if tooltipBottomY and (tooltipBottomY - previewScaledHeight - 30 < 0) then
            previewFrame:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 0, 5)
        else
            previewFrame:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -5)
        end
        
        previewFrame:Show()
    end
  end)

  line:SetScript("OnLeave", function(self)
    if isComplete then
      text:SetTextColor(0.5, 0.5, 0.5, 1)
    else
      text:SetTextColor(0.9, 0.9, 0.9, 1)
    end
    GameTooltip:Hide()
    previewFrame:Hide()
    previewFrame.model:Hide()
    previewFrame.texture:Hide()
  end)

  table.insert(activeWidgets, line)

  return y - 24
end

--Create UI
function BuildUI()
  ClearWidgets()

  local y = 0
  local hasContent = false

  for _, group in ipairs(collections) do
    local total, completed = 0, 0
    for _, ach in ipairs(group.achievements) do
      total = total + 1
      if IsAchievementComplete(ach.id) then
        completed = completed + 1
      end
    end

    local isFullyComplete = (completed == total)

    if not (hb_settings.hideCompleted and isFullyComplete) then
      hasContent = true
      local header, collapsed, newY, fullComplete = CreateHeader(scrollChild, group, y)
      y = newY

      if not collapsed then
        local original_y = y
        for _, ach in ipairs(group.achievements) do
          y = CreateAchievementLine(scrollChild, ach, y)
        end
        if y < original_y then
            y = y - 10
        end
      end
    end
  end

  if not hasContent then
    local msg = scrollChild:CreateFontString(nil, "OVERLAY")
    msg:SetFont("Fonts\\FRIZQT__.TTF", 14)
    msg:SetPoint("TOP", 0, -50)
    msg:SetText("All decor achievements completed!\nCongratulations!")
    msg:SetTextColor(0.2, 1, 0.2, 1)
    table.insert(activeWidgets, msg)
  end

  scrollChild:SetHeight(math.abs(y) + 20)
end

-- Initialize
local init = CreateFrame("Frame")
init:RegisterEvent("ADDON_LOADED")
init:RegisterEvent("PLAYER_ENTERING_WORLD")
init:RegisterEvent("ACHIEVEMENT_EARNED")

init:SetScript("OnEvent", function(self, event, addon)
  if event == "ADDON_LOADED" and addon == "HomeBound" then
    hb_settings.completedAchievs = hb_settings.completedAchievs or {}
    if not AchievementFrame then
      AchievementFrame_LoadUI()
    end
  elseif event == "PLAYER_ENTERING_WORLD" then
    local scale = hb_settings.scale or 1.0
    frame:SetScale(scale)
    scaleSlider:SetValue(scale)
    scaleValueText:SetText(string.format("UI Scale: %.2f", scale))

    if hb_settings.hideCompleted then
      toggleBtn:SetText("Show Completed")
    else
      toggleBtn:SetText("Hide Completed")
    end
    BuildUI()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  elseif event == "ACHIEVEMENT_EARNED" then
    C_Timer.After(0.5, BuildUI)
  end
end)

-- Slash command
SLASH_HB1 = "/hb"
SLASH_HB2 = "/homebound"
SlashCmdList["HB"] = function()
  if not frame:IsShown() then
    BuildUI()
  end
  frame:SetShown(not frame:IsShown())
end

-- Data Broker Support
local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
if ldb then
  local dataobj = ldb:NewDataObject("HomeBound", {
    type = "launcher",
    icon = 7252953,
    label = "HomeBound",
    text = "HomeBound",
    name = "HomeBound",
    OnClick = function(_, button)
      if button == "LeftButton" then
        if not frame:IsShown() then
          BuildUI()
        end
        frame:SetShown(not frame:IsShown())
      end
    end
  })

  function dataobj:OnTooltipShow()
    self:AddLine("|cffffffff" .. "Home Bound|r")
    self:AddLine("|cffffff00" .. "Left-Click|r to toggle the Home Bound window")
  end
end