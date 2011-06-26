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

	local ent = um:ReadEntity()
	local size = um:ReadShort()

	local ContainerInfo = vgui.Create( "DFrameTransparent" )
	ContainerInfo:SetSize( 540, 408 )
	ContainerInfo:SetTitle( "The container holds inside..." )
	ContainerInfo:SetVisible( true )
	ContainerInfo:SetDraggable( true )
	ContainerInfo:ShowCloseButton( false )
	ContainerInfo:Center()
	ContainerInfo:MakePopup()

	local closebutton = vgui.Create( "DButton", ContainerInfo )
	closebutton:SetSize( 200, 30 )
	closebutton:SetPos( 170, 372 )
	closebutton:SetText( "Close the container" )
	closebutton.DoClick = function()
	    ContainerInfo:Close()
	end

	local ContainerContents = vgui.Create( "DPanelList", ContainerInfo )
	ContainerContents:SetSpacing( 5 )
	ContainerContents:SetPadding( 5 )
	ContainerContents:AddItem( Label( "Container:" ) )
	local ContainerGrid = vgui.Create( "DGrid" )
	local ContainerTable = {}
	ContainerContents:AddItem( ContainerGrid )
	ContainerGrid:SetCols( 6 )
	ContainerGrid:SetColWide( 38 )
	ContainerGrid:SetRowHeight( 40 )
	for i = 1, size do
	    icon = vgui.Create( "InventorySlot" )
	    icon:SetIconSize( 32 )
	    ContainerGrid:AddItem( icon )
	    ContainerTable[i] = icon
	    ContainerTable[i].ContainerItem = true
		ContainerTable[i].OpenMenu = function() end
		ContainerTable[i].EndDrag = function()
			if LocalPlayer().OnDrag then
				LocalPlayer().OnDrag = false
				LocalPlayer().DragIcon:Remove()
				LocalPlayer().DragIcon = nil
				if LocalPlayer().DragTarget then
					if LocalPlayer().DragTarget:GetItem() then
						--Trade items between the origin and target slots.
						if LocalPlayer().DragOrigin.ContainerItem then
							LocalPlayer():ConCommand("rp_intcont take " ..ent:EntIndex().. " " ..LocalPlayer().DragTarget:GetItem().Class.. "")
						else
							LocalPlayer():ConCommand("rp_intcont give " ..ent:EntIndex().. " " ..LocalPlayer().DragTarget:GetItem().Class.. "")
						end
						LocalPlayer().DragOrigin:SetItem( LocalPlayer().DragTarget:GetItem(), LocalPlayer().DragTarget:GetAmount() )
						LocalPlayer().DragTarget:SetItem( LocalPlayer().DragItem, LocalPlayer().DragAmount )
					else
						--Just set the currently empty slot to the dragged item, and clear the origin.
						LocalPlayer().DragOrigin:ClearItem()
						LocalPlayer().DragTarget:SetItem( LocalPlayer().DragItem, LocalPlayer().DragAmount )
					end
				else
					--Nothing resulted out of the drag, reverse to normal.
					LocalPlayer().DragOrigin:SetItem( LocalPlayer().DragItem, LocalPlayer().DragAmount )
				end
			end
		end

	end

	for k, v in pairs(CONTAINER) do
		ContainerTable[k]:SetItem( v )
	end

	local PlayerInventory = vgui.Create( "DPanelList", ContainerInfo )
	PlayerInventory:SetSpacing( 5 )
	PlayerInventory:SetPadding( 5 )
	PlayerInventory:AddItem( Label( "Inventory:" ) )
	local PlayerGrid = vgui.Create( "DGrid" )
	PlayerInventory:AddItem( PlayerGrid )
	PlayerGrid:SetCols( 6 )
	PlayerGrid:SetColWide( 38 )
	PlayerGrid:SetRowHeight( 40 )
	for k, v in pairs( CAKE.InventorySlot ) do
	    icon = vgui.Create( "InventorySlot" )
	    icon:SetIconSize( 32 )
		icon.OpenMenu = function() end
		icon.EndDrag = function()
		LocalPlayer().OnDrag = false
		LocalPlayer().DragIcon:Remove()
		LocalPlayer().DragIcon = nil
		if LocalPlayer().DragTarget then
			if LocalPlayer().DragTarget:GetItem() then
				--Trade items between the origin and target slots.
				if LocalPlayer().DragOrigin.ContainerItem then
					LocalPlayer():ConCommand("rp_intcont take " ..ent:EntIndex().. " " ..LocalPlayer().DragTarget:GetItem().Class.. "")
				else
					LocalPlayer():ConCommand("rp_intcont give " ..ent:EntIndex().. " " ..LocalPlayer().DragTarget:GetItem().Class.. "")
				end
				LocalPlayer().DragOrigin:SetItem( LocalPlayer().DragTarget:GetItem(), LocalPlayer().DragTarget:GetAmount() )
				LocalPlayer().DragTarget:SetItem( LocalPlayer().DragItem, LocalPlayer().DragAmount )
			else
				--Just set the currently empty slot to the dragged item, and clear the origin.
				LocalPlayer().DragOrigin:ClearItem()
				LocalPlayer().DragTarget:SetItem( LocalPlayer().DragItem, LocalPlayer().DragAmount )
			end
		else
			--Nothing resulted out of the drag, reverse to normal.
			LocalPlayer().DragOrigin:SetItem( LocalPlayer().DragItem, LocalPlayer().DragAmount )
		end
	end
	if v:GetItem() then
		icon:SetItem( v:GetItem(), v:GetAmount() )
	end

    PlayerGrid:AddItem( icon )
end

local hozdivider = vgui.Create( "DHorizontalDivider", ContainerInfo )
hozdivider:SetPos( 5, 28 )
hozdivider:SetSize( 530, 340)
hozdivider:SetLeftWidth(260)
hozdivider:SetLeft( ContainerContents )
hozdivider:SetRight( PlayerInventory )
hozdivider:SetDividerWidth( 12 )


end
usermessage.Hook("EndPopulate", MakeContainerUp);


function RCLICK.Condition(target)

if ( target:GetClass() == "prop_physics" or  target:GetClass() == "item_prop" ) and target:GetNWInt( "iscont" ) == 1 then return true end

end

function RCLICK.Click(target,ply)

	ply:ConCommand("rp_opencont " ..target:EntIndex().. "") 

end 