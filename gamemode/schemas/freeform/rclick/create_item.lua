RCLICK.Name = "Item out of prop"
RCLICK.SubMenu = "Create"

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

function RCLICK.Condition(target)

	if ValidEntity( target) and target:GetClass() == "prop_physics" and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) == 0 then return true end

end

function RCLICK.Click(target,ply)

	local bone = BoneList[1]

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( "Create an item" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )

	local InnerPanel = vgui.Create( "DPanelList", Window )
	InnerPanel:SetSpacing( 5 )
	InnerPanel:SetPadding( 5 )

	local Text = vgui.Create( "DLabel" )
	Text:SetText( "Enter the name you want to give to the new item." )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( color_white )
	InnerPanel:AddItem( Text )

	local TextEntry = vgui.Create( "DTextEntry" )
	TextEntry:SetText( "Name" )
	InnerPanel:AddItem( TextEntry )

	local CheckBox = vgui.Create( "DCheckBoxLabel" )
	CheckBox:SetPos( 10,50 )
	CheckBox:SetText( "Can this item be picked up?" )
	CheckBox:SetContentAlignment( 5 )
	CheckBox:SetValue( 1 )
	CheckBox:SizeToContents()
	InnerPanel:AddItem( CheckBox )

	local CheckBox2 = vgui.Create( "DCheckBoxLabel" )
	CheckBox2:SetPos( 10,50 )
	CheckBox2:SetText( "Wearable Item?" )
	CheckBox2:SetContentAlignment( 5 )
	CheckBox2:SetValue( 0 )
	CheckBox2:SizeToContents()
	InnerPanel:AddItem( CheckBox2 )

	local Label = vgui.Create( "DLabel" )
	Label:SetText( "If wearable, on which bone should this be worn?" )
	Label:SizeToContents()
	Label:SetContentAlignment( 5 )
	Label:SetTextColor( color_white )
	InnerPanel:AddItem( Label )

	local MultiChoice = vgui.Create( "DComboBox", InnerPanel )
	for k, v in pairs( BoneList ) do
		MultiChoice:AddChoice( v )
	end
	MultiChoice:SizeToContents()
	MultiChoice.OnSelect = function(panel,index,value) bone = value end
	InnerPanel:AddItem( MultiChoice )

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )

	local Button = vgui.Create( "DButton", ButtonPanel )
	Button:SetText( "Accept" )
	Button:SizeToContents()
	Button:SetTall( 20 )
	Button:SetWide( Button:GetWide() + 20 )
	Button:SetPos( 5, 5 )
	Button.DoClick = function() Window:Close() ply:ConCommand("rp_turnintoitem " .. target:EntIndex() .. " \"" .. TextEntry:GetValue() .. "\" " .. tostring( CheckBox:GetChecked() ) .. " " .. tostring( CheckBox2:GetChecked() ) .. " \"" .. bone .. "\"" ) end

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

	/*
	TIRA.StringRequest( "Item Conversion", "Enter the name you want to give to the new item.", target:GetModel(), function( text )
		ply:ConCommand("rp_admin converttoitem " .. target:EntIndex() .. " \"" .. text .. "\"" )
	end,
	function() end, "Accept", "Cancel")*/

end