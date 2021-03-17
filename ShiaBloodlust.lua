-- Author      : Oldtimer
ShiaBL = LibStub("AceAddon-3.0"):NewAddon("ShiaBL", "AceConsole-3.0", "AceEvent-3.0")

--[[
todo: check buff only on player


--]]



local soundEnabled = true
local textureEnabled = true
local lustFrame
local optionsFrame
local ag




local triggerAuras = { 
	"Frost Armor",
	"Fireball"
	--add more trigger spells here
}


local options = {
	name = "Shia Labeouf Bloodlust",
	handler = ShiaBL,
	type = "group",
		args = {
			firstHeader = {
				order = 0,
				type = "header",
				name = "Mute Sound & Texture",
				width = "half"
			},
			soundEnabled = {
				order = 1,
				name = "Mute Sound",
				desc = "Mute sounds",
				type = "toggle",
				width = "full",
				set = function(info, val) soundEnabled = val end,
				get = function(info) return soundEnabled end
			},
			textureEnabled = {
				order = 2,
				name = "Hide Texture",
				desc = "Do not show Shia image",
				type = "toggle",
				width = "full",
				set = function(info, val) textureEnabled = val end,
				get = function(info) return textureEnabled end
			},
			auraHeader = {
				order = 3,
				type = "header",
				name = "Trigger Auras",
				width = "half"
			},
			aurasToggle = {
				order = 4,
				type = "group",
				name = "Auras",
				desc = "toggle spell aruas",
				args = {
					frostArmor = {
						order = 0,
						name = "Frost Armor",
						desc = "Trigger on Frost Armor",
						type = "toggle",
						width = "full",
						set = function(info, val) soundEnabled = val end,
						get = function(info) return soundEnabled end
					},
					fireball = {
						order = 1,
						name = "Fireball",
						desc = "Trigger on Frost Armor",
						type = "toggle",
						width = "full",
						set = function(info, val) soundEnabled = val end,
						get = function(info) return soundEnabled end
					},
				},
			}, 
		},		
}

function ShiaBL:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("ShiaBL", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ShiaBL") --, "ShiaBL")
	self:RegisterChatCommand("shiabl", "ChatCommand")
	self:RegisterChatCommand("sbl", "ChatCommand")
	self:RegisterChatCommand("shia", "ChatCommand")
	--ShiaBLDB = LibStub("AceAddon-3.0"):NewAddon("ShiaBLDB")

	--create frame
	if lustFrame == nil then 
		ShiaBL:CreateLustFrame()
	end

end

function ShiaBL:ChatCommand(input)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):Open("ShiaBL")
end

function ShiaBL:OnEnable()

	ShiaBL:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "ShiaBL_OnEvent")

	
end

function ShiaBL:OnDisable()
    -- Called when the addon is disabled
	ag:Stop()
	lustFrame:Hide()
end


function ShiaBL:ShiaBL_OnEvent()

	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _, spellName, _, auraType = CombatLogGetCurrentEventInfo()
	
	print(subevent)

	
	if subevent == "SPELL_AURA_APPLIED" and tContains(triggerAuras, spellName) then
		lustFrame:Show()
		print(spellName .. " applied.")
		--PlaySoundFile("Interface\\AddOns\\ShiaBloodlust\\media\\ShiaSound.ogg")
		ag:Play()
	end
	if subevent == "SPELL_AURA_REMOVED" and tContains(triggerAuras, spellName) then
		print(spellName .. " removed.")
		ag:Stop()
		lustFrame:Hide()
	end
end

function ShiaBL:CreateLustFrame()

	lustFrame = CreateFrame("Frame", "LustFrame", UIParent)
	lustFrame:SetHeight(128)
	lustFrame:SetWidth(128)
	lustFrame:SetPoint("TOP", UIParent)
	
	lustFrame:SetMovable(true)
	lustFrame:EnableMouse(true)
	lustFrame:SetUserPlaced(true)
	lustFrame:RegisterForDrag("LeftButton", "Alt")
	lustFrame:SetScript("OnDragStart", function(self) if IsAltKeyDown() then self:StartMoving() end end)
	lustFrame:SetScript("OnDragStop", lustFrame.StopMovingOrSizing)
	lustFrame:SetClampedToScreen(true)

	local t = lustFrame:CreateTexture(nil,"BACKGROUND")
	t:SetTexture("Interface\\AddOns\\ShiaBloodlust\\media\\ShiaTexture.tga")
	t:SetAlpha(1)
	t:SetAllPoints(lustFrame)
	lustFrame.texture = t
	
	-- animation groups
	ag = lustFrame:CreateAnimationGroup()
	ag:SetLooping("BOUNCE")
	local a1 = ag:CreateAnimation("Alpha")
	a1:SetFromAlpha(0)
	a1:SetToAlpha(1)
	a1:SetDuration(0.5)
	a1:SetSmoothing("OUT")
	lustFrame:Hide()
end