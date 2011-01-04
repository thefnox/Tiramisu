CLPLUGIN.Name = "Inventory Slot Element"
CLPLUGIN.Author = "F-Nox/Big Bang"

local matHover = Material( "vgui/spawnmenu/hover" )
 
local PANEL = {}
 
AccessorFunc( PANEL, "m_iIconSize",             "IconSize" )
 
/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()
 	
 		if !self:IsEmpty() then
	        self.Icon = vgui.Create( "ModelImage", self )
	        self.Icon:SetMouseInputEnabled( false )
	        self.Icon:SetKeyboardInputEnabled( false )
        
	        
	        self:SetIconSize( 64 ) // Todo: Cookie!
	    else
	    	self.Icon = vgui.Create( "DBevel", self)
	    	
 		end
end
 
/*---------------------------------------------------------
   Name: OnMousePressed
---------------------------------------------------------*/
function PANEL:OnMousePressed( mcode )
 
        if ( mcode == MOUSE_LEFT ) then
                self:DoClick()
        end
        
        if ( mcode == MOUSE_RIGHT ) then
                self:OpenMenu()
        end
 
end
 
function PANEL:OnMouseReleased( mcode )
	if ( mcode == MOUSE_LEFT ) then
		if LocalPlayer().CurSlot == self then
			LocalPlayer().DraggingItem = false
			self:SetItem( LocalPlayer().DraggedItem )
			self:SetItemCount( LocalPlayer().DraggedAmount )
			self:Init()
			self:InvalidateLayout( true, true )
			self:SetModel( LocalPlayer().DraggedModel )
			LocalPlayer().CurSlot = nil
		end
	end
end

function PANEL:SetItem( item )

	self.Item = item
	self:SetToolTip( item )

end

function PANEL:GetItem()

	return self.Item

end

function PANEL:GetItemCount()

	return self.ItemCount or 1

end

function PANEL:IsEmpty()

	if self and self.ItemCount and self.ItemCount > 0 then
		return false
	else
		return true
	end

end

function PANEL:SetEmpty()

	self:SetItemCount( 0 )
	self:SetItem( "" )

end

function PANEL:SetItemCount( count )

	self.ItemCount = count

end
 
/*---------------------------------------------------------
   Name: DoClick
---------------------------------------------------------*/
function PANEL:DoClick()
	if !self:IsEmpty() then
		LocalPlayer().DraggingItem = true
		LocalPlayer().DraggedItem = self:GetItem()
		LocalPlayer().DraggedAmount = self:GetItemCount()
		LocalPlayer().DraggedModel = self:GetModel()
		self:SetEmpty()
		self:Init()
		self:InvalidateLayout( true, true )
	end
end
 
/*---------------------------------------------------------
   Name: OpenMenu
---------------------------------------------------------*/
function PANEL:OpenMenu()

	if !self:IsEmpty() then
		local ContextMenu = DermaMenu()
		ContextMenu:AddOption("Drop", function() LocalPlayer():ConCommand("rp_dropitem " .. self:GetItem()) end)
		ContextMenu:AddOption("Use", function() LocalPlayer():ConCommand("rp_useinventory " .. self:GetItem()) end)
		ContextMenu:Open();
	end

end
 
/*---------------------------------------------------------
   Name: OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnCursorEntered()
 
        self.PaintOverOld = self.PaintOver
        self.PaintOver = self.PaintOverHovered
        if LocalPlayer().DraggingItem then
        	LocalPlayer().CurSlot = self
        end
 
end
 
/*---------------------------------------------------------
   Name: OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnCursorExited()
 
        if ( self.PaintOver == self.PaintOverHovered ) then
                self.PaintOver = self.PaintOverOld
        end
 
end
 
/*---------------------------------------------------------
   Name: PaintOverHovered
---------------------------------------------------------*/
function PANEL:PaintOverHovered()
 
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( matHover )
        self:DrawTexturedRect()
 
end
 
/*---------------------------------------------------------
   Name: OnMouseReleased
---------------------------------------------------------*/
function PANEL:PerformLayout()
 	
        self:SetSize( self.m_iIconSize, self.m_iIconSize )      
        self.Icon:StretchToParent( 0, 0, 0, 0 )
end
 
/*---------------------------------------------------------
   Name: PressedAnim
---------------------------------------------------------*/
function PANEL:SetModel( mdl, iSkin )
 	
 	if !self.IsEmpty() then
        if (!mdl) then debug.Trace() return end
 		
 		self.MyModel = mdl
        self.Icon:SetModel( mdl, iSkin )
        
        if ( iSkin && iSkin > 0 ) then
                self:SetToolTip( Format( "%s (Skin %i)", mdl, iSkin+1 ) )
        else
                self:SetToolTip( Format( "%s", mdl ) )
        end
 	end
end

function PANEL:GetModel()

	return self.MyModel

end
 
 
/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function PANEL:Think()
 
end
 
/*---------------------------------------------------------
   Name: RebuildSpawnIcon
---------------------------------------------------------*/
function PANEL:RebuildSpawnIcon()
 	if !self:IsEmpty() then
        self.Icon:RebuildSpawnIcon()
 	end
end
 
 
vgui.Register( "InventorySlot", PANEL, "Panel" )

function CLPLUGIN.Init()
	
end