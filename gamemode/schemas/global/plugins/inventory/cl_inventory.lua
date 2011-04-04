CLPLUGIN.Name = "Inventory Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"

InventoryTable = {}
CAKE.InventorySlot = {}
CAKE.SavedPositions = {}

local function SavePositions()
	if CAKE.InventorySlot then
		for k, v in ipairs( CAKE.InventorySlot ) do
			if v:GetItem() then
				CAKE.SavedPositions[v:GetItem().Class] = k
			end 
		end
	end
	file.Write( CAKE.Name .. "/PersonalData/inventory.txt", glon.encode( CAKE.SavedPositions ) )
end

local function LoadPositions()
	if file.Exists( CAKE.Name .. "/PersonalData/inventory.txt" ) then
		CAKE.SavedPositions = glon.decode( file.Read( CAKE.Name .. "/PersonalData/inventory.txt"  ))
	else
		SavePositions()
	end
end

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

local function ClearAllSlots()
	if CAKE.InventorySlot then
		for k, v in ipairs( CAKE.InventorySlot ) do
			if v:GetItem() then
				v:ClearItem()
			end 
		end
	end
end

local function CalculateItemPosition( item )
	local slot
	if CAKE.SavedPositions[ item ] then
		if CAKE.InventorySlot[ CAKE.SavedPositions[ item ] ]:GetItem() and CAKE.InventorySlot[ CAKE.SavedPositions[ item ] ]:GetItem().Class == item then
			return CAKE.SavedPositions[ item ]
		elseif !CAKE.InventorySlot[ CAKE.SavedPositions[ item ] ]:GetItem() then
			return CAKE.SavedPositions[ item ]
		else
			return AvailableSlot()
		end
	else
		return AvailableSlot()
	end
end

--InventorySlot_Icon

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

function PANEL:Paint()

    if ( !IsValid( self.Entity ) ) then return end
    
    local x, y = self:LocalToScreen( 0, 0 )
    
    cam.Start3D( self.ViewCoords.origin, self.ViewCoords.angles, self.ViewCoords.fov, x, y, self:GetSize() )
	    cam.IgnoreZ( true )
	    
	    render.SuppressEngineLighting( true )
	    render.SetLightingOrigin( self.Entity:GetPos() )

	    self.Entity:DrawModel()
	    
	    render.SuppressEngineLighting( false )
	    cam.IgnoreZ( false )
    cam.End3D()
    
end

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

--InventorySlot

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

function PANEL:SetIconSize( size )

	if self.Icon then
		self.IconSize = size
		self:SetSize( size + 4, size + 4 )
		self.Icon:SetSize( size, size )
		self.Icon:SetPos( 2, 2 )
	end

end

function PANEL:SetAmount( amount )
	self.Amount = amount or 1
end

function PANEL:SetItem( item, amount )
	self.Item = item
	if !self.Icon then
		self.Icon = vgui.Create( "InventorySlot_Icon", self )
		self:SetIconSize( self.IconSize )
	end
	self:SetToolTip( item.Name .. ":\n" .. item.Description )
	self.Icon:SetModel( item.Model )
	self:SetAmount( amount or 1 )
	self:OnUseItem( item, amount )
end

function PANEL:AddItem( item )
	if self:GetItem() and self:GetItem().Class == item.Class then
		self:SetAmount( self:GetAmount() + 1 )
	else
		self:SetItem( item, 1 )
	end
end

function PANEL:OnUseItem( item, amount )
end

function PANEL:GetItem()
	return self.Item
end

function PANEL:GetAmount()
	return self.Amount or 1
end

function PANEL:ClearItem()

	if self.Icon then
		self.Icon:Remove()
		self.Icon = nil
	end
	self.Item = false
	self:SetAmount()
	self:SetToolTip( "Empty Slot" )

end

function PANEL:DisableDrag()
	self.DragDisabled = !self.DragDisabled
end

function PANEL:DropItem()
	if self.Item then
		LocalPlayer():ConCommand("rp_dropitem " .. self:GetItem().Class )
	end
end

