RCLICK.Name = "Clothing out of ragdoll"
RCLICK.SubMenu = "Create"

function RCLICK.Condition(target)

	if ValidEntity( target) and target:GetClass() == "prop_ragdoll" and target:LookupBone("ValveBiped.Bip01_Head1") and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) == 0 then return true end

end

function RCLICK.Click(target,ply)

	local type = "body"

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( "Create clothing" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )

	local InnerPanel = vgui.Create( "DPanelList", Window )
	InnerPanel:SetSpacing( 5 )
	InnerPanel:SetPadding( 5 )

	local Text = vgui.Create( "DLabel" )
	Text:SetText( "Enter the name you want to give to the new clothing item." )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( color_white )
	InnerPanel:AddItem( Text )

	local TextEntry = vgui.Create( "DTextEntry" )
	TextEntry:SetText( "Name" )
	InnerPanel:AddItem( TextEntry )

	local Label = vgui.Create( "DLabel" )
	Label:SetText( "Where should this be worn?" )
	Label:SizeToContents()
	Label:SetContentAlignment( 5 )
	Label:SetTextColor( color_white )
	InnerPanel:AddItem( Label )

	local MultiChoice = vgui.Create( "DMultiChoice", InnerPanel )
	MultiChoice:AddChoice("body")
	MultiChoice:AddChoice("head")
	MultiChoice:SizeToContents()
	MultiChoice.OnSelect = function(panel,index,value) type = value end
	InnerPanel:AddItem( MultiChoice )

	local CheckBox = vgui.Create( "DCheckBoxLabel" )
	CheckBox:SetPos( 10,50 )
	CheckBox:SetText( "Don't keep the model's hands" )
	CheckBox:SetContentAlignment( 5 )
	CheckBox:SetValue( 0 )
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
	Button.DoClick = function() Window:Close() ply:ConCommand("rp_turnintoclothing " .. target:EntIndex() .. " \"" .. TextEntry:GetValue() .. "\" \"" .. type .. "\" " .. tostring(CheckBox:GetChecked()) ) end

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

	Window:SetSize( w + 50, h + 185 )
	Window:Center()

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()

end