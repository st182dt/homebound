local _, db = ...
local HORDE_ICON_TEXTURE = "Interface\\AddOns\\HomeBound\\Assets\\horde"
local ALLIANCE_ICON_TEXTURE = "Interface\\AddOns\\HomeBound\\Assets\\alliance"

hb_settings = hb_settings or { scale = 1.0, hideCompleted = false, completedAchievs = {}, completedQuest = {}, showMinimapButton = true, filters = { achievement = true, quest = true, neutral = true, alliance = true, horde = true } }
dbHB = {minimap = {hide = false}}

local activeWidgets = {}
local collapsedHeaders = {}
local LibDBIcon = LibStub("LibDBIcon-1.0", true)
local minimapButton
local questTitleCache = {}
local currentFaction = 1
local currentTab = "decor"

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

--Check if quest is complete
local function IsQuestComplete(questID)
  if not questID then return false end
  
  if type(questID) == "table" then
    for _, id in ipairs(questID) do
      if IsQuestComplete(id) then return true end
    end
    return false
  end

  if hb_settings.completedQuest[questID] then return true end

  local completed = C_QuestLog.IsQuestFlaggedCompletedOnAccount(questID)
  if completed then
    hb_settings.completedQuest[questID] = true
  end
  return completed
end

--Generic completion check
local function IsRewardComplete(reward)
    if currentTab == "vendors" then 
        return false
    end
    
    if reward.type == "quest" then
        return IsQuestComplete(reward.id)
    else --Default to achievement
        return IsAchievementComplete(reward.id)
    end
end

--Get faction
local function GetRewardFaction(reward)
    if not reward.icon then
        return "neutral"
    elseif reward.icon == ALLIANCE_ICON_TEXTURE then
        return "alliance"
    elseif reward.icon == HORDE_ICON_TEXTURE then
        return "horde"
    else
        return "neutral"
    end
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
frame:SetFrameStrata("HIGH")
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

local vendorPopup = CreateFrame("Frame", "HB_VendorPopup", UIParent, "BackdropTemplate")
vendorPopup:SetSize(350, 100) 
vendorPopup:SetPoint("CENTER")
vendorPopup:SetFrameStrata("DIALOG")
vendorPopup:Hide()

vendorPopup:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
vendorPopup:SetBackdropColor(0.1, 0.1, 0.1, 1)
vendorPopup:SetBackdropBorderColor(0.64, 0.64, 0.64, 1)

local popupGradient = vendorPopup:CreateTexture(nil, "BACKGROUND")
popupGradient:SetPoint("TOPLEFT", 4, -4)
popupGradient:SetPoint("BOTTOMRIGHT", -4, 4)
popupGradient:SetColorTexture(1, 1, 1, 1)
popupGradient:SetGradient("VERTICAL", CreateColor(0.12, 0.12, 0.12, 1), CreateColor(0.05, 0.05, 0.05, 1))

local vendorPopupTitle = vendorPopup:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
vendorPopupTitle:SetPoint("TOP", 0, -12)
vendorPopupTitle:SetText("Vendor Items")
vendorPopupTitle:SetTextColor(1, 0.82, 0)

local titleSeparator = vendorPopup:CreateTexture(nil, "ARTWORK")
titleSeparator:SetHeight(2)
titleSeparator:SetColorTexture(0.4, 0.4, 0.4, 0.8)
titleSeparator:SetPoint("TOPLEFT", 10, -36)
titleSeparator:SetPoint("TOPRIGHT", -10, -36)

local vendorPopupCloseBtn = CreateFrame("Button", nil, vendorPopup, "UIPanelCloseButton")
vendorPopupCloseBtn:SetPoint("TOPRIGHT", 0, 0)
vendorPopupCloseBtn:SetSize(30, 30)
vendorPopupCloseBtn:SetScript("OnClick", function() vendorPopup:Hide() end)

vendorPopup:EnableMouse(true)
vendorPopup:SetMovable(true)
vendorPopup:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" then
    self:StartMoving()
  end
end)
vendorPopup:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" then
    self:StopMovingOrSizing()
  end
end)

