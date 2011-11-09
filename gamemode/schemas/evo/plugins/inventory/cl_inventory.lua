CLPLUGIN.Name = "Inventory Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"

InventoryTable = {}
CAKE.InventorySlot = {}
CAKE.SavedPositions = {}

--Saves a player's icon positioning preferences.
local function SavePositions()
	if CAKE.InventorySlot then
		for k, v in ipairs( CAKE.InventorySlot ) do
			if v:GetItem() then
				CAKE.SavedPositions[v:GetItem().Class] = k
			end 
		end
	end
	file.Write( CAKE.Name .. "/personaldata/inventory.txt", glon.encode( CAKE.SavedPositions ) )
end

--Loads a player's icon positioning preferences.
local function LoadPositions()
	if file.Exists( CAKE.Name .. "/personaldata/inventory.txt" ) then
		CAKE.SavedPositions = glon.decode( file.Read( CAKE.Name .. "/personaldata/inventory.txt"  ))
	else
		SavePositions()
	end
end

--Determines which slots are available for item placement.
local function AvailableSlot()
	if CAKE.InventorySlot then
		for k, v in ipairs( CAKE.InventorySlot ) do
			if !v:GetItem() then
				return k
			end 
		end
	end
	return false
end

--Eliminates all items from all slots.
local function ClearAllSlots()
	if CAKE.InventorySlot then
		for k, v in ipairs( CAKE.InventorySlot ) do
			if v:GetItem() then
				v:ClearItem()
			end 
		end
	end
end

--Determines on which slot should the item in question be placed.
local function CalculateItemPosition( item )
	local slot
	if CAKE.SavedPositions[ item ] then
		if CAKE.InventorySlot[ CAKE.SavedPositions[ item ] ]:GetItem() and CAKE.InventorySlot[ CAKE.SavedPositions[ item ] ]:GetItem().Class == item then
			return CAKE.SavedPositions[ item ]
		elseif !CAKE.InventorySlot[ CAKE.SavedPositions[ item ] ]:GetItem() and CAKE.SavedPositions[ item ] < AvailableSlot() then
			return CAKE.SavedPositions[ item ]
		else
			return AvailableSlot()
		end
	else
		return AvailableSlot()
	end
end

--InventorySlot_Icon

--Taken from Garry's spawnicon code. Calculates view position and angles for most things.
local function RenderSpawnIcon_Prop( model, pos, middle, size )

	size = size * (1 - ( size / 900 ))

	local ViewAngle = Angle( 25, 40, 0 )
	local ViewPos = pos + ViewAngle:Forward() * size * -15
	local view = {}
	
	view.fov		= 4 + size * 0.04
	view.origin 	= ViewPos + middle
	view.znear		= 1
	view.zfar		= ViewPos:Distance( pos ) + size * 2
	view.angles		= ViewAngle

	return view
	
end

--Determines positioning for bipeds.
local function RenderSpawnIcon_Ragdoll( model, pos, middle, size )

	local at = model:GetAttachment( model:LookupAttachment( "eyes" ) )

	local ViewAngle = at.Ang + Angle( -10, 160, 0 )
	local ViewPos = at.Pos + ViewAngle:Forward() * -60 + ViewAngle:Up() * -2
	local view = {}
	
	view.fov		= 10
	view.origin 	= ViewPos
	view.znear		= 0.01
	view.zfar		= 200
	view.angles		= ViewAngle

	return view
	
end

//
// For some TF2 ragdolls which do not have "eye" attachments
//
local function RenderSpawnIcon_Ragdoll_Head( model, pos, middle, size )

	local at = model:GetAttachment( model:LookupAttachment( "head" ) )

	local ViewAngle = at.Ang + Angle( -10, 160, 0 )
	local ViewPos = at.Pos + ViewAngle:Forward() * -67 + ViewAngle:Up() * -7 + ViewAngle:Right() * 1.5
	local view = {}
	
	view.fov		= 10
	view.origin 	= ViewPos
	view.znear		= 0.01
	view.zfar		= 200
	view.angles		= ViewAngle

	return view
	
end

