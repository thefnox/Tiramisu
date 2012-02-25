RCLICK.Name = "Clothing out of ragdoll"
RCLICK.SubMenu = "Create"

function RCLICK.Condition(target)

	if ValidEntity( target) and target:GetClass() == "prop_physics" and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) <= 3 then return true end

end

function RCLICK.Click(target,ply)

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( "Make a container" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )

	local InnerPanel = vgui.Create( "DPanelList", Window )
	InnerPanel:SetSpacing( 5 )
	InnerPanel:SetPadding( 5 )

	local Height = vgui.Create( "DNumSlider", DermaPanel )
	Height:SetValue(1)
	Height:SetText( "Container Height" )
	Height:SetMin( 1 ) -- Minimum number of the slider
	Height:SetMax( 5 ) -- Maximum number of the slider
	Height:SetDecimals( 0 ) -- Sets a decimal. Zero means it's a whole number
	InnerPanel:AddItem(Height)

	local Width = vgui.Create( "DNumSlider", DermaPanel )
	Width:SetValue(1)
	Width:SetText( "Container Width" )
	Width:SetMin( 1 ) -- Minimum number of the slider
	Width:SetMax( 5 ) -- Maximum number of the slider
	Width:SetDecimals( 0 ) -- Sets a decimal. Zero means it's a whole number
	InnerPanel:AddItem(Width)

	local CheckBox = vgui.Create( "DCheckBoxLabel" )
	CheckBox:SetText( "Can this container be picked up?" )
	CheckBox:SetContentAlignment( 5 )
	CheckBox:SetValue( 1 )
	CheckBox:SizeToContents()
	InnerPanel:AddItem( CheckBox )

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )

	local Button = vgui.Create( "DButton", ButtonPanel )
	Button:SetText( "Accept" )
	Button:SizeToContents()
	Button:SetTall( 20 )
	Button:SetWide( Button:GetWide() + 20 )
	Button:SetPos( 5, 5 )
	Button.DoClick = function() Window:Close() ply:ConCommand("rp_makecontainer " .. target:EntIndex() .. " " .. tostring(Width:GetValue()) .. " " ..  tostring(Height:GetValue()) .. " " .. tostring(CheckBox:GetChecked()) ) end

	local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
	ButtonCancel:SetText( "Cancel" )
	ButtonCancel:SizeToContents()
	ButtonCancel:SetTall( 20 )
	ButtonCancel:SetWide( Button:GetWide() + 20 )
	ButtonCancel:SetPos( 5, 5 )
	ButtonCancel.DoClick = function() Window:Close() end
	ButtonCancel:MoveRightOf( Button, 5 )

	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )

	local w, h = InnerPanel:GetSize()
	w = math.max( w, 400 ) 

	Window:SetSize( w + 50, h + 155 )
	Window:Center()

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()

end