local vendorIconCache = {} 
local function ShowVendorPopup(npcID, vendorName)
    if not npcID or not db.vendorItems or not db.vendorItems[npcID] then 
        print("HomeBound: No items found for this vendor in database.")
        return
    end

    local items = db.vendorItems[npcID]
    vendorPopupTitle:SetText((vendorName or "Vendor") .. " sells:")
    
    --Hide all existing item frames
    for _, frame in pairs(vendorIconCache) do
        frame:Hide()
    end

    local tileSize = 50
    local margin = 12 
    local columns = 6
    local startX = 25
    local startY = -48

    local row = 0
    local col = 0

    for i, itemID in ipairs(items) do
        local itemFrame = vendorIconCache[i]
        
        if not itemFrame then
            itemFrame = CreateFrame("Frame", nil, vendorPopup, "BackdropTemplate")
            itemFrame:SetSize(tileSize, tileSize)
            itemFrame:SetClipsChildren(true) 
            
            itemFrame:SetBackdrop({
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = 2, 
            })
            itemFrame:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)

            local btn = CreateFrame("Button", nil, itemFrame)
            btn:SetAllPoints(itemFrame)

            local glow = btn:CreateTexture(nil, "BACKGROUND")
            glow:SetPoint("TOPLEFT", -2, 2)
            glow:SetPoint("BOTTOMRIGHT", 2, -2)
            glow:SetColorTexture(0, 0, 0, 0.5)
            btn.glow = glow

            local icon = btn:CreateTexture(nil, "ARTWORK")
            icon:SetPoint("TOPLEFT", 2, -2)
            icon:SetPoint("BOTTOMRIGHT", -2, 2)
            icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            btn.icon = icon

            btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
            btn:GetHighlightTexture():SetBlendMode("ADD")
            btn:GetHighlightTexture():SetAllPoints(icon)
            
            itemFrame.btn = btn

            table.insert(vendorIconCache, itemFrame)
        end

        col = (i - 1) % columns
        row = math.floor((i - 1) / columns)
        
        itemFrame:SetPoint("TOPLEFT", vendorPopup, "TOPLEFT", startX + (col * (tileSize + margin)), startY - (row * (tileSize + margin)))
        
        --Update the button data
        local btn = itemFrame.btn
        local texture = GetItemIcon(itemID)
        btn.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
        
        btn:SetScript("OnEnter", function(self)
            SetCursor("INSPECT_CURSOR")
            itemFrame:SetBackdropBorderColor(1, 0.82, 0, 1)
            self.glow:SetColorTexture(1, 0.82, 0, 0.2)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. itemID)
            GameTooltip:Show()
        end)
        
        btn:SetScript("OnLeave", function(self)
            ResetCursor()
            itemFrame:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
            self.glow:SetColorTexture(0, 0, 0, 0.5)
            GameTooltip:Hide()
        end)
        
        btn:SetScript("OnClick", function()
            DressUpItemLink("item:" .. itemID)
        end)

        itemFrame:Show()
    end

    local totalRows = math.floor((#items - 1) / columns) + 1
    local totalHeight = math.abs(startY) + (totalRows * (tileSize + margin)) + 4
    local totalWidth = (startX * 2) + (columns * (tileSize + margin)) - margin

    vendorPopup:SetSize(totalWidth, totalHeight)
    vendorPopup:SetScale(hb_settings.scale or 1.0) 
    vendorPopup:Show()
end

--Temporary WIP message
local wipPopupFirstTime = true
local wipPopup = CreateFrame("Frame", nil, frame, "BackdropTemplate")
wipPopup:SetSize(248, 30)
wipPopup:SetPoint("BOTTOM", frame, "BOTTOM", 0, 50)
wipPopup:SetFrameStrata("DIALOG")
wipPopup:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = false, edgeSize = 12,
  insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
wipPopup:SetBackdropColor(0, 0, 0, 0.95)
wipPopup:SetBackdropBorderColor(1, 0.82, 0, 0.8)
wipPopup:Hide()

local wipText = wipPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
wipText:SetPoint("CENTER", 0, 0)
wipText:SetText("The Vendors tab is a work in progress.")
wipText:SetTextColor(1, 1, 1)

wipPopup:EnableMouse(true)
wipPopup:SetScript("OnMouseDown", function(self) self:Hide() end)

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
previewTitle:SetFont(STANDARD_TEXT_FONT, 15)
previewTitle:SetPoint("TOP", 0, -12)
previewTitle:SetText("Decor Reward")
previewTitle:SetWidth(280)
previewTitle:SetTextColor(1, 0.82, 0)

previewFrame.currentReward = nil
previewFrame.currentRewardIndex = 1
previewFrame.totalRewards = 0

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
  local posData = db.modelPositions[modelID]
  
  if posData then
    self:SetPosition(posData.model_x, 0, posData.model_z)
    self:SetCameraPosition(0, 0, posData.camera_y)
    self:SetCameraDistance(posData.zoom)
  else --Default
    self:SetPosition(0, 0, 0)
    self:SetCameraPosition(0, 0, 4)
    self:SetCameraDistance(10)
  end
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

local wowheadPopup = CreateFrame("Frame", "HB_WowheadLinkFrame", UIParent, "BackdropTemplate")
wowheadPopup:SetSize(350, 90)
wowheadPopup:SetFrameStrata("DIALOG")
wowheadPopup:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  tile = true, tileSize = 32, edgeSize = 32,
  insets = { left = 8, right = 8, top = 8, bottom = 8 }
})

wowheadPopup:SetBackdropColor(0.1, 0.1, 0.1, 1)
wowheadPopup:SetPoint("CENTER")
wowheadPopup:EnableMouse(true)
wowheadPopup:SetMovable(true)
wowheadPopup:RegisterForDrag("LeftButton")
wowheadPopup:SetScript("OnDragStart", wowheadPopup.StartMoving)
wowheadPopup:SetScript("OnDragStop", wowheadPopup.StopMovingOrSizing)
wowheadPopup:Hide()

local wowheadPopupTitle = wowheadPopup:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
wowheadPopupTitle:SetPoint("TOP", 0, -14)
wowheadPopupTitle:SetText("Ctrl + C to copy")
wowheadPopupTitle:SetTextColor(1, 0.82, 0)

