local BoneList = {
	"pelvis",
	"stomach",
	"lower back",
	"chest",
	"upper back",
	"neck",
	"head",
	"right clavicle",
	"right upper arm",
	"right forearm",
	"right hand",
	"left clavicle",
	"left upper arm",
	"left forearm",
	"left hand",
	"right thigh",
	"right calf",
	"right foot",
	"right toe",
	"left thigh",
	"left calf",
	"left foot",
	"left toe"
}


CAKE.Inventory = "none"
CAKE.UData = {}
CAKE.InventorySlot = {}

datastream.Hook( "Tiramisu.ReceiveUData", function( handler, id, encoded, decoded )
	local uid = decoded.uid
	if !CAKE.UData[uid] then
		CAKE.UData[uid] = {}
	end
	CAKE.UData[uid].Name = decoded.name
	CAKE.UData[uid].Wearable = decoded.wearable
	CAKE.UData[uid].Model = decoded.model
	CAKE.UData[uid].Container = decoded.container
	if CAKE.InventorySlot then
		for _, tbl in pairs(CAKE.InventorySlot) do
			for k, v in pairs(CAKE.InventorySlot) do
				if v and v.Item and CAKE.ItemData[v.Item] and v.ItemID and v.ItemID == uid then
					v:SetTooltip(decoded.name .. "\n" .. CAKE.ItemData[v.Item].Description or "" )
				end
			end
		end
	end
end)

datastream.Hook( "Tiramisu.SendInventory", function( handler, id, encoded, decoded )
	local items = decoded.items
	local uid = decoded.uid
	local width = decoded.width
	local height = decoded.height
	table.Merge(CAKE.UData, decoded.udata)
	CAKE.Containers[uid] = CAKE.CreateContainerObject( uid )
	CAKE.Containers[uid]:SetSize( width, height )
	CAKE.Containers[uid].Items = items
	CAKE.Inventory = uid

	CAKE.CreateInventory()
end)

--InventorySlot. The square slots used on the inventory.

local PANEL = {}
AccessorFunc( PANEL, "m_bPaintBackground",			  "PaintBackground" )
AccessorFunc( PANEL, "m_bDisabled",					 "Disabled" )
AccessorFunc( PANEL, "m_bgColor",			   "BackgroundColor" )
Derma_Hook( PANEL, "Paint", "Paint", "Panel" )

function PANEL:Init()
	self:SetPaintBackground( true )
		
	// This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self.Icon = vgui.Create( "ContainerSlot_Icon", self )
	self:SetIconSize( 64 )
	self:SetToolTip( "Empty Slot")
	self.DragDisabled = false

end

--Sets the size of the slot.
function PANEL:SetIconSize( size )

	if self.Icon then
		self.IconSize = size
		self:SetSize( size + 4, size + 4 )
		self.Icon:SetSize( size, size )
		self.Icon:SetPos( 2, 2 )
	end

end

function PANEL:GetName()
	if self.Item then
		if self.ItemID and CAKE.UData[self.ItemID] and CAKE.UData[self.ItemID].Name then
			return CAKE.UData[self.ItemID].Name
		else
			return CAKE.ItemData[self.Item].Name
		end
	end
end

--Sets an item to be used on the inventory slot. The item thing is a table, not a string. Amount defaults to 1.
function PANEL:SetItem( item, itemid )
	local itemtable = CAKE.ItemData[item]
	if itemtable then
		self.Item = itemtable.Class
		self.ItemID = itemid
		if !self.Icon then
			self.Icon = vgui.Create( "ContainerSlot_Icon", self )
			self:SetIconSize( self.IconSize )
		end
		if itemtable.Description != "" then self:SetToolTip( self:GetName() .. "\n" .. itemtable.Description )
		else self:SetToolTip( self:GetName() ) end
		if CAKE.UData[itemid] then
			self.Model = CAKE.UData[itemid].Model or itemtable.Model
		else
			self.Model = itemtable.Model
		end
		self.Icon:SetModel( self.Model )
	end
