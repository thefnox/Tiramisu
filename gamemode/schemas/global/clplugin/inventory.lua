CLPLUGIN.Name = "Inventory Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"

InventoryTable = {}

local function OpenInventory()
	PlayerMenu = vgui.Create( "DFrameTransparent" )
	--PlayerMenu:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Inventory" )
	--PlayerMenu:SetBackgroundBlur( true )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	PlayerMenu:MakePopup()
	
	Inventory = vgui.Create( "DPropertySheet", PlayerMenu )
	Inventory:SetSize( 630,448 )
	Inventory:SetPos( 5, 28 )
	
	InventorySheet = vgui.Create( "DPanelList" )
	InventorySheet:SetPadding(10);
	InventorySheet:SetSpacing(10);
	InventorySheet:EnableHorizontal(false);
	InventorySheet:EnableVerticalScrollbar(false);
	local elipsis = ""
	
	local availablespace = 10

	local icons = {}
	
	local function drawinventoryicons()
		availablespace = 10
		InventorySheet:Clear()
		
		local label = vgui.Create( "DLabel" )
		label:SizeToContents()
		InventorySheet:AddItem(label);
		
		local grid = vgui.Create( "DGrid" )
		grid:SetCols( 8 )
		grid:SetColWide( 74 )
		grid:SetRowHeight( 74 )
		InventorySheet:AddItem(grid);
		
		for k, v in pairs(InventoryTable) do
			
			if !icons[ v.Class ] then
			
				if string.len( v.Name ) > 6 then
					elipsis = "..."
				else
					elipsis = ""
				end
				
				local spawnicon = vgui.Create( "SpawnIcon");
				spawnicon:SetSize( 64, 64 );
				spawnicon:SetIconSize( 64 )
				spawnicon.count = 1
				spawnicon:SetModel(v.Model);
				spawnicon:SetToolTip(v.Description);
				icons[ v.Class ] = spawnicon
				
				local function DeleteMyself()
					spawnicon.count = spawnicon.count - 1
					if spawnicon.count < 1 then
						grid:RemoveItem( spawnicon )
					end
				end
				
				spawnicon.DoClick = function ( btn )
				
					local ContextMenu = DermaMenu()
						ContextMenu:AddOption("Drop", function() LocalPlayer():ConCommand("rp_dropitem " .. v.Class); DeleteMyself(); end);
						ContextMenu:AddOption("Use", function() LocalPlayer():ConCommand("rp_useinventory " .. v.Class); DeleteMyself(); end);
					ContextMenu:Open();
					
				end
				
				spawnicon.PaintOver = function()
					surface.SetTextColor(Color(255,255,255,255));
					surface.SetFont("TabLarge");
					surface.SetTextPos(32 - surface.GetTextSize( string.sub( v.Name, 1, 6 ) .. elipsis) / 2, 5);
					surface.DrawText( string.sub( v.Name, 1, 6 ) .. elipsis )
					
					surface.SetTextColor(Color(255,100,100,255))
					surface.SetTextPos(52, 50);
					surface.DrawText( v.Weight or 1 )

					if spawnicon.count and spawnicon.count > 1 then
						surface.SetTextColor(Color(100,255,100,255))
						surface.SetTextPos(5, 50);
						surface.DrawText( tostring( spawnicon.count ) )
					end
				end
				
				spawnicon.PaintOverHovered = function()
					surface.SetTextColor(Color(255,255,255,255));
					surface.SetFont("TabLarge");
					surface.SetTextPos(32 - surface.GetTextSize( string.sub( v.Name, 1, 6 ) .. elipsis) / 2, 5);
					surface.DrawText( string.sub( v.Name, 1, 6 ) .. elipsis )
					
					surface.SetTextColor(Color(255,100,100,255))
					surface.SetTextPos(52, 50);
					surface.DrawText( v.Weight or 1 )

					if spawnicon.count and spawnicon.count > 1 then
						surface.SetTextColor(Color(100,255,100,255))
						surface.SetTextPos(5, 50);
						surface.DrawText( tostring( spawnicon.count ) )
					end
				end
				
				availablespace = availablespace - v.Weight
				
				grid:AddItem(spawnicon);
			else
				icons[ v.Class ].count = icons[ v.Class ].count + 1
			end
		end
		
		label:SetText( "Available space: " .. tostring( math.Clamp( availablespace, 0, 100 ) ) .. ".kg" )
	end
	drawinventoryicons()
	Inventory:AddSheet( "Backpack", InventorySheet, "gui/silkicons/box", false, false, "View your inventory.")
	

	if CAKE.GetRankPermission( "canbuy" ) then
		BusinessSheet = vgui.Create( "DPanelList" )
		BusinessSheet:SetPadding(20);
		BusinessSheet:SetSpacing(20);
		BusinessSheet:EnableHorizontal(true);
		BusinessSheet:EnableVerticalScrollbar(true);

		for k, v in pairs(BusinessTable) do
			local spawnicon = vgui.Create( "SpawnIcon");
			spawnicon:SetSize( 32, 32 );
			spawnicon:SetIconSize( 32 )
			spawnicon:SetModel(v.Model);
			spawnicon:SetToolTip(v.Description);
					
			spawnicon.DoClick = function ( btn )
					
				local ContextMenu = DermaMenu()
				if(tonumber(LocalPlayer():GetNWInt("money")) >= v.Price) then
					ContextMenu:AddOption("Purchase", function() LocalPlayer():ConCommand("rp_buyitem " .. v.Class); end);
				else
					ContextMenu:AddOption("Not Enough Tokens!");
				end
					
				ContextMenu:Open();
						
			end
					
			spawnicon.PaintOver = function()
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(64 - surface.GetTextSize(v.Name .. " (" .. v.Price .. ")") / 2, 5);
				surface.DrawText(v.Name .. " (" .. v.Price .. ")")
			end
					
			spawnicon.PaintOverHovered = function()
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(64 - surface.GetTextSize(v.Name .. " (" .. v.Price .. ")") / 2, 5);
				surface.DrawText(v.Name .. " (" .. v.Price .. ")")
			end
					
			BusinessSheet:AddItem(spawnicon);
		end
		Inventory:AddSheet( "Business", BusinessSheet, "gui/silkicons/box", false, false, "View your store.")
	end

end

local function CloseInventory()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end

local function AddItem(data)
	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Weight = data:ReadShort();
	
	table.insert(InventoryTable, itemdata);
end
usermessage.Hook("addinventory", AddItem);

local function ClearItems()
	
	InventoryTable = {}
	
end
usermessage.Hook("clearinventory", ClearItems);

BusinessTable = {};

local function ClearBusiness()
	
	BusinessTable = {}
	
end
usermessage.Hook("clearbusiness", ClearBusiness);

local function AddBusinessItem(data)
	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Price = data:ReadLong();
	
	--print( itemdata.Class )
	
	table.insert(BusinessTable, itemdata);
end
usermessage.Hook("addbusiness", AddBusinessItem);

function CLPLUGIN.Init()
	CAKE.RegisterMenuTab( "Inventory", OpenInventory, CloseInventory )
end