local wowheadPopupEditBox = CreateFrame("EditBox", nil, wowheadPopup, "InputBoxTemplate")
wowheadPopupEditBox:SetSize(300, 20)
wowheadPopupEditBox:SetPoint("CENTER", 0, -5)
wowheadPopupEditBox:SetAutoFocus(false)
wowheadPopupEditBox:SetScript("OnEscapePressed", function() wowheadPopup:Hide() end)

local wowheadPopupCloseBtn = CreateFrame("Button", nil, wowheadPopup, "UIPanelCloseButton")
wowheadPopupCloseBtn:SetPoint("TOPRIGHT", 2, 2)
wowheadPopupCloseBtn:SetSize(30, 30)
wowheadPopupCloseBtn:SetScript("OnClick", function() wowheadPopup:Hide() end)

local function ShowWowheadLinkPopup(id, rewardType)
  local url
  if rewardType == "quest" then
      url = "https://www.wowhead.com/quest=" .. tostring(id)
  else
      url = "https://www.wowhead.com/achievement=" .. tostring(id)
  end
  wowheadPopupEditBox:SetText(url)
  wowheadPopup:SetPoint("CENTER", UIParent, "CENTER")
  wowheadPopup:Show()
  wowheadPopupEditBox:SetFocus()
  wowheadPopupEditBox:HighlightText()
end

local supportFrame = CreateFrame("Frame", "HB_SupportFrame", UIParent, "BackdropTemplate")
supportFrame:SetSize(450, 224)
supportFrame:SetPoint("CENTER")
supportFrame:SetBackdrop({
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = false,
  edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
supportFrame:SetBackdropColor(0.02, 0.02, 0.02, 0.95)
supportFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
supportFrame:SetFrameStrata("DIALOG")
supportFrame:SetMovable(true)
supportFrame:EnableMouse(true)
supportFrame:Hide()

supportFrame:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" then self:StartMoving() end
end)
supportFrame:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" then self:StopMovingOrSizing() end
end)

local supportTitleBg = supportFrame:CreateTexture(nil, "BACKGROUND")
supportTitleBg:SetTexture("Interface\\Buttons\\WHITE8x8")
supportTitleBg:SetPoint("TOPLEFT", 4, -4)
supportTitleBg:SetPoint("TOPRIGHT", -4, -4)
supportTitleBg:SetHeight(40)
supportTitleBg:SetGradient("VERTICAL", CreateColor(0.15, 0.15, 0.15, 1), CreateColor(0.08, 0.08, 0.08, 1))

local supportTitle = supportFrame:CreateFontString(nil, "OVERLAY")
supportTitle:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
supportTitle:SetPoint("TOP", 0, -16)
supportTitle:SetText("Community & Support")
supportTitle:SetTextColor(1, 0.85, 0, 1)

local supportCloseBtn = CreateFrame("Button", nil, supportFrame, "UIPanelCloseButton")
supportCloseBtn:SetPoint("TOPRIGHT", -2, -2)
supportCloseBtn:SetSize(28, 28)

local discordText = supportFrame:CreateFontString(nil, "OVERLAY")
discordText:SetFont(STANDARD_TEXT_FONT, 13)
discordText:SetPoint("TOPLEFT", 20, -54)
discordText:SetText("Join the community on Discord!")
discordText:SetTextColor(0.9, 0.9, 0.9, 1)

local discordEditBox = CreateFrame("EditBox", nil, supportFrame, "InputBoxTemplate")
discordEditBox:SetSize(408, 20)
discordEditBox:SetPoint("TOPLEFT", 22, -74)
discordEditBox:SetAutoFocus(false)
discordEditBox:SetText("https://dsc.gg/homebound") 
discordEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
discordEditBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

local shareText = supportFrame:CreateFontString(nil, "OVERLAY")
shareText:SetFont(STANDARD_TEXT_FONT, 13)
shareText:SetPoint("TOPLEFT", 20, -110)
shareText:SetText("Share this addon with your friends!")
shareText:SetTextColor(0.9, 0.9, 0.9, 1)

local shareEditBox = CreateFrame("EditBox", nil, supportFrame, "InputBoxTemplate")
shareEditBox:SetSize(408, 20)
shareEditBox:SetPoint("TOPLEFT", 22, -130)
shareEditBox:SetAutoFocus(false)
shareEditBox:SetText("https://www.curseforge.com/wow/addons/home-bound")
shareEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
shareEditBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

local tipText = supportFrame:CreateFontString(nil, "OVERLAY")
tipText:SetFont(STANDARD_TEXT_FONT, 13)
tipText:SetPoint("TOPLEFT", 20, -166)
tipText:SetText("You can leave a tip if you like")
tipText:SetTextColor(0.9, 0.9, 0.9, 1)

local tipEditBox = CreateFrame("EditBox", nil, supportFrame, "InputBoxTemplate")
tipEditBox:SetSize(408, 20)
tipEditBox:SetPoint("TOPLEFT", 22, -186)
tipEditBox:SetAutoFocus(false)
tipEditBox:SetText("https://buymeacoffee.com/bettiold")
tipEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
tipEditBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