function PANEL:UseItem()
	if self.Item then
		LocalPlayer():ConCommand("rp_useinventory " .. self:GetItem().Class )
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

function PANEL:EndDrag()
	SavePositions()
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
end

/*---------------------------------------------------------
   Name: OpenMenu
---------------------------------------------------------*/
function PANEL:OpenMenu()
	local ContextMenu = DermaMenu()
		ContextMenu:AddOption("Drop", function() self:DropItem() end)
		ContextMenu:AddOption("Use", function() self:UseItem() end)
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

function PANEL:Paint()
	x, y = self:ScreenToLocal( 0, 0 )
	surface.SetDrawColor(50,50,50,255)
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
end

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

local function CloseInventory()
	CAKE.InventoryFrame.Display = false
    CAKE.InventoryFrame:SetKeyboardInputEnabled( false )
    CAKE.InventoryFrame:SetMouseInputEnabled( false )
    CAKE.InventoryFrame.CloseButton:SetVisible(false)
    CAKE.InventoryFrame:RequestFocus()
end

datastream.Hook("addinventory", function(handler, id, encoded, decoded )
	
	/*
	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();*/

	InventoryTable = decoded

	for k, v in pairs( decoded ) do
		if CalculateItemPosition( v.Class ) then
			CAKE.InventorySlot[ CalculateItemPosition( v.Class ) ]:AddItem( v ) 
		end
	end
	SavePositions()
	
end )

local function ClearItems()
	ClearAllSlots()
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

hook.Add( "InitPostEntity", "TiramisuCreateQuickBar", function()

	LoadPositions()
	CAKE.InventoryFrame = vgui.Create( "DFrameTransparent" )
	CAKE.InventoryFrame:SetSize( 448, 200 )
	CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, ScrH() - 79 )
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
			if y != ScrH() - 172 then
				CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, Lerp( 0.2, y, ScrH() - 195 ))
			end
			alpha = Lerp( 0.1, alpha, 1 )

			surface.SetDrawColor( color.r, color.g, color.b, alpha * 80 )
    		surface.DrawRect( 0, 23 , CAKE.InventoryFrame:GetWide(), CAKE.InventoryFrame:GetTall() )

		else
			alpha = 0
			x,y = CAKE.InventoryFrame:GetPos()
			if y != ScrH() - 58 then
				CAKE.InventoryFrame:SetPos( ScrW() / 2 - CAKE.InventoryFrame:GetWide() / 2, Lerp( 0.2, y, ScrH() - 79 ))
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
	grid:SetCols( 8 )
	grid:SetColWide( 56 )
	grid:SetRowHeight( 52 )

	local icon
	for i = 1, 8 do
	    icon = vgui.Create( "InventorySlot" )
	    icon:SetIconSize( 48 )
	    CAKE.InventorySlot[ i ] = icon
	    CAKE.InventorySlot[ i ].PaintOver = function()
	        surface.SetTextColor(Color(255,255,255,255))
	        surface.SetFont("TiramisuTabsFont")
	        surface.SetTextPos( 3, 3);
	        surface.DrawText( "ALT+" .. i )
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
	grid2:SetCols( 8 )
	grid2:SetColWide( 56 )
	grid2:SetRowHeight( 56 )

	for i = 9, 24 do
	    icon = vgui.Create( "InventorySlot" )
	    icon:SetIconSize( 48 )
	    CAKE.InventorySlot[ i ] = icon
	    grid2:AddItem( CAKE.InventorySlot[ i ] )
	end

	local keydown = {}
	hook.Add( "Think", "TiramisuCheckQuickBarKey", function()
		if input.IsKeyDown( KEY_LALT )then
			for i=1, 8 do
				if input.IsKeyDown( i + 1 ) and !keydown[ i ] then
					CAKE.InventorySlot[ i ]:UseItem()
					keydown[ i ] = true
				elseif !input.IsKeyDown( i + 1 ) and keydown[i] then
					keydown[ i ] = false
				end
			end
		end
	end)

end)

function CLPLUGIN.Init()
	CAKE.RegisterMenuTab( "Inventory", OpenInventory, CloseInventory )
end