--Determines which of the above positioning schemes to use.
function PositionSpawnIcon( model, pos )

	local mn, mx = model:GetRenderBounds()
	local middle = (mn + mx) * 0.5
	local size = 0
	size = math.max( size, math.abs(mn.x) + math.abs(mx.x) );
	size = math.max( size, math.abs(mn.y) + math.abs(mx.y) );
	size = math.max( size, math.abs(mn.z) + math.abs(mx.z) );
	
	model:SetPos( pos )
	model:SetAngles( Angle( 0, 180, 0 ) )
	
	if ( model:LookupAttachment( "eyes" ) > 0 ) then
		return RenderSpawnIcon_Ragdoll( model, pos, middle, size )
	end
	
	if ( model:LookupAttachment( "head" ) > 0 ) then
		return RenderSpawnIcon_Ragdoll_Head( model, pos, middle, size )
	end

	return RenderSpawnIcon_Prop( model, pos, middle, size )

end

local PANEL = {}

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()

    self:SetMouseInputEnabled( false )
    self:SetKeyboardInputEnabled( false )

end

function PANEL:OnMousePressed( mcode )
end

function PANEL:OnMouseReleased()
end

function PANEL:DoClick()
end

function PANEL:OpenMenu()
end

function PANEL:OnCursorEntered()
end

function PANEL:OnCursorExited()
end

function PANEL:PerformLayout()
end

--Does the actual 3D drawing.
function PANEL:Paint()

    if ( !IsValid( self.Entity ) ) then return end
    
    local x, y = self:LocalToScreen( 0, 0 )
    
    cam.Start3D( self.ViewCoords.origin, self.ViewCoords.angles, self.ViewCoords.fov, x, y, self:GetSize() )
	    cam.IgnoreZ( true )
	    
	    render.SuppressEngineLighting( true )
	    render.SetLightingOrigin( self.Entity:GetPos() )
        render.ResetModelLighting( 1,1,1 )
        render.SetColorModulation( 1,1,1 )
        render.SetBlend( 1 )

	    self.Entity:DrawModel()
	    
	    render.SuppressEngineLighting( false )
	    cam.IgnoreZ( false )
    cam.End3D()
    
end

--Sets the icon's model.
function PANEL:SetModel( mdl )

    // Note - there's no real need to delete the old
    // entity, it will get garbage collected, but this is nicer.
    if ( IsValid( self.Entity ) ) then
        self.Entity:Remove()
        self.Entity = nil        
    end
    
    // Note: Not in menu dll
    if ( !ClientsideModel ) then return end
    
    self.Entity = ClientsideModel( mdl, RENDER_GROUP_OPAQUE_ENTITY )
    if ( !IsValid(self.Entity) ) then return end

    self.Entity:SetNoDraw( true )
    self.ViewCoords = PositionSpawnIcon( self.Entity, self.Entity:GetPos() )

end

function PANEL:Think()

end

vgui.Register( "InventorySlot_Icon", PANEL, "Panel" )

--InventorySlot. The square slots used on the inventory.

PANEL = {}

AccessorFunc( PANEL, "m_bPaintBackground",              "PaintBackground" )
AccessorFunc( PANEL, "m_bDisabled",                     "Disabled" )
AccessorFunc( PANEL, "m_bgColor",               "BackgroundColor" )
Derma_Hook( PANEL, "Paint", "Paint", "Panel" )

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()
    self:SetPaintBackground( true )
        
    // This turns off the engine drawing
    self:SetPaintBackgroundEnabled( false )
    self:SetPaintBorderEnabled( false )
    self.Icon = vgui.Create( "InventorySlot_Icon", self )
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

--If it has any items, sets the amount of them
function PANEL:SetAmount( amount )
	self.Amount = amount or 1
end

--Sets an item to be used on the inventory slot. The item thing is a table, not a string. Amount defaults to 1.
function PANEL:SetItem( item, amount )
	self.Item = item
	if !self.Icon then
		self.Icon = vgui.Create( "InventorySlot_Icon", self )
		self:SetIconSize( self.IconSize )
	end
	if item.Description != "" then self:SetToolTip( item.Name .. "\n" .. item.Description )
	else self:SetToolTip( item.Name ) end
	self.Icon:SetModel( item.Model )
	self:SetAmount( amount or 1 )
	self:OnUseItem( item, amount )
end

