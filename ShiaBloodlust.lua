-- Author      : Oldtimer
Shiabl = LibStub("AceAddon-3.0"):NewAddon("Shiabl", "AceConsole-3.0", "AceEvent-3.0")


local lustFrame
local optionsFrame
local ag


-- local get and set options make life a tead easier

local defaults = {
	char = {
	fireballEnabled = true,
	frostAuraEnabled = true,
	soundEnabled = true,
	textureEnabled = true
	}
}


local triggerAuras = { 
	"Frost Armor",
	"Fireball"
	--add more trigger spells here
}




function Shiabl:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ShiaDB", defaults)
	
	local options = {
	name = "Shia Labeouf Bloodlust",
	handler = Shiabl,
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
				set = function(info, val) self.db.char.soundEnabled = val end,
				get = function(info) return self.db.char.soundEnabled end
			},
			textureEnabled = {
				order = 2,
				name = "Hide Texture",
				desc = "Do not show Shia image",
				type = "toggle",
				width = "full",
				set = function(info, val) self.db.char.textureEnabled = val end,
				get = function(info) return self.db.char.textureEnabled end
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
						set = function(info, val) self.db.char.frostAuraEnabled = val end,
						get = function(info) return self.db.char.frostAuraEnabled end
					},
					fireball = {
						order = 1,
						name = "Fireball",
						desc = "Trigger on Frost Armor",
						type = "toggle",
						width = "full",
						set = function(info, val) self.db.char.fireballEnabled = val end,
						get = function(info) return self.db.char.fireballEnabled end
					},
				},
			}, 
		},		
}

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Shiabl", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Shiabl") --, "Shiabl")
	self:RegisterChatCommand("shiabl", "ChatCommand")
	self:RegisterChatCommand("sbl", "ChatCommand")
	self:RegisterChatCommand("shia", "ChatCommand")
	
	
	--create frame
	if lustFrame == nil then 
		Shiabl:CreateLustFrame()
	end

end

function Shiabl:ChatCommand(input)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):Open("Shiabl")
end

function Shiabl:OnEnable()

	Shiabl:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "Shiabl_OnEvent")

	--dbase intro stuff here?
	--if self.db.char.fireballEnabled then
		
	
end

function Shiabl:OnDisable()
    -- Called when the addon is disabled
	ag:Stop()
	lustFrame:Hide()
end


function Shiabl:Shiabl_OnEvent()

	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _, spellName, _, auraType = CombatLogGetCurrentEventInfo()
	
	print(subevent)
	print(destName)
	print(destGUID)
	print(sourceName)
	
	if subevent == "SPELL_AURA_APPLIED" and tContains(triggerAuras, spellName) and destGUID == UnitGUID("player") then
		lustFrame:Show()
		print(spellName .. " applied.")
		--PlaySoundFile("Interface\\AddOns\\Shiabloodlust\\media\\ShiaSound.ogg")
		ag:Play()
	end
	if subevent == "SPELL_AURA_REMOVED" and tContains(triggerAuras, spellName) then
		print(spellName .. " removed.")
		ag:Stop()
		lustFrame:Hide()
	end
end

function Shiabl:CreateLustFrame()

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
	t:SetTexture("Interface\\AddOns\\Shiabloodlust\\media\\ShiaTexture.tga")
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