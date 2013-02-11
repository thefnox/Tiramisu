RCLICK.Name = "Give " .. CAKE.ConVars[ "CurrencyName" ] .. "s"

function RCLICK.Condition(target)

	if target:IsTiraPlayer() and target != LocalPlayer() and LocalPlayer():GetNWInt( "money", 0 ) > 0 then return true end

end

function RCLICK.Click(target,ply)

	target = target:IsTiraPlayer()

	if LocalPlayer():GetNWInt( "money", 0 ) > 0 then
		local CreditPanel = vgui.Create( "DFrame" )
		CreditPanel:SetPos(gui.MouseX(), gui.MouseY())
		CreditPanel:SetSize( 200, 175 )
		CreditPanel:SetTitle( "Give " .. target:Nick() .. " " ..CAKE.ConVars[ "CurrencySlang" ] .. "s")
		CreditPanel:SetVisible(true)
		CreditPanel:SetDraggable(true)
		CreditPanel:ShowCloseButton(true)
		CreditPanel:MakePopup()
						
		local Credits = vgui.Create( "DNumSlider", CreditPanel )
		Credits:SetPos( 25, 50 )
		Credits:SetWide(150)
		Credits:SetText(CAKE.ConVars[ "CurrencyName" ] .."s to Give")
		Credits:SetMin( 0 )
		Credits:SetMax( tonumber(LocalPlayer():GetNWInt("money", 0)) )
		Credits:SetDecimals( 0 )
						
		local Give = vgui.Create( "DButton", CreditPanel )
		Give:SetText("Give")
		Give:SetPos( 25, 125 )
		Give:SetSize( 150, 25 )
		Give.DoClick = function()
			LocalPlayer():ConCommand("rp_givemoney " .. target:EntIndex() .. " " .. math.floor( Credits:GetValue() ))
			CreditPanel:Remove()
			CreditPanel = nil
		end
	else
		CAKE.Message( "You don't have any money to give!", "Error", "OK :(" )
	end

end