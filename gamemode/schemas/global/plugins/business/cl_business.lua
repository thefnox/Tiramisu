BusinessTable = false
BusinessLevels = {}
--Basically this is used to add some helpful information about each buy group. That way you can see on what category does the item actually belong, instead of using a number.
BusinessLevels[1] = {}
BusinessLevels[1].Name = "General"
BusinessLevels[1].Desc = "Foodstuffs, groceries, all legal stuff."
BusinessLevels[1].Icon = "gui/silkicons/star"

BusinessLevels[2] = {}
BusinessLevels[2].Name = "Black Market"
BusinessLevels[2].Desc = "Weapons, drugs, and more weapons."
BusinessLevels[2].Icon = "gui/silkicons/bomb"

BusinessLevels[3] = {}
BusinessLevels[3].Name = "Medical"
BusinessLevels[3].Desc = "Everything that is good for your health."
BusinessLevels[3].Icon = "gui/silkicons/heart"

local BusinessFrame 
local function OpenBusinessMenu()

	BusinessFrame = vgui.Create( "DFrame" )
	BusinessFrame:SetSize( 586, 474 )
	BusinessFrame:Center()
	BusinessFrame:SetTitle( "Business" )
	BusinessFrame:MakePopup()

	local title = Label( "Your Business Inventory", BusinessFrame)
	title:SetFont( "Tiramisu48Font")
	title:SetPos( 10, 23 )
	title:SizeToContents()
	local subtitle = Label( "Your funds: " .. CAKE.ConVars[ "CurrencyAbr" ] .. LocalPlayer():GetNWInt( "money", 0 ), BusinessFrame)
	subtitle.PaintOver = function()
		subtitle:SetText("Your funds: " .. CAKE.ConVars[ "CurrencyAbr" ] .. LocalPlayer():GetNWInt( "money", 0 ))
		subtitle:SizeToContents()
	end
	subtitle:SetPos( 10, 66 )
	subtitle:SetFont( "Tiramisu24Font")
	subtitle:SizeToContents()
	local propsheet = vgui.Create( "DPropertySheet", BusinessFrame )
	propsheet:SetPos( 5, 96 )
	propsheet:SetSize( BusinessFrame:GetWide() - 10, 374 )
	
	local panel
	local grid
	local icon
	for buygroup, v in pairs( BusinessLevels ) do
		if BusinessTable[buygroup] then
			panel = vgui.Create( "DPanelList" )
			panel:EnableHorizontal( true )
			panel:SetPadding( 4 )
			panel:SetSpacing( 4 )
			local icontable = {}
			for k, item in pairs( BusinessTable[buygroup] ) do
				local cur = #icontable + 1
				icontable[cur] = vgui.Create( "ContainerSlot" )
				icontable[cur]:SetIconSize( 48 )
				icontable[cur]:SetItem( item )
				icontable[cur]:DisableDrag()
				icontable[cur].OpenMenu = function()
					local ContextMenu = DermaMenu()
					ContextMenu:AddOption("Buy", function() LocalPlayer():ConCommand("rp_buyitem " .. icontable[cur]:GetItem() ) end)
					ContextMenu:Open()
				end
				icontable[cur].PaintOver = function()
					if icontable[cur]:GetItem() then
						surface.SetTextColor(Color(55,200,55,255))
						surface.SetFont("TiramisuDefaultFont")
						surface.SetTextPos( icontable[cur]:GetWide() - 20, icontable[cur]:GetTall() - 15)
						surface.DrawText( CAKE.ItemData[icontable[cur]:GetItem()].Price or "0" )
					end
				end
				panel:AddItem( icontable[cur] )
			end
			for i=#icontable + 1, 60 do
				icontable[i] = vgui.Create( "ContainerSlot" )
				icontable[i]:DisableDrag()
				icontable[i]:SetIconSize( 48 )
				panel:AddItem(icontable[i])
			end

			if BusinessLevels[buygroup] then
				propsheet:AddSheet( BusinessLevels[buygroup].Name, panel, BusinessLevels[buygroup].Icon, false, false, BusinessLevels[buygroup].Desc )
			else
				propsheet:AddSheet( "Group " .. buygroup, panel, "gui/silkicons/star", false, false, "No description available" )
			end
		end
	end
	propsheet:InvalidateLayout( true )

end

local function OpenBusiness()
	RunConsoleCommand( "rp_openbusinessmenu" )
end

local function CloseBusiness()
	if BusinessFrame then
		BusinessFrame:Remove()
		BusinessFrame = nil
	end
end

datastream.Hook("refreshbusiness", function(handler, id, encoded, decoded )
	
	BusinessTable = decoded
	if BusinessTable and table.Count(BusinessTable) != 0 then
		OpenBusinessMenu()
	else
		CAKE.Message( "You do not have access to this tab!", "Error: No Business data", "OK" )
		if BusinessFrame then
			BusinessFrame:Remove()
			BusinessFrame = nil
		end
	end
	
end )


CAKE.RegisterMenuTab( "Business", OpenBusiness, CloseBusiness )