frame:SetScript("OnHide", function()
    if wowheadPopup and wowheadPopup:IsShown() then
        wowheadPopup:Hide()
    end
    if supportFrame and supportFrame:IsShown() then
        supportFrame:Hide()
    end
    if vendorPopup and vendorPopup:IsShown() then
        vendorPopup:Hide()
    end
end)

local titleBg = frame:CreateTexture(nil, "BACKGROUND")
titleBg:SetTexture("Interface\\Buttons\\WHITE8x8")
titleBg:SetPoint("TOPLEFT", 4, -4)
titleBg:SetPoint("TOPRIGHT", -4, -4)
titleBg:SetHeight(50)
titleBg:SetGradient("VERTICAL", CreateColor(0.15, 0.15, 0.15, 1), CreateColor(0.08, 0.08, 0.08, 1))

local title = frame:CreateFontString(nil, "OVERLAY")
title:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
title:SetPoint("TOP", 0, -14)
title:SetText("Home Bound")
title:SetTextColor(1, 0.85, 0, 1)

local subtitle = frame:CreateFontString(nil, "OVERLAY")
subtitle:SetFont(STANDARD_TEXT_FONT, 11)
subtitle:SetPoint("TOP", title, "BOTTOM", 0, -2)
subtitle:SetText("Track your Player Housing rewards")
subtitle:SetTextColor(0.7, 0.7, 0.7, 1)

--Info Icon
local infoIcon = CreateFrame("Button", nil, frame)
infoIcon:SetSize(24, 24)
infoIcon:SetPoint("TOPLEFT", 8, -8)
local iconTexture = infoIcon:CreateTexture(nil, "ARTWORK")
iconTexture:SetTexture("Interface\\BUTTONS\\UI-GuildButton-PublicNote-Up")
iconTexture:SetAllPoints(infoIcon)
infoIcon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")

infoIcon:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
  GameTooltip:AddLine("Home Bound Tips", 1, 0.82, 0)
  GameTooltip:AddLine("\nYou can right-click to get a Wowhead link.", 1, 1, 1, true)
  GameTooltip:AddLine("Left-click an achievement to open it in the achievement panel.", 1, 1, 1, true)
  GameTooltip:AddLine("\nFor accurate achievement completion data, log in to at least one Alliance and one Horde character.", 1, 1, 1, true)
  GameTooltip:Show()
end)

infoIcon:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)

--Support Icon
local supportIcon = CreateFrame("Button", nil, frame)
supportIcon:SetSize(24, 24)
supportIcon:SetPoint("LEFT", infoIcon, "RIGHT", 6, 0)
local supportIconTexture = supportIcon:CreateTexture(nil, "ARTWORK")
supportIconTexture:SetTexture("Interface\\AddOns\\HomeBound\\Assets\\discord")
supportIconTexture:SetAllPoints(supportIcon)
supportIcon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")

supportIcon:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
  GameTooltip:AddLine("Community & Support", 1, 0.82, 0)
  GameTooltip:AddLine("\nClick to share the addon!", 1, 1, 1, true)
  GameTooltip:Show()
end)

supportIcon:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)

supportIcon:SetScript("OnClick", function()
  supportFrame:Show()
end)

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -2, -2)
closeBtn:SetSize(28, 28)

--Tabs
local tabs = {}
local lastTab = nil

local function UpdateTabStyles()
    for _, t in pairs(tabs) do
        if t.id == string.lower(currentTab) or (t.text and string.lower(t.text) == currentTab) then
             t:SetBackdropColor(0.02, 0.02, 0.02, 1) 
             t:SetBackdropBorderColor(1, 0.82, 0, 1)
             t:SetFrameLevel(frame:GetFrameLevel() + 2)
        else
             t:SetBackdropColor(0.1, 0.1, 0.1, 1)
             t:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
             t:SetFrameLevel(frame:GetFrameLevel() + 1)
        end
    end
end

local function CreateBottomTab(id, text, iconPath)
    local tab = CreateFrame("Button", "HB_Tab_"..id, frame, "BackdropTemplate")
    tab:SetHeight(32)
    tab:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 15,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    
    local tabIcon = tab:CreateTexture(nil, "ARTWORK")
    tabIcon:SetSize(20, 20) 
    tabIcon:SetPoint("LEFT", 10, 0)
    tabIcon:SetTexture(iconPath)
    
    local tabText = tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    tabText:SetPoint("LEFT", tabIcon, "RIGHT", 6, 0)
    tabText:SetText(text)
    
    local textWidth = tabText:GetStringWidth()
    tab:SetWidth(10 + 20 + 6 + textWidth + 10)
    
    if not lastTab then
        tab:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 1) 
    else
        tab:SetPoint("LEFT", lastTab, "RIGHT", -1, 0)
    end
    lastTab = tab

    tab.id = string.lower(id)
    tab.text = text
    
    tab:SetScript("OnMouseDown", function(self)
        if currentTab ~= self.id then
             self:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", (self.text == "Decor" and 0 or (tabs[1]:GetWidth() - 1)), -1)
        end
    end)
    
    tab:SetScript("OnMouseUp", function(self)
        if currentTab ~= self.id then
             self:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", (self.text == "Decor" and 0 or (tabs[1]:GetWidth() - 1)), 1)
        end
    end)
    
    tab:SetScript("OnClick", function()
        currentTab = string.lower(id)
        UpdateTabStyles()
        BuildUI()

        if currentTab == "vendors" and wipPopupFirstTime then
            wipPopup:Show()
            wipPopupFirstTime = false
            C_Timer.After(4, function() wipPopup:Hide() end)
        end
    end)
    
    table.insert(tabs, tab)
    return tab
