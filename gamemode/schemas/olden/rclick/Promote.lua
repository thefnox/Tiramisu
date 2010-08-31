RCLICK.Name = "Give Credits"

function RCLICK.Condition(target)

	if target:IsPlayer() then
		if CAKE.MyGroup then
			if CAKE.MyGroup.RankPermissions[ "canpromote" ] then
				return true 
			end
		end
	end

end

function RCLICK.Click(target,ply)

		local function PopupPromote()
		local PromotePanel = vgui.Create( "DFrame" );
		PromotePanel:SetPos(gui.MouseX(), gui.MouseY());
		PromotePanel:SetSize( 200, 175 )
		PromotePanel:SetTitle( "Promote " .. target:Nick()  )
		PromotePanel:SetVisible(true);
		PromotePanel:SetDraggable(true);
		PromotePanel:ShowCloseButton(true);
		PromotePanel:MakePopup();
						
		local Ranks = vgui.Create( "DTextEntry", PromotePanel );
		Ranks:SetPos( 25, 50 );
		Ranks:SetWide(150);
		Ranks:SetValue("Enter Rank Here");
						
		local Give = vgui.Create( "DButton", PromotePanel );
		Give:SetText("Promote");
		Give:SetPos( 25, 125 );
		Give:SetSize( 150, 25 );
		Give.DoClick = function()
			LocalPlayer():ConCommand("rp_promote " .. target:Nick() .. " " .. Ranks:GetValue());
			PromotePanel:Remove();
			PromotePanel = nil;
			end
	end
	
	PopupPromote()

end