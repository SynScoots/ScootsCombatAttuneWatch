local SCAWFrame = CreateFrame("Frame", nil, UIParent)

local slots = {
	{
		["key"] = "HeadSlot",
		["name"] = INVTYPE_HEAD
	},
	{
		["key"] = "NeckSlot",
		["name"] = INVTYPE_NECK
	},
	{
		["key"] = "ShoulderSlot",
		["name"] = INVTYPE_SHOULDER
	},
	{
		["key"] = "BackSlot",
		["name"] = INVTYPE_CLOAK
	},
	{
		["key"] = "ChestSlot",
		["name"] = INVTYPE_CHEST
	},
	{
		["key"] = "WristSlot",
		["name"] = INVTYPE_WRIST
	},
	{
		["key"] = "HandsSlot",
		["name"] = INVTYPE_HAND
	},
	{
		["key"] = "WaistSlot",
		["name"] = INVTYPE_WAIST
	},
	{
		["key"] = "LegsSlot",
		["name"] = INVTYPE_LEGS
	},
	{
		["key"] = "FeetSlot",
		["name"] = INVTYPE_FEET
	},
	{
		["key"] = "Finger0Slot",
		["name"] = INVTYPE_FINGER.." 1"
	},
	{
		["key"] = "Finger1Slot",
		["name"] = INVTYPE_FINGER.." 2"
	},
	{
		["key"] = "Trinket0Slot",
		["name"] = INVTYPE_TRINKET.." 1"
	},
	{
		["key"] = "Trinket1Slot",
		["name"] = INVTYPE_TRINKET.." 2"
	},
	{
		["key"] = "MainHandSlot",
		["name"] = INVTYPE_WEAPONMAINHAND
	},
	{
		["key"] = "SecondaryHandSlot",
		["name"] = INVTYPE_WEAPONOFFHAND
	},
	{
		["key"] = "RangedSlot",
		["name"] = INVTYPE_RANGED
	}
}

local attuneData = {}
local inCombat = false

SCAWFrame:SetScript("OnEvent", function(self, event)
	if(GetItemLinkAttuneProgress ~= nil) then
		if(event == "PLAYER_REGEN_DISABLED") then
			inCombat = true
			local slotCount = table.getn(slots)
			for idx = 1, slotCount do
				local itemLink = GetInventoryItemLink("player", GetInventorySlotInfo(slots[idx].key))
				if(itemLink ~= Nil) then
					attuneData[slots[idx].key] = tonumber(GetItemLinkAttuneProgress(itemLink))
				end
			end
		end
		
		if(inCombat == true and (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_DEAD")) then
			local output = {}
			inCombat = false
			
			local slotCount = table.getn(slots)
			for idx = 1, slotCount do
				local itemLink = GetInventoryItemLink("player", GetInventorySlotInfo(slots[idx].key))
				if(itemLink ~= Nil) then
					local newProgress = tonumber(GetItemLinkAttuneProgress(itemLink))
					
					if(attuneData[slots[idx].key] < 100 and newProgress == 100) then
						table.insert(output, itemLink .. " in the " .. slots[idx].name .. " slot")
					end
				end
			end
			
			local outputCount = table.getn(output)
			if(outputCount > 0) then
				PlaySound("AlarmClockWarning3", "master")
				print("The following items have attuned:")
				
				for idx = 1, outputCount do
					print(output[idx])
				end
			end
		end
	end
end)

SCAWFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
SCAWFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
SCAWFrame:RegisterEvent("PLAYER_DEAD")