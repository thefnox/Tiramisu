CAKE.Containers = {}

datastream.Hook( "Tiramisu.OpenContainer", function( handler, id, encoded, decoded )
	local items = decoded.items
	local uid = decoded.uid
	local width = decoded.width
	local height = decoded.height
	local udata = decoded.udata
	table.Merge(CAKE.UData, decoded.udata)
	if !CAKE.Containers[uid] then
		CAKE.Containers[uid] = CAKE.CreateContainerObject( uid )
	end
	CAKE.Containers[uid]:SetSize( width, height )
	CAKE.Containers[uid].Items = items
	CAKE.CreateContainer( width, height, uid )
	if CAKE.InventoryFrame and !CAKE.InventoryFrame.Display then
		OpenInventory()
	end
end)

usermessage.Hook("c_AddTo", function(um)
	local uid = um:ReadString()
	local itemid = um:ReadString()
	local class = um:ReadString()
	local x = um:ReadShort()
	local y = um:ReadShort()
	if CAKE.Containers[uid] then
		CAKE.Containers[uid]:FillSlot( x, y, class, itemid )
	end
end)

usermessage.Hook("c_Take", function(um)
	local uid = um:ReadString()
	local itemid = um:ReadString()
	if CAKE.Containers[uid] then
		CAKE.Containers[uid]:TakeItemID( itemid )
	end
end)

usermessage.Hook("c_ClearS", function(um)
	local uid = um:ReadString()
	local x = um:ReadShort()
	local y = um:ReadShort()
	if CAKE.Containers[uid] then
		CAKE.Containers[uid]:ClearSlot( x, y )
	end
end)

usermessage.Hook("c_Expand", function(um)
	local uid = um:ReadString()
	local height = um:ReadShort()
	if CAKE.Containers[uid] then
		CAKE.Containers[uid].Height = height
		CAKE.Containers[uid].Resized = true
		for i=1, CAKE.Containers[uid].Width do
			CAKE.Containers[uid].Items[i][CAKE.Containers[uid].Height] = {}
		end
	end
end)

hook.Add("PostRenderVGUI", "Tiramisu.DrawDragIcon", function()
	if ValidEntity(LocalPlayer().DragIcon) then
		cam.Start3D( LocalPlayer().DragIcon.viewcords.origin, LocalPlayer().DragIcon.viewcords.angles, LocalPlayer().DragIcon.viewcords.fov, gui.MouseX() - LocalPlayer().DragIcon.Wide/2, gui.MouseY() - LocalPlayer().DragIcon.Tall/2, LocalPlayer().DragIcon.Wide, LocalPlayer().DragIcon.Tall )

			cam.IgnoreZ( true )
			render.SuppressEngineLighting( true )
			render.SetLightingOrigin( LocalPlayer().DragIcon:GetPos() )
			render.ResetModelLighting( 1,1,1 )
			render.SetColorModulation( 1,1,1 )
			render.SetBlend( 1 )

			LocalPlayer().DragIcon:DrawModel()
			
			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
		cam.End3D()
	end
end)

function CAKE.CreateContainer( width, height, uid )
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "Container" )
	frame.ContainerID = uid
	frame.Close = function()
		RunConsoleCommand("rp_closecontainer", frame.ContainerID)
		frame:Remove()
	end
	--frame:NoClipping( true )
	frame:SetSize(width * 56 + 6, height * 56 + 28 )
	frame.Items = {}
	frame:Center()

	local grid = vgui.Create( "DGrid", frame )
	grid:Dock(FILL)
	grid:SetCols( width )
	grid:SetColWide( 56 )
	grid:SetRowHeight( 56 )

	for i=1, height do
		frame.Items[i] = {}
		for j=1, width do
			local slot = vgui.Create( "ContainerSlot" )
			slot:SetIconSize( 48 )
			slot:SetPosition( j, i )
			slot:SetContainer(uid)
			grid:AddItem(slot)
			frame.Items[i][j] = slot
		end 
	end
	frame.OldThink = frame.Think
	frame.Think = function()
		frame:OldThink()
		if CAKE.Containers[frame.ContainerID] then
			for i, tbl in pairs(frame.Items) do
				for j, v in pairs(tbl) do
					if v then
						if CAKE.Containers[frame.ContainerID]:IsSlotEmpty(j,i) then
							v:ClearItem()
						elseif CAKE.Containers[frame.ContainerID].Items[i][j] then
							v:SetItem( CAKE.Containers[frame.ContainerID].Items[i][j].class, CAKE.Containers[frame.ContainerID].Items[i][j].itemid )
						end
					end
				end
			end
		end
	end

	frame:MakePopup()

end

--ContainerSlot_Icon

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
	size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
	size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
	size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
	
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
vgui.Register( "ContainerSlot_Icon", PANEL, "Panel" )

PANEL = {}

AccessorFunc( PANEL, "m_bPaintBackground",			  "PaintBackground" )
AccessorFunc( PANEL, "m_bDisabled",					 "Disabled" )
AccessorFunc( PANEL, "m_bgColor",			   "BackgroundColor" )
Derma_Hook( PANEL, "Paint", "Paint", "Panel" )

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
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
	if !LocalPlayer().Drag and !self.DragDisabled and self:GetItem() then
		LocalPlayer().Drag = true
		LocalPlayer().DragIcon = ClientsideModel( self:GetModel(), RENDER_GROUP_OPAQUE_ENTITY )
		LocalPlayer().DragIcon.Tall = self.IconSize
		LocalPlayer().DragIcon.Wide = self.IconSize
		LocalPlayer().DragIcon.viewcords = PositionSpawnIcon( LocalPlayer().DragIcon, LocalPlayer().DragIcon:GetPos() )
		LocalPlayer().DragIcon:SetModel( self:GetModel() )
		LocalPlayer().DragIcon:SetNoDraw(true)
		--LocalPlayer().DragIcon:MakePopup()
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
   Name: OpenMenu
---------------------------------------------------------*/
function PANEL:OpenMenu()
	if self:GetItem() and CAKE.ItemData[self.Item] and self.ItemID and CAKE.UData[self.ItemID] and CAKE.UData[self.ItemID].Container then
		local ContextMenu = DermaMenu()
		ContextMenu:AddOption("Open", function() RunConsoleCommand("rp_opencontainer", CAKE.UData[self.ItemID].Container) end)
		ContextMenu:Open()
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
end

function PANEL:PaintOver()
end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function PANEL:Think()
	if !input.IsMouseDown( MOUSE_LEFT ) and LocalPlayer().Drag then
		self:EndDrag()
	end
end
vgui.Register( "ContainerSlot", PANEL, "Panel" )