end

--Returns the model of the slot
function PANEL:GetModel()
	return self.Model or ""
end

--Returns the item table.
function PANEL:GetItem()
	return self.Item
end

function PANEL:GetItemID()
	return self.ItemID
end

--Clears the item off the slot.
function PANEL:ClearItem()

	if self.Icon then
		self.Icon:Remove()
		self.Icon = nil
	end
	self.Item = false
	self.ItemID = false
	self:SetToolTip( "Empty Slot" )

end

function PANEL:SetContainer( uid )
	self.Container = uid
end

function PANEL:GetContainer()
	return self.Container or "none"
end

function PANEL:SetPosition( x, y )
	self.PosX = x
	self.PosY = y
end

function PANEL:GetX()
	return self.PosX or 0
end

function PANEL:GetY()
	return self.PosY or 0
end

--Disables dragging in and out on that slot.
function PANEL:DisableDrag()
	self.DragDisabled = !self.DragDisabled
end

--Utility to handle item dropping.
function PANEL:DropItem()
	if self.Item then
		LocalPlayer():ConCommand("rp_dropitem " .. self:GetItemID() )
	end
end

function PANEL:DropAllItem()
	if self.Item then
		LocalPlayer():ConCommand("rp_dropallitem " .. self:GetItem())
	end
end

--Utility to handle item using.
function PANEL:UseItem(dofunc)
	if self.Item then
		if dofunc then
			LocalPlayer():ConCommand("rp_useinventoryid " .. self:GetItemID() .. " " .. dofunc )
		elseif !CAKE.ItemData[self:GetItem()].Unusable then
			LocalPlayer():ConCommand("rp_useinventoryid " .. self:GetItemID() )
		end
	end
end

function PANEL:GetWearable()
	if self.Item then
		if string.match(self.Item, "clothing_") or string.match(self.Item, "helmet_") then
			return true
		elseif self.ItemID and CAKE.UData[self.ItemID] and CAKE.UData[self.ItemID].Wearable then
			return true
		end
	end
	return false
end

function PANEL:OnMousePressed( mcode )

	if ( mcode == MOUSE_LEFT ) and self.Item then
		self:StartDrag()
	end
	
	if ( mcode == MOUSE_RIGHT ) and self.Item then
		self:OpenMenu()
	end

end

function PANEL:OnMouseReleased( mcode )

	if ( mcode == MOUSE_LEFT ) then
		self:EndDrag()
	end

end

--Begins dragging operation. Creates icon display.
function PANEL:StartDrag()
	if !LocalPlayer().Drag and !self.DragDisabled and self:GetItem() then
		LocalPlayer().Drag = true
		LocalPlayer().DragIcon = ClientsideModel( self:GetModel(), RENDER_GROUP_OPAQUE_ENTITY )
		LocalPlayer().DragIcon.Tall = self.IconSize
		LocalPlayer().DragIcon.Wide = self.IconSize
		LocalPlayer().DragIcon.viewcords = PositionSpawnIcon( LocalPlayer().DragIcon, LocalPlayer().DragIcon:GetPos() )
		LocalPlayer().DragIcon:SetModel( self:GetModel() )
		LocalPlayer().DragIcon:SetNoDraw(true)
		--LocalPlayer().DragIcon:MakePopup()
		LocalPlayer().DragOrigin = self
		LocalPlayer().DragContainer = self:GetContainer()
		LocalPlayer().DragOriginX = self:GetX()
		LocalPlayer().DragOriginY = self:GetY()
		LocalPlayer().DragItemClass, LocalPlayer().DragItemID = self:GetItem(), self:GetItemID()
	end
end