end

--Create tabs
local tabDecor = CreateBottomTab("Decor", "Decor", "Interface\\Icons\\INV_Crate_03")
local tabVendors = CreateBottomTab("Vendors", "Vendors", "Interface\\Icons\\INV_Misc_Bag_10")
UpdateTabStyles()

--Filters dropdown
local filterButton = CreateFrame("DropdownButton", "HB_FilterButton", frame, "WowStyle1FilterDropdownTemplate")
filterButton:SetSize(120, 24)
filterButton:SetPoint("TOPLEFT", 10, -60)
filterButton:SetText("Filters")
filterButton.Text:ClearAllPoints()
filterButton.Text:SetPoint("CENTER")

filterButton:SetupMenu(function(dropdown, rootDescription)
    rootDescription:CreateCheckbox("Hide Completed", function() return hb_settings.hideCompleted end, function() hb_settings.hideCompleted = not hb_settings.hideCompleted; BuildUI() end)
    rootDescription:CreateDivider()
    
    if currentTab == "decor" then
        rootDescription:CreateCheckbox("Achievements", function() return hb_settings.filters.achievement end, function() hb_settings.filters.achievement = not hb_settings.filters.achievement; BuildUI() end)
        rootDescription:CreateCheckbox("Quests", function() return hb_settings.filters.quest end, function() hb_settings.filters.quest = not hb_settings.filters.quest; BuildUI() end)
        rootDescription:CreateDivider()
    end
    
    --Faction filter
    local factionMenu = rootDescription:CreateButton("Faction")
    factionMenu:CreateCheckbox("Neutral", function() return hb_settings.filters.neutral end, function() hb_settings.filters.neutral = not hb_settings.filters.neutral; BuildUI() end)
    factionMenu:CreateCheckbox("Alliance", function() return hb_settings.filters.alliance end, function() hb_settings.filters.alliance = not hb_settings.filters.alliance; BuildUI() end)
    factionMenu:CreateCheckbox("Horde", function() return hb_settings.filters.horde end, function() hb_settings.filters.horde = not hb_settings.filters.horde; BuildUI() end)
    
    rootDescription:CreateDivider()
    rootDescription:CreateButton("Reset Filters", function() hb_settings.filters.achievement = true; hb_settings.filters.quest = true; hb_settings.filters.neutral = true; hb_settings.filters.alliance = true; hb_settings.filters.horde = true; BuildUI() end)
end)

local minimapCheckbox = CreateFrame("CheckButton", "HB_MinimapCheckbox", frame, "UICheckButtonTemplate")
minimapCheckbox:SetPoint("TOPLEFT", filterButton, "TOPRIGHT", 10, 0)
minimapCheckbox:SetSize(26, 26)
local minimapCheckboxText = minimapCheckbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
minimapCheckboxText:SetPoint("LEFT", minimapCheckbox, "RIGHT", 2, 0)
minimapCheckboxText:SetText("Minimap Button")

