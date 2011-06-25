RCLICK.Name = "Give Credits"

function RCLICK.Condition(target)

if target:IsPlayer() then return true end

end

function RCLICK.Click(target,ply)

	local function PopupCredits()
		local CreditPanel = vgui.Create( "DFrame" );
		CreditPanel:SetPos(gui.MouseX(), gui.MouseY());
		CreditPanel:SetSize( 200, 175 )
		CreditPanel:SetTitle( "Give " .. target:Nick() .. "" ..CurrencyTable.abr);
		CreditPanel:SetVisible(true);
		CreditPanel:SetDraggable(true);
		CreditPanel:ShowCloseButton(true);
		CreditPanel:MakePopup();
						
		local Credits = vgui.Create( "DNumSlider", CreditPanel );
		Credits:SetPos( 25, 50 );
		Credits:SetWide(150);
		Credits:SetText(CurrencyTable.abr .." to Give");
		Credits:SetMin( 0 );
		Credits:SetMax( tonumber(LocalPlayer():GetNWInt("money")) );
		Credits:SetDecimals( 0 );
						
		local Give = vgui.Create( "DButton", CreditPanel );
		Give:SetText("Give");
		Give:SetPos( 25, 125 );
		Give:SetSize( 150, 25 );
		Give.DoClick = function()
			LocalPlayer():ConCommand("rp_givemoney " .. target:EntIndex() .. " " .. math.floor( Credits:GetValue() ));
			CreditPanel:Remove();
			CreditPanel = nil;
			end
	end
	
	PopupCredits()

end