--Finishes dragging operation. Performs the actual transfer operation.
function PANEL:EndDrag()
	if LocalPlayer().Drag and !self.DragDisabled then
		LocalPlayer().Drag = false
		LocalPlayer().DragIcon:Remove()
		LocalPlayer().DragIcon = nil
		if LocalPlayer().DragTarget then
			if LocalPlayer().DragTarget:GetContainer() == LocalPlayer().DragContainer then
				if LocalPlayer().DragTarget.ItemID and CAKE.UData[LocalPlayer().DragTarget.ItemID] and CAKE.UData[LocalPlayer().DragTarget.ItemID].Container then
					print("rp_transfertocontainer", LocalPlayer().DragContainer, CAKE.UData[LocalPlayer().DragTarget.ItemID].Container, LocalPlayer().DragItemClass, LocalPlayer().DragItemID)
					RunConsoleCommand("rp_transfertocontainer", LocalPlayer().DragContainer, CAKE.UData[LocalPlayer().DragTarget.ItemID].Container, LocalPlayer().DragItemClass, LocalPlayer().DragItemID)
				elseif LocalPlayer().DragTarget:GetX() != LocalPlayer().DragOriginX or LocalPlayer().DragTarget:GetY() != LocalPlayer().DragOriginY then
					RunConsoleCommand("rp_containerswap", LocalPlayer().DragContainer, LocalPlayer().DragOriginX, LocalPlayer().DragOriginY, LocalPlayer().DragTarget:GetX(), LocalPlayer().DragTarget:GetY() )
				end
			else
				RunConsoleCommand("rp_transfertocontainer", LocalPlayer().DragContainer, LocalPlayer().DragTarget:GetContainer(), LocalPlayer().DragItemClass, LocalPlayer().DragItemID,LocalPlayer().DragTarget:GetX(), LocalPlayer().DragTarget:GetY())
			end
			LocalPlayer().DragTarget = nil
		end
	end
end

/*---------------------------------------------------------
   Name: OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnCursorEntered()

	if LocalPlayer().Drag then
		LocalPlayer().DragTarget = self
	end

end

/*---------------------------------------------------------
   Name: OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnCursorExited()

	if LocalPlayer().Drag then
		LocalPlayer().DragTarget = nil
	end

end


/*---------------------------------------------------------
   Name: OpenMenu
---------------------------------------------------------*/
function PANEL:OpenMenu()
	local ContextMenu = DermaMenu()
	if self:GetItem() and CAKE.ItemData[self.Item] then
		if !CAKE.ItemData[self:GetItem()].Unusable then
			ContextMenu:AddOption("Use", function() self:UseItem() end)
		end
		for k,v in pairs(CAKE.ItemData[self:GetItem()].RightClick or {}) do
			ContextMenu:AddOption( k, function() self:UseItem(v) end)
		end
		if self:GetWearable() then
			ContextMenu:AddOption("Wear", function() RunConsoleCommand( "rp_wearitem", self:GetItem(), self:GetItemID() ) end)
		end
		if CAKE.WornItems and self:GetItemID() and table.HasValue( CAKE.WornItems, self:GetItemID() ) then
			ContextMenu:AddOption("Take Off", function() RunConsoleCommand( "rp_takeoffitem", self:GetItem(), self:GetItemID() ) end)
		end
		if self:GetWearable() and !string.match( self:GetItem(), "clothing_" ) and !string.match( self:GetItem(), "helmet_" ) then
			local attachto = ContextMenu:AddSubMenu( "Attach to" )
			for _, bone in pairs( BoneList ) do
				attachto:AddOption(bone, function() RunConsoleCommand( "rp_wearitem", self:GetItem(), self:GetItemID(), bone ) end)
			end
		end
		ContextMenu:AddOption("Rename", function() 
		CAKE.StringRequest( "Rename an Item", "Rename '" .. self:GetName() .. "' to what?", self:GetName(),
			function( text )
				LocalPlayer():ConCommand( "rp_renameitem \"" .. self:GetItemID() .. "\" \"" .. text .. "\"" )
			end,
			function() end, "Accept", "Cancel")
		end)
		ContextMenu:AddOption("Drop", function() self:DropItem() end)
		ContextMenu:AddOption("Drop All", function() self:DropAllItem() end)
	end
	ContextMenu:Open()
	
end