minimapCheckbox:SetScript("OnClick", function(self)
  if LibDBIcon then
    if hb_settings.showMinimapButton then
      LibDBIcon:Hide("HomeBound")
      hb_settings.showMinimapButton = false
    else
      LibDBIcon:Show("HomeBound")
      hb_settings.showMinimapButton = true
    end
  end
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
  supportFrame:SetScale(roundedValue)
  vendorPopup:SetScale(roundedValue)
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

local function CreateHeader(parent, group, visibleRewards, y)
  local total, completed = 0, 0
  for _, reward in ipairs(visibleRewards) do
    total = total + 1
    if IsRewardComplete(reward) then
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
  icon:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
  icon:SetPoint("LEFT", 8, 0)
  icon:SetText(collapsed and "+" or "−")
  icon:SetTextColor(0.8, 0.8, 0.8, 1)

  local text = header:CreateFontString(nil, "OVERLAY")
  text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
  text:SetPoint("LEFT", 28, 0)
  text:SetText(group.name)
  text:SetTextColor(1, 1, 1, 1)

  local progress = header:CreateFontString(nil, "OVERLAY")
  progress:SetFont(STANDARD_TEXT_FONT, 11)
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

local function UpdatePreviewDisplay()
    if not previewFrame.currentReward or not previewFrame:IsShown() then return end

    local reward = previewFrame.currentReward
    local index = previewFrame.currentRewardIndex

    --Update Title
    local titleText = (type(reward.title) == "table") and reward.title[index] or reward.title or "Decor Reward"
    previewTitle:SetText(titleText)

    --Update Model or Texture
    local hasPreview = false
    if reward.model3D then
        local modelId = (type(reward.model3D) == "table") and reward.model3D[index] or reward.model3D
        if modelId then
            previewFrame.model:Show(); previewFrame.texture:Hide()
            previewFrame.model:SetModel(modelId)
            rotation = 0; hasPreview = true
        end
    elseif reward.texture then
        local textureId = (type(reward.texture) == "table") and reward.texture[index] or reward.texture
        if textureId and textureId ~= "" then
            previewFrame.model:Hide(); previewFrame.texture:Show()
            local fullTexturePath = GetFullTexturePath(tostring(textureId))
            if fullTexturePath then
                previewFrame.texture:SetTexture(fullTexturePath)
                hasPreview = true
            end
        end
    end
    if not hasPreview then previewFrame:Hide() end
end

--Cycle through multiple rewards
local function CycleReward(direction) --direction is 1 for next, -1 for prev
    if not previewFrame:IsShown() or previewFrame.totalRewards <= 1 then return end

    local newIndex = previewFrame.currentRewardIndex + direction
    if newIndex > previewFrame.totalRewards then newIndex = 1 end
    if newIndex < 1 then newIndex = previewFrame.totalRewards end

    previewFrame.currentRewardIndex = newIndex
    UpdatePreviewDisplay()
end

--Create vendor line
local function CreateVendorLine(parent, vendor, y)
    local line = CreateFrame("Button", nil, parent)
    line:SetPoint("TOPLEFT", 10, y)
    line:SetSize(590, 22)
    line:RegisterForClicks("AnyUp")

    local collectedDot = line:CreateTexture(nil, "OVERLAY")
    collectedDot:SetSize(32, 32); collectedDot:SetScale(0.3); collectedDot:SetPoint("LEFT", 0, 0)
    
    --Temporary
    collectedDot:SetTexture("Interface\\AddOns\\HomeBound\\Assets\\progress")
    
    local text = line:CreateFontString(nil, "OVERLAY")
    text:SetFont(STANDARD_TEXT_FONT, 12); text:SetPoint("LEFT", 20, 0); text:SetJustifyH("LEFT")
    text:SetText(vendor.title or "Unknown NPC")
    text:SetTextColor(0.9, 0.9, 0.9, 1)

    --Icon
    if vendor.icon then
        local specialIcon = line:CreateTexture(nil, "OVERLAY")
        specialIcon:SetSize(22, 22)
        specialIcon:SetPoint("LEFT", text, "RIGHT", 16, 0)
        specialIcon:SetTexture(vendor.icon)
    end

    local mapText = line:CreateFontString(nil, "OVERLAY")
    mapText:SetFont(STANDARD_TEXT_FONT, 11); mapText:SetPoint("RIGHT", -10, 0)
    
    local mapName = "Unknown Zone"
    if vendor.mapID then
        local mapInfo = C_Map.GetMapInfo(vendor.mapID)
        if mapInfo and mapInfo.name then
            mapName = mapInfo.name
        end
    end
    mapText:SetText(mapName)
    mapText:SetTextColor(0.7, 0.7, 0.7)

    line:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")

    line:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(vendor.title, 1, 1, 1)
        if vendor.mapID then 
            GameTooltip:AddLine(mapName, 1, 0.82, 0) 
        end
        GameTooltip:AddLine("\n|cff00ff00<Left Click>|r to open Vendor Items", 1, 1, 1)
        GameTooltip:AddLine("|cff00ff00<Right Click>|r to add Map Pin", 1, 1, 1)
        GameTooltip:Show()
    end)
    
    line:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
             ShowVendorPopup(vendor.id, vendor.title)
        elseif button == "RightButton" then
            if InCombatLockdown() then
                return
            end

            local targetMapID = vendor.mapIDWaypoint or vendor.mapID
            if targetMapID and vendor.x and vendor.y then
                local waypoint = UiMapPoint.CreateFromCoordinates(targetMapID, vendor.x / 100, vendor.y / 100)
                C_Map.SetUserWaypoint(waypoint)
                C_SuperTrack.SetSuperTrackedUserWaypoint(true)
                C_Map.OpenWorldMap(vendor.mapID)
            end
        end
    end)

    line:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    table.insert(activeWidgets, line)
    return y - 24
end

