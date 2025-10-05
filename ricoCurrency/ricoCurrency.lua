local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
ricoCurrency = LDB:NewDataObject( "ricoCurrency", {type = "data source", text = "", label = "Currencies", icon  = "Interface\\Icons\\pvecurrency-justice"} )

local ricoCurrencyFrame = CreateFrame("Frame")
ricoCurrencyFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ricoCurrencyFrame:RegisterEvent("PLAYER_MONEY")
ricoCurrencyFrame:RegisterEvent("PLAYER_LEVEL_UP")
ricoCurrencyFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ricoCurrencyFrame:RegisterEvent("ADDON_LOADED")
ricoCurrencyFrame:SetScript("OnEvent", function( ) ricoCurrency:Update( ) end )

local gIcon = "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
local sIcon = "|TInterface\\MoneyFrame\\UI-SilverIcon:0|t"
local cIcon = "|TInterface\\MoneyFrame\\UI-CopperIcon:0|t"

function ricoCurrency:ADDON_LOADED( )
    ricoCurrency:Update( )
end

function ricoCurrency.OnTooltipShow(tooltip)
	local money = GetMoney()
	local gold = floor(money / 1e4)
	local silver = floor(money / 100 % 100)
	local copper = money % 100
	local ap = GetTotalAchievementPoints()
	
	tooltip:AddLine("Coins", 1,1,1)
	tooltip:AddLine(gIcon .. " Gold: " .. gold, 1,1,1)
	tooltip:AddLine(sIcon .. " Silver: " .. silver, 1,1,1) 
	tooltip:AddLine(cIcon .. " Copper: " .. copper, 1,1,1) 
	tooltip:AddLine(" ", 1,1,1) 
	tooltip:AddLine("Currencies", 1,1,1)
	local listSize = GetCurrencyListSize();
	for i = 1,listSize do
		local textLine = ""
		local name, isHeader, _, _, isWatched, count, _, icon, currencyID = GetCurrencyListInfo(i)
		if isHeader == false then
			textLine = "|T" .. icon .. ":0|t " .. name .. ": " .. count 
			tooltip:AddLine(textLine)
			--print(textLine)
		end
	end
	tooltip:AddLine(" ", 1,1,1) 
	tooltip:AddLine("Achievement Points: " .. ap, 1,1,1) 

	ricoCurrency:Update()
end

function ricoCurrency:Update( )
	local listSize = GetCurrencyListSize();
	local money = GetMoney();
	local ap = GetTotalAchievementPoints()

	self.text = "AP:" .. ap
	
	if listSize > 0 then
		self.text = self.text .. "  "
		for i = 1,listSize do
			local name, isHeader, _, _, isWatched, count, _, icon, currencyID = GetCurrencyListInfo(i)
			if name and count and isWatched then
				--local icon = iconPaths[name]
				if icon ~= nil and icon ~= 0 then
					self.text = self.text .. "|T" .. icon .. ":0|t " .. count .. "  "
				else
					self.text = self.text .. name .. ":" .. count .. "   "
				end
			end
		end
	end
	
	if money > 0 then
		local gold = floor(money / 1e4)
		local silver = floor(money / 100 % 100)
		local copper = money % 100
		
		if gold > 0 then
			self.text = self.text .. " " .. gIcon .. gold
		end
		if silver > 0 then
			self.text = self.text .. " " .. sIcon .. silver
		end
		if copper > 0 then
			self.text = self.text .. " " .. cIcon .. copper
		end
		
	end
end