--All of the drawing goes here.
function PANEL:Paint()
	x, y = self:ScreenToLocal( 0, 0 )
	surface.SetDrawColor(50,50,50,255)
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	if self.ItemID and CAKE.UData[self.ItemID] and CAKE.UData[self.ItemID].Container then
		surface.SetDrawColor(0,0,255,255)
		surface.DrawOutlinedRect( 1, 1, self:GetWide()-1, self:GetTall()-1 )
		surface.DrawOutlinedRect( 2, 2, self:GetWide()-2, self:GetTall()-2 )	
	end
	if CAKE.WornItems and self:GetItemID() and table.HasValue( CAKE.WornItems, self:GetItemID() ) then
		surface.SetDrawColor(255,0,0,255)
		surface.DrawOutlinedRect( 1, 1, self:GetWide()-1, self:GetTall()-1 )
		surface.DrawOutlinedRect( 2, 2, self:GetWide()-2, self:GetTall()-2 )
	end
end

vgui.Register( "InventorySlot", PANEL, "Panel" )

--Internal to be hooked to the "Inventory" tab on the main menu.
function OpenInventory()
	if !CAKE.InventoryFrame then
		CAKE.CreateInventory()
	end
	CAKE.InventoryFrame.Display = !CAKE.InventoryFrame.Display
	CAKE.InventoryFrame:MakePopup()
	CAKE.InventoryFrame:SetVisible( true )
	CAKE.InventoryFrame:SetKeyboardInputEnabled( false )
	CAKE.InventoryFrame:SetMouseInputEnabled( true )
	CAKE.InventoryFrame.CloseButton:SetVisible(true)
	if !CAKE.InventoryFrame.Display then
		CAKE.InventoryFrame.Display = false
	 	CAKE.InventoryFrame:SetKeyboardInputEnabled( false )
		CAKE.InventoryFrame:SetMouseInputEnabled( false )
	 	CAKE.InventoryFrame.CloseButton:SetVisible(false)
	 	CAKE.InventoryFrame:RequestFocus()
	end
end

--Same as above.
function CloseInventory()
	CAKE.InventoryFrame.Display = false
	CAKE.InventoryFrame:SetKeyboardInputEnabled( false )
	CAKE.InventoryFrame:SetMouseInputEnabled( false )
	CAKE.InventoryFrame.CloseButton:SetVisible(false)
	CAKE.InventoryFrame:RequestFocus()
end