--Utility function. Allows you to set an item to a slot, and if that item already exists on that slot, add one to it.
function PANEL:AddItem( item )
	if self:GetItem() and self:GetItem().Class == item.Class then
		self:SetAmount( self:GetAmount() + 1 )
	else
		self:SetItem( item, 1 )
	end
end

--In case you need to hook anything on item usage.
function PANEL:OnUseItem( item, amount )
end

--Returns the item table.
function PANEL:GetItem()
	return self.Item
end

--Returns the current item amount.
function PANEL:GetAmount()
	return self.Amount or 1
end

--Clears the item off the slot.
function PANEL:ClearItem()

	if self.Icon then
		self.Icon:Remove()
		self.Icon = nil
	end
	self.Item = false
	self:SetAmount()
	self:SetToolTip( "Empty Slot" )

end

--Discounts one item from the slot. If this reduces the count to 0, then it clears the slot.
function PANEL:RemoveItem()

	if self.Item then
		local count = self:GetAmount() - 1
		if count > 0 then
			self:SetAmount( count - 1 )
		else
			self:ClearItem()
		end
	end

end

--Disables dragging in and out on that slot.
function PANEL:DisableDrag()
	self.DragDisabled = !self.DragDisabled
end

--Utility to handle item dropping.
function PANEL:DropItem()
	if self.Item then
		if !self:GetItem().Stack then
			LocalPlayer():ConCommand("rp_dropitem " .. self:GetItem().ID )
		else
			LocalPlayer():ConCommand("rp_dropitemunspecific " .. self:GetItem().Class )
		end
		self:RemoveItem()
	end
end

function PANEL:DropAllItem()
	if self.Item then
		LocalPlayer():ConCommand("rp_dropallitem " .. self:GetItem().Class )
	end
end

--Utility to handle item using.
function PANEL:UseItem(dofunc)
	if self.Stack then 
		command = "rp_useinventory "
		argone = self:GetItem().Class 
	else
		command = "rp_useinventoryid "
		argone = self:GetItem().ID
	end
	if self.Item and dofunc then
		LocalPlayer():ConCommand(command .. argone .. " " .. dofunc )
		self:RemoveItem()
	elseif self.Item and !self:GetItem().Unusable then
		LocalPlayer():ConCommand(command .. argone )
		self:RemoveItem()
	end
end

/*---------------------------------------------------------
   Name: OnMousePressed
---------------------------------------------------------*/
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
	if !LocalPlayer().OnDrag and !self.DragDisabled and self:GetItem() then
		LocalPlayer().OnDrag = true
		LocalPlayer().DragIcon = vgui.Create( "InventorySlot_Icon" )
		LocalPlayer().DragIcon:SetSize( self.IconSize, self.IconSize )
		LocalPlayer().DragIcon:MoveToFront( )
		LocalPlayer().DragIcon:SetModel( self:GetItem().Model )
		LocalPlayer().DragOrigin = self
		LocalPlayer().DragAmount = self:GetAmount()
		LocalPlayer().DragItem = self:GetItem()
		LocalPlayer().DragIcon.Think = function()
			LocalPlayer().DragIcon:SetPos( gui.MousePos() )
		end
		LocalPlayer().DragIcon.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("TabLarge");
			surface.SetTextPos( LocalPlayer().DragIcon:GetWide() - 12, LocalPlayer().DragIcon:GetTall() - 14);
			surface.DrawText( LocalPlayer().DragAmount )
		end
		self:ClearItem()
	end
end

--Finishes dragging operation. Performs the actual transfer operation.
function PANEL:EndDrag()
	if LocalPlayer().OnDrag and !self.DragDisabled then
		LocalPlayer().OnDrag = false
		LocalPlayer().DragIcon:Remove()
		LocalPlayer().DragIcon = nil
		if LocalPlayer().DragTarget then
			if LocalPlayer().DragTarget:GetItem() then
				--Trade items between the origin and target slots.
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
	SavePositions()
end