--Create reward line
local function CreateRewardLine(parent, reward, y)
  local primaryID = reward.id
  
  if type(reward.id) == "table" then
    primaryID = reward.id[currentFaction]
  end

  local displayName
  local isQuestLoading = false
  
  if reward.type == "quest" then
      displayName = questTitleCache[primaryID] or C_QuestLog.GetTitleForQuestID(primaryID)
      if displayName then questTitleCache[primaryID] = displayName else displayName = "Loading Quest..."; isQuestLoading = true end
  else
      local _, name = GetAchievementInfo(primaryID)
      displayName = name or "Unknown Achievement"
  end

  local isComplete = IsRewardComplete(reward)
  if hb_settings.hideCompleted and isComplete then return y end

  local line = CreateFrame("Button", nil, parent)
  line:SetPoint("TOPLEFT", 10, y)
  line:SetSize(590, 22)
  line:RegisterForClicks("AnyUp")

  local collectedDot = line:CreateTexture(nil, "OVERLAY")
  collectedDot:SetSize(32, 32); collectedDot:SetScale(0.3); collectedDot:SetPoint("LEFT", 0, 0)
  
  local text = line:CreateFontString(nil, "OVERLAY")
  text:SetFont(STANDARD_TEXT_FONT, 12); text:SetPoint("LEFT", 20, 0); text:SetJustifyH("LEFT"); text:SetText(displayName)

  if isQuestLoading then
      QuestEventListener:AddCallback(primaryID, function()
          local newName = C_QuestLog.GetTitleForQuestID(primaryID)
          if newName and text:IsVisible() then text:SetText(newName); questTitleCache[primaryID] = newName
          elseif text:IsVisible() then text:SetText("Unknown Quest") end
      end)
  end

  if isComplete then
    text:SetTextColor(0.5, 0.5, 0.5, 1); collectedDot:SetTexture("Interface\\AddOns\\HomeBound\\Assets\\collected")
  else
    text:SetTextColor(0.9, 0.9, 0.9, 1); collectedDot:SetTexture("Interface\\AddOns\\HomeBound\\Assets\\progress")
  end
  
  --Special icon
  if reward.icon then
    local specialIcon = line:CreateTexture(nil, "OVERLAY")
    specialIcon:SetSize(22, 22)
    specialIcon:SetPoint("LEFT", text, "RIGHT", 16, 0)
    specialIcon:SetTexture(reward.icon)
  end

  local typeText = line:CreateFontString(nil, "OVERLAY")
  typeText:SetFont(STANDARD_TEXT_FONT, 11); typeText:SetPoint("RIGHT", -10, 0)
  local rewardTypeString = reward.type and (reward.type:sub(1,1):upper() .. reward.type:sub(2)) or "Achievement"
  typeText:SetText(rewardTypeString); typeText:SetTextColor(0.7, 0.7, 0.7)

  line:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")

  --Clickable /Next/ button for multiple rewards
  local nextButton = CreateFrame("Button", nil, line)
  nextButton:SetPoint("RIGHT", typeText, "LEFT", -8, 0)
  nextButton:SetSize(48, 22)
  nextButton:Hide()

  local nextButtonText = nextButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  nextButtonText:SetAllPoints()
  nextButtonText:SetFont(STANDARD_TEXT_FONT, 12)
  nextButtonText:SetText("(Next)")
  nextButton:SetPropagateMouseMotion(true)
  local defaultNextColor = {1, 0.82, 0}
  nextButtonText:SetTextColor(unpack(defaultNextColor))

  nextButton:SetScript("OnEnter", function() nextButtonText:SetTextColor(1, 1, 1) end)
  nextButton:SetScript("OnLeave", function() nextButtonText:SetTextColor(unpack(defaultNextColor)) end)
  nextButton:SetScript("OnClick", function() CycleReward(1) end)

  line:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
      if reward.type ~= "quest" then
        if not AchievementFrame then AchievementFrame_LoadUI() end
        if not AchievementFrame:IsShown() then AchievementFrame_ToggleAchievementFrame() end
        AchievementFrame_SelectAchievement(primaryID)
      end
    elseif button == "RightButton" then
      ShowWowheadLinkPopup(primaryID, reward.type)
    end
  end)

  line:SetScript("OnEnter", function(self)
    if not isComplete then text:SetTextColor(1, 0.82, 0, 1) end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    if reward.type == "quest" then GameTooltip:SetHyperlink("quest:" .. primaryID) else GameTooltip:SetHyperlink(GetAchievementLink(primaryID)) end
    GameTooltip:Show()

    previewFrame.currentReward = reward
    previewFrame.currentRewardIndex = 1
    
    local rewardsTable = reward.model3D or reward.texture
    if type(rewardsTable) == "table" then
        previewFrame.totalRewards = #rewardsTable
    else
        previewFrame.totalRewards = (rewardsTable ~= nil and rewardsTable ~= "") and 1 or 0
    end

    if previewFrame.totalRewards > 1 then
        nextButton:Show()
    end
    
    if previewFrame.totalRewards > 0 then
        previewFrame:ClearAllPoints()
        local tooltipBottomY = GameTooltip:GetBottom()
        local previewScaledHeight = previewFrame:GetHeight() * previewFrame:GetEffectiveScale()
        if tooltipBottomY and (tooltipBottomY - previewScaledHeight - 30 < 0) then
            previewFrame:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 0, 5)
        else
            previewFrame:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -5)
        end
        previewFrame:Show()
        UpdatePreviewDisplay()
    end
  end)

  line:SetScript("OnLeave", function(self)
    if isComplete then text:SetTextColor(0.5, 0.5, 0.5, 1) else text:SetTextColor(0.9, 0.9, 0.9, 1) end
    GameTooltip:Hide()
    previewFrame:Hide()
    previewFrame.model:Hide()
    previewFrame.texture:Hide()
    previewFrame.currentReward = nil
    nextButton:Hide()
  end)

  table.insert(activeWidgets, line)
  return y - 24
end