function CAKE.CreateInventory()

	if CAKE.Inventory == "none" then
		return
	end

	if CAKE.InventoryFrame then
		CAKE.InventoryFrame:Remove()
	end

	CAKE.InventorySlot = {}

	local container = CAKE.Containers[CAKE.Inventory]

	CAKE.InventoryFrame = vgui.Create( "DFrame" )
	CAKE.InventoryFrame:SetSize( 566, 50 + (math.Clamp(CAKE.ConVars[ "PlayerInventoryRows" ],1,4) * 56) )
	if CAKE.MinimalHUD:GetBool() then
		CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, ScrH() )
	else
		if CAKE.InventoryFrame.PropertySheet then
			CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, ScrH() - 100 )
		else
			CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, ScrH() - 79 )
		end
	end
	CAKE.InventoryFrame.Display = false
	CAKE.InventoryFrame:SetDeleteOnClose( false )
	CAKE.InventoryFrame:SetMouseInputEnabled( true )
	local x, y
	local color = CAKE.BaseColor or Color( 100, 100, 115, 150 )
	local alpha = 0
	local matBlurScreen = Material( "pp/blurscreen" ) 
	CAKE.InventoryFrame.OnCursorEntered = function()
		LocalPlayer().MouseInFrame = true
	end
	CAKE.InventoryFrame.OnCursorExited = function()
		LocalPlayer().MouseInFrame = false
	end
	CAKE.InventoryFrame.Paint = function()
		if CAKE.InventoryFrame.Display then
			x,y = CAKE.InventoryFrame:GetPos()
			if !CAKE.InventoryFrame.PropertySheet then
				if y != ScrH() - 250 then
					CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, Lerp( 0.2, y, ScrH() - 250 ))
				end
			else
				if y != ScrH() - 270 then
					CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, Lerp( 0.2, y, ScrH() - 270 ))
				end
			end
			alpha = Lerp( 0.1, alpha, 1 )

			surface.SetDrawColor( color.r, color.g, color.b, alpha * 80 )
			if !CAKE.InventoryFrame.PropertySheet then
				surface.DrawRect( 0, 23 , CAKE.InventoryFrame:GetWide(), CAKE.InventoryFrame:GetTall() )
			else
				surface.DrawRect( 0, 43 , CAKE.InventoryFrame:GetWide(), CAKE.InventoryFrame:GetTall() )
			end

		else
			alpha = 0
			x,y = CAKE.InventoryFrame:GetPos()
			if CAKE.MinimalHUD:GetBool() then
				if y != ScrH() then
					CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, Lerp( 0.2, y, ScrH() ))
				end
			else
				if !CAKE.InventoryFrame.PropertySheet then
					if y != ScrH() - 79 then
						CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, Lerp( 0.2, y, ScrH() - 79 ))
					end
				else
					if y != ScrH() - 106 then
						CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, Lerp( 0.2, y, ScrH() - 106 ))
					end
				end
			end
		end
	end

	CAKE.InventoryFrame:SetTitle( "" )
	CAKE.InventoryFrame:SetDraggable( false )
	CAKE.InventoryFrame:ShowCloseButton( false )

	CAKE.InventoryFrame.CloseButton = vgui.Create( "DSysButton", CAKE.InventoryFrame )
	CAKE.InventoryFrame.CloseButton:SetType( "none" )
	CAKE.InventoryFrame.CloseButton:SetSize(18,18)
	CAKE.InventoryFrame.CloseButton:SetPos( CAKE.InventoryFrame:GetWide() - 22, 4 )
	CAKE.InventoryFrame.CloseButton:SetVisible(false)
	CAKE.InventoryFrame.CloseButton.PaintOver = function()
		draw.SimpleTextOutlined( "r", "Marlett", 0,0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 2, Color( 0, 0, 0, 255 ))
	end
	CAKE.InventoryFrame.CloseButton.DoClick = function()
	 	CAKE.InventoryFrame.Display = false
	 	CAKE.InventoryFrame:SetKeyboardInputEnabled( false )
		CAKE.InventoryFrame:SetMouseInputEnabled( false )
	 	CAKE.InventoryFrame.CloseButton:SetVisible(false)
	 	CAKE.InventoryFrame:RequestFocus()
 	end
	CAKE.InventoryFrame.CloseButton:SetDrawBorder( false )
	CAKE.InventoryFrame.CloseButton:SetDrawBackground( false )

	if CAKE.Containers[CAKE.Inventory].Height <= 4 or CAKE.Containers[CAKE.Inventory].Height == 0 then
		local grid = vgui.Create( "DGrid", CAKE.InventoryFrame )
		grid:Dock(FILL)
		grid:SetCols( 10 )
		grid:SetColWide( 56 )
		grid:SetRowHeight( 56 )

		for i=1, container.Height do
			CAKE.InventorySlot[i] = {}
			for j=1, container.Width do
				local slot = vgui.Create( "InventorySlot" )
				slot:SetIconSize( 48 )
				slot:SetPosition( j, i )
				slot:SetContainer(CAKE.Inventory)
				grid:AddItem(slot)
				CAKE.InventorySlot[i][j] = slot
			end 
		end

	else
		CAKE.InventoryFrame.PropertySheet = vgui.Create( "DPropertySheet", CAKE.InventoryFrame )
		CAKE.InventoryFrame.PropertySheet:Dock(FILL)
		CAKE.InventoryFrame.PropertySheet:SetShowIcons( false )
		CAKE.InventoryFrame.PropertySheet.Paint = function()
		end
		local count = CAKE.Containers[CAKE.Inventory].Height
		local it = 0
		while count > 4 do
			count = count - 4
			local grid = vgui.Create( "DGrid" )
			grid:Dock(FILL)
			grid:SetCols( 10 )
			grid:SetColWide( 56 )
			grid:SetRowHeight( 56 )

			for i=1 + (it * 4), (it + 1) * 4 do
				CAKE.InventorySlot[i] = {}
				for j=1, container.Width do
					local slot = vgui.Create( "InventorySlot" )
					slot:SetIconSize( 48 )
					slot:SetPosition( j, i )
					slot:SetContainer(CAKE.Inventory)
					grid:AddItem(slot)
					CAKE.InventorySlot[i][j] = slot
				end 
			end
			local tab = CAKE.InventoryFrame.PropertySheet:AddSheet( "Page " .. it + 1, grid, "", false, false, "Page " .. it + 1 )
			tab.Tab.Image:SetVisible(false)
			it = it + 1
		end
		if count > 0 then
			local grid = vgui.Create( "DGrid" )
			grid:Dock(FILL)
			grid:SetCols( 10 )
			grid:SetColWide( 56 )
			grid:SetRowHeight( 56 )

			for i=container.Height - count + 1, container.Height do
				CAKE.InventorySlot[i] = {}
				for j=1, container.Width do
					local slot = vgui.Create( "InventorySlot" )
					slot:SetIconSize( 48 )
					slot:SetPosition( j, i )
					slot:SetContainer(CAKE.Inventory)
					grid:AddItem(slot)
					CAKE.InventorySlot[i][j] = slot
				end 
			end
			local tab = CAKE.InventoryFrame.PropertySheet:AddSheet( "Page " .. it + 1, grid, "", false, false, "Page " .. it + 1 )
			tab.Tab.Image:SetVisible(false)
		end
		for _,item in pairs( CAKE.InventoryFrame.PropertySheet.Items ) do
			item.Tab.Paint = function()
				if item.Tab:GetPropertySheet():GetActiveTab() == item.Tab then
					draw.RoundedBox( 2, 0, 0, item.Tab:GetWide() - 8, item.Tab:GetTall(), Color( color.r, color.g, color.b, 80 ) )
					item.Tab:SetTextColor( Color( 225, 225, 225, 255 ) )
				else
					draw.RoundedBox( 2, 1, 1, item.Tab:GetWide() - 9, item.Tab:GetTall() - 1, Color( color.r, color.g, color.b, 80 ))
					item.Tab:SetTextColor( Color( 225, 225, 225, 255 ) )
				end
			end
		end
		CAKE.InventoryFrame:SetSize(576, 70 + 4 * 56)
	end
	CAKE.InventoryFrame.OldThink = CAKE.InventoryFrame.Think
	CAKE.InventoryFrame.Think = function()
		CAKE.InventoryFrame:OldThink()
		if CAKE.Containers[CAKE.Inventory] then
			if CAKE.Containers[CAKE.Inventory].Resized then
				CAKE.Containers[CAKE.Inventory].Resized = false
				CAKE.CreateInventory()
			end
			for i, tbl in pairs(CAKE.InventorySlot) do
				for j, v in pairs(tbl) do
					if v then
						if CAKE.Containers[CAKE.Inventory]:IsSlotEmpty(j,i) then
							v:ClearItem()
						elseif CAKE.Containers[CAKE.Inventory].Items[i][j] then
							if v.Item != CAKE.Containers[CAKE.Inventory].Items[i][j].class or (v.ItemID and v.ItemID != CAKE.Containers[CAKE.Inventory].Items[i][j].itemid) then
								v:SetItem( CAKE.Containers[CAKE.Inventory].Items[i][j].class, CAKE.Containers[CAKE.Inventory].Items[i][j].itemid )
							end
						end
					end
				end
			end
		end
	end
end


function CLPLUGIN.Init()
	CAKE.RegisterMenuTab( "Inventory", OpenInventory, CloseInventory )
end