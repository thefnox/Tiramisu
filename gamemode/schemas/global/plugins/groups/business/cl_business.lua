BusinessTable = false
ConversionTable = {}
--Basically this is used to add some helpful information about each buy group. That way you can see on what category does the item actually belong, instead of using a number.
ConversionTable[1] = {}
ConversionTable[1].Name = "General"
ConversionTable[1].Desc = "Foodstuffs, groceries, all legal stuff."
ConversionTable[1].Icon = "gui/silkicons/star"

ConversionTable[2] = {}
ConversionTable[2].Name = "Black Market"
ConversionTable[2].Desc = "Weapons, drugs, and more weapons."
ConversionTable[2].Icon = "gui/silkicons/bomb"

ConversionTable[3] = {}
ConversionTable[3].Name = "Medical"
ConversionTable[3].Desc = "Everything that is good for your health."
ConversionTable[3].Icon = "gui/silkicons/heart"

datastream.Hook("refreshbusiness", function(handler, id, encoded, decoded )
	
	BusinessTable = decoded
	
end )

local BusinessFrame 
local function OpenBusiness()

	if BusinessTable then

		BusinessFrame = vgui.Create( "DFrame" )
		BusinessFrame:SetSize( 532, 433 )
		BusinessFrame:Center()
		BusinessFrame:SetTitle( "Business" )
		BusinessFrame:MakePopup()

		local propsheet = vgui.Create( "DPropertySheet", BusinessFrame )
		propsheet:SetPos( 5, 28 )
		propsheet:SetSize( 522, 400 )
		
		local panel
		local grid
		local icon
		for buygroup, v in pairs( ConversionTable ) do
			if BusinessTable[buygroup] then
				panel = vgui.Create( "DPanelList" )
				grid = vgui.Create( "DGrid" )
				panel:AddItem( grid )
				grid:SetCols( 9 )
				grid:SetColWide( 56 )
				grid:SetRowHeight( 52 )
				local icontable = {}
				for k, item in pairs( BusinessTable[buygroup] ) do
					icontable[k] = vgui.Create( "InventorySlot" )
					icontable[k]:SetIconSize( 48 )
					icontable[k]:SetItem( item )
					icontable[k]:DisableDrag()
					icontable[k].OnMousePressed = function()
						icontable[k]:OpenMenu()
					end
					icontable[k].OnMouseReleased = function() end
					icontable[k].OpenMenu = function()
						local ContextMenu = DermaMenu()
						ContextMenu:AddOption("Buy", function() LocalPlayer():ConCommand("rp_buyitem " .. icontable[k]:GetItem().Class ) end)
						ContextMenu:Open()
					end
					icontable[k].PaintOver = function()
						surface.SetTextColor(Color(255,255,255,255))
						surface.SetFont("TabLarge")
						surface.SetTextPos( icontable[k]:GetWide() - 20, icontable[k]:GetTall() - 14)
						surface.DrawText( icontable[k]:GetItem().Price or "0" )
					end
					grid:AddItem( icontable[k] )
				end
				if ConversionTable[buygroup] then
					propsheet:AddSheet( ConversionTable[buygroup].Name, panel, ConversionTable[buygroup].Icon, false, false, ConversionTable[buygroup].Desc )
				else
					propsheet:AddSheet( "Group " .. buygroup, panel, "gui/silkicons/star", false, false, "No description available" )
				end
			end
		end
		propsheet:InvalidateLayout( true )

	else
		CAKE.Message( "You do not have access to this tab!", "Error: No Business data", "OK" )
	end

end

local function CloseBusiness()
	if BusinessFrame then
		BusinessFrame:Remove()
		BusinessFrame = nil
	end
end

CAKE.RegisterMenuTab( "Business", OpenBusiness, CloseBusiness )