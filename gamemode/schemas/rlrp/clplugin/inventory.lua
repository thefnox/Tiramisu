CLPLUGIN.Name = "Inventory Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"

local function OpenInventory()
	PlayerMenu = vgui.Create( "DFrame" )
	--PlayerMenu:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Inventory" )
	--PlayerMenu:SetBackgroundBlur( true )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	function PlayerMenu:Paint()
	end
	
	Inventory = vgui.Create( "DPropertySheet", PlayerMenu )
	Inventory:SetSize( 640,450 )
	Inventory:SetPos( 0, 23 )
	
	InventorySheet = vgui.Create( "DPanelList" )
	InventorySheet:SetPadding(10);
	InventorySheet:SetSpacing(10);
	InventorySheet:EnableHorizontal(false);
	InventorySheet:EnableVerticalScrollbar(false);
	local elipsis = ""
	
	local availablespace = 10
	
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
			
			if string.len( v.Name ) > 6 then
				elipsis = "..."
			else
				elipsis = ""
			end
			
			local spawnicon = vgui.Create( "SpawnIcon");
			spawnicon:SetSize( 64, 64 );
			spawnicon:SetIconSize( 64 )
			spawnicon:SetModel(v.Model);
			spawnicon:SetToolTip(v.Description);
			
			local function DeleteMyself()
				grid:RemoveItem( spawnicon )
			end
			
			spawnicon.DoClick = function ( btn )
			
				local ContextMenu = DermaMenu()
					ContextMenu:AddOption("Drop", function() LocalPlayer():ConCommand("rp_dropitem " .. v.Class); DeleteMyself(); end);
				ContextMenu:Open();
				
			end
			
			spawnicon.PaintOver = function()
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(32 - surface.GetTextSize( string.sub( v.Name, 1, 6 ) .. elipsis) / 2, 5);
				surface.DrawText( string.sub( v.Name, 1, 6 ) .. elipsis )
				
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(60, 60);
				surface.DrawText( v.Weight )
			end
			
			spawnicon.PaintOverHovered = function()
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(32 - surface.GetTextSize( string.sub( v.Name, 1, 6 ) .. elipsis ) / 2, 5);
				surface.DrawText(string.sub( v.Name, 1, 6 ) .. elipsis)
				
				surface.SetTextColor(Color(255,255,255,255));
				surface.SetFont("DefaultSmall");
				surface.SetTextPos(60, 60);
				surface.DrawText( v.Weight )
			end
			
			availablespace = availablespace - v.Weight
			
			grid:AddItem(spawnicon);
		end
		
		label:SetText( "Available space: " .. tostring( math.Clamp( availablespace, 0, 100 ) ) .. ".kg" )
	end
	drawinventoryicons()
	
	local elipsis = ""
	
	local function drawextrainventory()
	end
	
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
			if(tonumber(LocalPlayer():GetNWString("money")) >= v.Price) then
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
	
	Inventory:AddSheet( "Backpack", InventorySheet, "gui/silkicons/box", false, false, "View your inventory.")
	Inventory:AddSheet( "Business", BusinessSheet, "gui/silkicons/box", false, false, "View your store.")

end

local function CloseInventory()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Inventory", OpenInventory, CloseInventory )
function CLPLUGIN.Init()
	
end