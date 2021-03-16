-- Author      : Oldtimer
ShiaBL = LibStub("AceAddon-3.0"):NewAddon("ShiaBL", "AceConsole-3.0")





local ignoreSound = false

local options = {
  name = "Shia Labeouf Bloodlust - by OldTimer",
  handler = ShiaBL,
  type ="group",
  args = {
    MuteSound = {
      name = "Mute Sound",
      desc = "Mute sound while keeping texture animation",
      type = "toggle",
      width = "full",
      set = function(info, val) ignoreSound = val end,
      get = function(info) return ignoreSound end
    },
  },
}

function ShiaBL:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("ShiaBL", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ShiaBL", "ShiaBL")
	self:RegisterChatCommand("shiabl", "ChatCommand")
	self:RegisterChatCommand("sbl", "ChatCommand")
	self:RegisterChatCommand("shia", "ChatCommand")
	ShiaBLDB = LibStub("AceAddon-3.0"):NewAddon("ShiaBLDB")

end

function ShiaBL:OnEnable()
	--register events
	eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	eventFrame:SetScript("OnEvent", function (f, self, event)
		ShiaBL:ShiaBL_OnEvent(self, event, CombatLogGetCurrentEventInfo())
	end)
	
end

function ShiaBL:OnDisable()
    -- Called when the addon is disabled
end

function ShiaBL:ChatCommand(input)
  if not input or input:trim() == "" then
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
  else
    LibStub("AceConfigCmd-3.0"):HandleCommand("sbl", "shiabl", "shia", input)
  end
end

function ShiaBL:ShiaBL_OnEvent(self, event, ...)

	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	_, spellName, _, auraType = select(12, ...)
	print(subevent)
	
	if subevent ~= "SPELL_AURA_APPLIED" or spellName ~= "Frost Armor" then
		return
	end
	local f = ShiaBL:CreateLustFrame()
	local ag, _ = f:GetAnimationGroups()
	f:Show()
	PlaySoundFile("Interface\\AddOns\\ShiaBloodlust\\media\\ShiaSound.ogg")
	ag:Play()
	
end

function ShiaBL:CreateLustFrame()

	local f = CreateFrame("Frame", "LustFrame", UIParent)
	f:SetHeight(128)
	f:SetWidth(128)
	f:SetPoint("TOP", UIParent)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetUserPlaced(true)
	f:RegisterForDrag("LeftButton", "Alt")
	f:SetScript("OnDragStart", function(self) if IsAltKeyDown() then self:StartMoving() end end)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:SetClampedToScreen(true)

	local t = f:CreateTexture(nil,"BACKGROUND")
	t:SetTexture("Interface\\AddOns\\ShiaBloodlust\\media\\ShiaTexture.tga")
	t:SetAlpha(1)
	t:SetAllPoints(f)
	f.texture = t
	
	-- animation groups
	local ag = f:CreateAnimationGroup()
	ag:SetLooping("BOUNCE")
	local a1 = ag:CreateAnimation("Alpha")
	a1:SetFromAlpha(0)
	a1:SetToAlpha(1)
	a1:SetDuration(0.5)
	a1:SetSmoothing("OUT")
	f:Hide()

	return f
end