/*---------------------------------------------------------
   Name: OpenMenu
---------------------------------------------------------*/
function PANEL:OpenMenu()

	local ContextMenu = DermaMenu()
		if !self:GetItem().Unusable then
			ContextMenu:AddOption("Use", function() self:UseItem() end)
		end
		for k,v in pairs(self:GetItem().RightClick or {}) do
			ContextMenu:AddOption( k, function() self:UseItem(v) end)
		end
		if (self:GetItem().Wearable or string.match( self:GetItem().Class, "clothing_" ) or string.match( self:GetItem().Class, "helmet_" )) then
			ContextMenu:AddOption("Wear", function() RunConsoleCommand( "rp_wearitem", self:GetItem().Class, self:GetItem().ID ) end)
		end
		ContextMenu:AddOption("Drop", function() self:DropItem() end)
		if self.Amount > 1 then ContextMenu:AddOption("Drop All", function() self:DropAllItem() end) end
	ContextMenu:Open()
	
end

/*---------------------------------------------------------
   Name: OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnCursorEntered()

	if LocalPlayer().OnDrag then
		LocalPlayer().DragTarget = self
	end

end

/*---------------------------------------------------------
   Name: OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnCursorExited()

	if LocalPlayer().OnDrag then
		LocalPlayer().DragTarget = nil
	end

end

--All of the drawing goes here.
function PANEL:Paint()
	x, y = self:ScreenToLocal( 0, 0 )
	surface.SetDrawColor(50,50,50,255)
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
end

--Draws the item count
function PANEL:PaintOver()
	if self:GetAmount() > 1 then
		surface.SetTextColor(Color(255,255,255,255));
		surface.SetFont("TabLarge");
		surface.SetTextPos( self:GetWide() - 16, self:GetTall() - 14);
		surface.DrawText( self:GetAmount() )
	end
end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function PANEL:Think()
	if !input.IsMouseDown( MOUSE_LEFT ) and LocalPlayer().OnDrag then
		self:EndDrag()
	end
end


vgui.Register( "InventorySlot", PANEL, "Panel" )

--Internal to be hooked to the "Inventory" tab on the main menu.
local function OpenInventory()
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
local function CloseInventory()
	CAKE.InventoryFrame.Display = false
    CAKE.InventoryFrame:SetKeyboardInputEnabled( false )
    CAKE.InventoryFrame:SetMouseInputEnabled( false )
    CAKE.InventoryFrame.CloseButton:SetVisible(false)
    CAKE.InventoryFrame:RequestFocus()
end

datastream.Hook("addinventory", function(handler, id, encoded, decoded )

	ClearAllSlots()

	InventoryTable = decoded

	for k, v in pairs( decoded ) do
		possiblename = v.Name
		possiblemodel = v.Model

		for key, val in pairs(CAKE.ItemData[v.Class]) do
			v[key] = val
		end

		if v.Stack == nil then v.Stack = true end
		v.Name = possiblename or v.Name
		v.Model = possiblemodel or v.Model

		if !v.Stack then
			CAKE.InventorySlot[ AvailableSlot( ) ]:AddItem( v )
		elseif CalculateItemPosition( v.Class ) and CAKE.InventorySlot[ CalculateItemPosition( v.Class ) ] then
			CAKE.InventorySlot[ CalculateItemPosition( v.Class ) ]:AddItem( v ) 
		end
	end
	SavePositions()
	
end )

hook.Add( "InitPostEntity", "TiramisuCreateQuickBar", function()
	
	--Everything related to the layout of the inventory goes here.

	LoadPositions()
	CAKE.InventoryFrame = vgui.Create( "DFrame" )
	CAKE.InventoryFrame:SetSize( 560, 260 )
	if CAKE.MinimalHUD:GetBool() then
		CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, ScrH() )
	else
		CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, ScrH() - 79 )
	end
	CAKE.InventoryFrame.Display = false
	CAKE.InventoryFrame:SetDeleteOnClose( false )
	CAKE.InventoryFrame:SetMouseInputEnabled( true )
	local x, y
	local color = CAKE.BaseColor or Color( 100, 100, 115, 150 )
	local alpha = 0
	local matBlurScreen = Material( "pp/blurscreen" ) 
	CAKE.InventoryFrame.Paint = function()
		if CAKE.InventoryFrame.Display then
			x,y = CAKE.InventoryFrame:GetPos()
			if y != ScrH() - 250 then
				CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, Lerp( 0.2, y, ScrH() - 250 ))
			end
			alpha = Lerp( 0.1, alpha, 1 )

			surface.SetDrawColor( color.r, color.g, color.b, alpha * 80 )
    		surface.DrawRect( 0, 23 , CAKE.InventoryFrame:GetWide(), CAKE.InventoryFrame:GetTall() )

		else
			alpha = 0
			x,y = CAKE.InventoryFrame:GetPos()
			if CAKE.MinimalHUD:GetBool() then
				if y != ScrH() then
					CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, Lerp( 0.2, y, ScrH() ))
				end
			else
				if y != ScrH() - 79 then
					CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, Lerp( 0.2, y, ScrH() - 79 ))
				end
			end
		end
	end

	CAKE.InventoryFrame:SetTitle( "" )
	CAKE.InventoryFrame:SetDraggable( false )
	CAKE.InventoryFrame:ShowCloseButton( false )

	CAKE.InventoryFrame.CloseButton = vgui.Create( "DSysButton", CAKE.InventoryFrame )
    CAKE.InventoryFrame.CloseButton:SetType( "close" )
    CAKE.InventoryFrame.CloseButton:SetSize(18,18)
    CAKE.InventoryFrame.CloseButton:SetPos( CAKE.InventoryFrame:GetWide() - 22, 4 )
    CAKE.InventoryFrame.CloseButton:SetVisible(false)
    CAKE.InventoryFrame.CloseButton.DoClick = function()
     	CAKE.InventoryFrame.Display = false
     	CAKE.InventoryFrame:SetKeyboardInputEnabled( false )
    	CAKE.InventoryFrame:SetMouseInputEnabled( false )
     	CAKE.InventoryFrame.CloseButton:SetVisible(false)
     	CAKE.InventoryFrame:RequestFocus()
 	end
    CAKE.InventoryFrame.CloseButton:SetDrawBorder( false )
    CAKE.InventoryFrame.CloseButton:SetDrawBackground( false )

	local grid = vgui.Create( "DGrid", CAKE.InventoryFrame )
	grid:SetSize( CAKE.InventoryFrame:GetWide(), 55 )
	grid:SetPos( 2, 23 )
	grid:SetCols( 10 )
	grid:SetColWide( 56 )
	grid:SetRowHeight( 52 )

	local icon
	for i = 1, 10 do
	    icon = vgui.Create( "InventorySlot" )
	    icon:SetIconSize( 48 )
	    CAKE.InventorySlot[ i ] = icon
	    CAKE.InventorySlot[ i ].PaintOver = function()
	        surface.SetTextColor(Color(255,255,255,255))
	        surface.SetFont("TiramisuTabsFont")
	        surface.SetTextPos( 3, 3);
	        surface.DrawText( "ALT+" .. i - 1 )
	        if CAKE.InventorySlot[ i ]:GetAmount() > 1 then
	            surface.SetTextPos( CAKE.InventorySlot[ i ]:GetWide() - 16, CAKE.InventorySlot[ i ]:GetTall() - 14);
	            surface.DrawText( CAKE.InventorySlot[ i ]:GetAmount() )
	        end
	    end
	    grid:AddItem( CAKE.InventorySlot[ i ] )
	end

	local grid2 = vgui.Create( "DGrid", CAKE.InventoryFrame )
	grid2:SetSize( CAKE.InventoryFrame:GetWide(), 110 )
	grid2:SetPos( 2, 83 )
	grid2:SetCols( 10 )
	grid2:SetColWide( 56 )
	grid2:SetRowHeight( 56 )

	for i = 11, 40 do
	    icon = vgui.Create( "InventorySlot" )
	    icon:SetIconSize( 48 )
	    CAKE.InventorySlot[ i ] = icon
	    grid2:AddItem( CAKE.InventorySlot[ i ] )
	end

	local keydown = {}
	hook.Add( "Think", "TiramisuCheckQuickBarKey", function()
		if input.IsKeyDown( KEY_LALT )then
			for i=1, 10 do
				if input.IsKeyDown( i ) and !keydown[ i ] then
					CAKE.InventorySlot[ i ]:UseItem()
					keydown[ i ] = true
				elseif !input.IsKeyDown( i ) and keydown[i] then
					keydown[ i ] = false
				end
			end
		end
	end)

end)

function CLPLUGIN.Init()
	CAKE.RegisterMenuTab( "Inventory", OpenInventory, CloseInventory )
end