--Create UI
function BuildUI()
  ClearWidgets()
  local y = 0
  local hasContent = false
  
  local dataSource = (currentTab == "vendors") and db.vendors or db.collections
  
  if not dataSource then return end

  for _, group in ipairs(dataSource) do
      local visibleRewards = {}
      
      local items = (currentTab == "vendors") and group.npcs or group.achievements
      
      if items then
          for _, item in ipairs(items) do
              local rewardFaction = GetRewardFaction(item)
              local showItem = true
              
              --Apply Faction Filters
              local factionMatch = (rewardFaction == "neutral" and hb_settings.filters.neutral) or 
                                  (rewardFaction == "alliance" and hb_settings.filters.alliance) or 
                                  (rewardFaction == "horde" and hb_settings.filters.horde)
                                  
              if not factionMatch then showItem = false end
              
              --Apply Type Filters (Only for Decor)
              if currentTab == "decor" then
                  local rewardType = item.type or "achievement"
                  local typeMatch = (rewardType == "quest" and hb_settings.filters.quest) or (rewardType == "achievement" and hb_settings.filters.achievement)
                  if not typeMatch then showItem = false end
              end
              
              --Apply Hide Completed Filter
              if hb_settings.hideCompleted and IsRewardComplete(item) then
                  showItem = false
              end
              
              if showItem then
                  table.insert(visibleRewards, item)
              end
          end
      end
      
      if #visibleRewards > 0 then
          local allInCategoryComplete = true
          
          for _, reward in ipairs(visibleRewards) do
              if not IsRewardComplete(reward) then allInCategoryComplete = false; break end
          end

          hasContent = true
          local header, collapsed, newY = CreateHeader(scrollChild, group, visibleRewards, y)
          y = newY
          if not collapsed then
              local original_y = y
              for _, item in ipairs(visibleRewards) do 
                  if currentTab == "vendors" then
                    y = CreateVendorLine(scrollChild, item, y)
                  else
                    y = CreateRewardLine(scrollChild, item, y) 
                  end
              end
              if y < original_y then y = y - 10 end
          end
      end
  end
  if not hasContent then
    local msg = scrollChild:CreateFontString(nil, "OVERLAY")
    msg:SetFont(STANDARD_TEXT_FONT, 14); msg:SetPoint("TOP", 0, -50)
    msg:SetText("You've collected everything!\nTry changing your filters.")
    msg:SetTextColor(0.9, 0.9, 0.9, 1); table.insert(activeWidgets, msg)
  end
  scrollChild:SetHeight(math.abs(y) + 20)
end

--Initialize
local init = CreateFrame("Frame")
init:RegisterEvent("ADDON_LOADED")
init:RegisterEvent("PLAYER_ENTERING_WORLD")
init:RegisterEvent("ACHIEVEMENT_EARNED")
init:RegisterEvent("QUEST_TURNED_IN")

init:SetScript("OnEvent", function(self, event, addon)
  if event == "ADDON_LOADED" and addon == "HomeBound" then    
    hb_settings.completedAchievs = hb_settings.completedAchievs or {}
    hb_settings.completedQuest = hb_settings.completedQuest or {}
    hb_settings.showMinimapButton = hb_settings.showMinimapButton == nil and true or hb_settings.showMinimapButton
    hb_settings.filters = hb_settings.filters or { achievement = true, quest = true, neutral = true, alliance = true, horde = true }

    if hb_settings.filters.neutral == nil then hb_settings.filters.neutral = true end
    if hb_settings.filters.alliance == nil then hb_settings.filters.alliance = true end
    if hb_settings.filters.horde == nil then hb_settings.filters.horde = true end
    
    minimapCheckbox:SetChecked(hb_settings.showMinimapButton)
    if not AchievementFrame then AchievementFrame_LoadUI() end
    local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
    if ldb then
      local dataobj = ldb:NewDataObject("HomeBound", { type = "launcher", icon = 7252953, label = "HomeBound", text = "HomeBound", name = "HomeBound",
        OnClick = function(_, button)
          if button == "LeftButton" then
            if not frame:IsShown() then BuildUI() end
            frame:SetShown(not frame:IsShown())
          end
        end
      })
      function dataobj:OnTooltipShow() self:AddLine("|cffffffffHome Bound|r"); self:AddLine("|cff00ff00<Left Click to toggle>"); self:SetScale(GameTooltip:GetScale()) end
      LibDBIcon:Register("HomeBound", dataobj, dbHB.minimap)
    end
  elseif event == "PLAYER_ENTERING_WORLD" then
    if UnitFactionGroup("player") == "Horde" then currentFaction = 2 end

    local scale = hb_settings.scale or 1.0
    frame:SetScale(scale); supportFrame:SetScale(scale); scaleSlider:SetValue(scale)
    scaleValueText:SetText(string.format("UI Scale: %.2f", scale))
    vendorPopup:SetScale(scale)
    BuildUI()
    if not hb_settings.showMinimapButton then LibDBIcon:Hide("HomeBound") end
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  elseif event == "ACHIEVEMENT_EARNED" or event == "QUEST_TURNED_IN" then
    C_Timer.After(0.5, BuildUI)
  end
end)

--Slash commands
SLASH_HB1 = "/hb"
SLASH_HB2 = "/homebound"
SlashCmdList["HB"] = function()
  if not frame:IsShown() then BuildUI() end
  frame:SetShown(not frame:IsShown())
end