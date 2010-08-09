RCLICK.Name = "Open"

usermessage.Hook("PopulateCont", function() CONTAINER = {} end);
usermessage.Hook("AddItemCont", function(um)

	class = um:ReadString()
	model = um:ReadString()
	desc = um:ReadString()
	name = um:ReadString()
	
	print(class)
	
	item = {}
	item.Class = class
	item.Model = model
	item.Description = desc
	item.Name = name
	
	table.insert(CONTAINER, item)

  end)

function MakeContainerUp( um )

	if ContainerInfo then
		
		ContainerInfo:Remove()
		ContainerInfo = nil
	
	end

	ent = um:ReadEntity()

	ContainerInfo = vgui.Create( "DFrame" )
	ContainerInfo:SetPos( ScrW() / 2 - 268, ScrH() / 2 - 175 )
	ContainerInfo:SetSize( 536, 350 )
	ContainerInfo:SetTitle( "The container holds inside..." )
	ContainerInfo:SetVisible( true )
	ContainerInfo:SetDraggable( true )
	ContainerInfo:ShowCloseButton( true )
	ContainerInfo:MakePopup()
	ContainerPanel = vgui.Create( "DPanel", ContainerInfo )
	ContainerPanel:SetPos( 2, 23 )
	ContainerPanel:SetSize( 532, 325 )
	ContainerPanel.Paint = function()
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.DrawRect( 0, 0, ContainerPanel:GetWide(), ContainerPanel:GetTall() )
	end
	
	ContainerInventory = vgui.Create( "DPanelList", ContainerPanel )
	ContainerInventory:SetPadding(0);
	ContainerInventory:SetSpacing(0);
	ContainerInventory:EnableHorizontal(false);
	ContainerInventory:EnableVerticalScrollbar(true);
	
	for k, v in pairs(CONTAINER) do
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetSize( 32, 32 );
		spawnicon:SetIconSize( 32 )
		spawnicon:SetModel(v.Model);
		spawnicon:SetToolTip(v.Description);
		
		local function DeleteMyself()
			spawnicon:Remove()
		end
		
		spawnicon.DoClick = function ( btn )
		
			local ContextMenu = DermaMenu()
				ContextMenu:AddOption("Grab Item", function()
				LocalPlayer():ConCommand("rp_intcont take " ..ent:EntIndex().. " " ..v.Class.. "")

				LocalPlayer():ConCommand("rp_opencont " ..ent:EntIndex().. "")
				end);
			ContextMenu:Open();
			
		end
		
		spawnicon.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		spawnicon.PaintOverHovered = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		ContainerInventory:AddItem(spawnicon);
		
	end
	
	Inventory = vgui.Create( "DPanelList", ContainerPanel )
	Inventory:SetPadding(20);
	Inventory:SetSpacing(20);
	Inventory:EnableHorizontal(true);
	Inventory:EnableVerticalScrollbar(true);
	
	for k, v in pairs(InventoryTable) do
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetSize( 32, 32 );
		spawnicon:SetIconSize( 32 )
		spawnicon:SetModel(v.Model);
		spawnicon:SetToolTip(v.Description);
		
		local function DeleteMyself()
			spawnicon:Remove()
		end
		
		spawnicon.DoClick = function ( btn )
		
			local ContextMenu = DermaMenu()
				ContextMenu:AddOption("Drop", function() 
				LocalPlayer():ConCommand("rp_intcont give " ..ent:EntIndex().. " " ..v.Class.. "")
				LocalPlayer():ConCommand("rp_opencont " ..ent:EntIndex().. "")
				end);
			ContextMenu:Open();
			
		end
		
		spawnicon.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		spawnicon.PaintOverHovered = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		Inventory:AddItem(spawnicon);
	end
	
	local Divider = vgui.Create("DHorizontalDivider", ContainerPanel );
	Divider:SetPos(4, 4) //Set the top left corner of the Divider
	Divider:SetSize(536, 275) //Set the overall size of the Divider
	Divider:SetLeftWidth(263) //Set the starting width of the left item, the right item will be scaled appropriately.
	Divider:SetDividerWidth(4) //Set the width of the dividing bar.
	Divider:SetLeft( ContainerInventory );
	Divider:SetRight( Inventory );
	
    local closebutton = vgui.Create( "DButton", ContainerPanel )
    --closebutton:SetPos( 50, 100 )
    closebutton:Dock( BOTTOM )
    closebutton:SetSize( 150, 50 )
	closebutton:SetText( "Close the container" )
	closebutton.DoClick = function( btn )
		ContainerInfo:Remove()
		ContainerInfo = nil;
    end
end
usermessage.Hook("EndPopulate", MakeContainerUp);


function RCLICK.Condition(target)

if ( target:GetClass() == "prop_physics" or  target:GetClass() == "item_prop" ) and target:GetNWInt( "iscont" ) == 1 then return true end

end

function RCLICK.Click(target,ply)

	ply:ConCommand("rp_opencont " ..target:EntIndex().. "") 

end 