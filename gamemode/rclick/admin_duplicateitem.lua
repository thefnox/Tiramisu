RCLICK.SubMenu = "Admin"
RCLICK.Name = "Duplicate"

function RCLICK.Condition(target)

	if target:GetClass() == "item_prop" and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 2 then return true end

end

function RCLICK.Click(target,ply)

	local DuplicatePanel = vgui.Create( "DFrame" )
	DuplicatePanel:SetPos(gui.MouseX(), gui.MouseY())
	DuplicatePanel:SetSize( 200, 175 )
	DuplicatePanel:SetTitle( "Duplicate this item how many times?")
	DuplicatePanel:SetVisible(true)
	DuplicatePanel:SetDraggable(true)
	DuplicatePanel:ShowCloseButton(true)
	DuplicatePanel:MakePopup()
					
	local Copies = vgui.Create( "DNumSlider", DuplicatePanel )
	Copies:SetPos( 25, 50 )
	Copies:SetWide(150)
	Copies:SetText("Copies:")
	Copies:SetMin( 1 )
	Copies:SetMax( 100 )
	Copies:SetDecimals( 0 )
					
	local Accept = vgui.Create( "DButton", DuplicatePanel )
	Accept:SetText("Accept")
	Accept:SetPos( 30, 125 )
	Accept:SetSize( 50, 25 )
	Accept.DoClick = function()
		LocalPlayer():ConCommand("rp_admin duplicateitem " .. target:EntIndex() .. " " .. math.floor( Copies:GetValue() ))
		DuplicatePanel:Remove()
		DuplicatePanel = nil
	end

	local Cancel = vgui.Create( "DButton", DuplicatePanel )
	Cancel:SetText("Cancel")
	Cancel:SetPos( 120, 125 )
	Cancel:SetSize( 50, 25 )
	Cancel.DoClick = function()
		DuplicatePanel:Remove()
		DuplicatePanel = nil
	end

end