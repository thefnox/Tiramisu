RCLICK.Name = "Set Business"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if target:IsPlayer() and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) >= 2 then return true end

end

function RCLICK.Click(target,ply)

	local checkboxes = {}

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( "Create clothing" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )

	local InnerPanel = vgui.Create( "DPanelList", Window )
	InnerPanel:SetSpacing( 5 )
	InnerPanel:SetPadding( 5 )

	local Text = vgui.Create( "DLabel" )
	Text:SetText( "Set which business permissions should " .. target:Nick() .. " have." )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( color_white )
	InnerPanel:AddItem( Text )

	for k, v in pairs(BusinessLevels) do
		local checkbox = vgui.Create( "DCheckBoxLabel" )
		checkbox:SetText(v.Name)
		checkbox:SetContentAlignment( 5 )
		checkbox:SetValue( 0 )
		checkbox:SizeToContents()
		checkbox.BusinessLevel = k
		InnerPanel:AddItem( checkbox )
		table.insert(checkboxes, checkbox)
	end

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )

	local Button = vgui.Create( "DButton", ButtonPanel )
	Button:SetText( "Accept" )
	Button:SizeToContents()
	Button:SetTall( 20 )
	Button:SetWide( Button:GetWide() + 20 )
	Button:SetPos( 5, 5 )
	Button.DoClick = function()
		local str = "rp_admin addbusiness " .. CAKE.FormatText( target:SteamID() ) .. " "
		for k, v in pairs (checkboxes) do
			if v and v:GetChecked() then
				str = str .. v.BusinessLevel .. " "
			end
		end
		ply:ConCommand(str)
		Window:Close()
	end

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