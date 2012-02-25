RCLICK.Name = "Add Spawnpoint"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target == LocalPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 3 then return true end

end

function RCLICK.Click(target,ply)

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( "Make a spawnpoint on this spot" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )

	local InnerPanel = vgui.Create( "DPanelList", Window )
	InnerPanel:SetSpacing( 5 )
	InnerPanel:SetPadding( 5 )

	local Text = vgui.Create( "DLabel" )
	Text:SetText( "Unique name for this spawnpoint:" )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( color_white )
	InnerPanel:AddItem( Text )

	local TextEntry = vgui.Create( "DTextEntry" )
	TextEntry:SetText( "Name" )
	InnerPanel:AddItem( TextEntry )

	local Spawngroup = vgui.Create( "DNumSlider", DermaPanel )
	Spawngroup:SetValue(0)
	Spawngroup:SetText( "Spawngroup (Leave it at 0 to make regular users use this spawnpoint)" )
	Spawngroup:SetMin( 0 ) -- Minimum number of the slider
	Spawngroup:SetMax( 10 ) -- Maximum number of the slider
	Spawngroup:SetDecimals( 0 ) -- Sets a decimal. Zero means it's a whole number
	InnerPanel:AddItem(Spawngroup)

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )

	local Button = vgui.Create( "DButton", ButtonPanel )
	Button:SetText( "Accept" )
	Button:SizeToContents()
	Button:SetTall( 20 )
	Button:SetWide( Button:GetWide() + 20 )
	Button:SetPos( 5, 5 )
	Button.DoClick = function() Window:Close() ply:ConCommand("rp_admin addspawn " .. tostring(Spawngroup:GetValue()) .. " \"" .. TextEntry:GetValue() .. "\"") end

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

	Window:SetSize( w + 50, h + 125 )
	Window:Center()

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()

end