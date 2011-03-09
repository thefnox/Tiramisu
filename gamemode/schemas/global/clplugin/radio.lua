CLPLUGIN.Name = "Radio"
CLPLUGIN.Author = "FNox"

--Keeping shit neat.
function CAKE.CreateRadioMenu()
	if !RadioPanel then
		RadioPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
		RadioPanel:SetPos( ScrW() - 510,0 ) -- Position on the players screen
		RadioPanel:SetSize( 500, 300 ) -- Size of the frame
		RadioPanel:SetTitle("" ) -- Title of the frame
		RadioPanel:SetVisible( true )
		RadioPanel:SetDraggable( false ) -- Draggable by mouse?
		RadioPanel:ShowCloseButton( false ) -- Show the close button?
		function RadioPanel:Paint()
		end

		RadioList = vgui.Create( "DPanelList", RadioPanel )
		RadioList:SetPos( 0,25 )
		RadioList:SetSize( 500, 277 )
		RadioList:SetPadding( 0 ) -- Spacing between items
		RadioList:EnableHorizontal( false ) -- Only vertical items
		RadioList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
		function RadioList:Paint()
		end
	end
end

function CAKE.AddRadioLine( text )
	if RadioList then
		local label= vgui.Create("MarkupLabel" )
		label:SetText( text )
		label:SetMaxWidth( 500 )
		RadioList:AddItem( label )
		timer.Simple( 10, function()
			label:Remove()
			label = nil
		end)
	end
end

datastream.Hook( "TiramisuAddToRadio", function( handler, id, encoded, decoded )
	CAKE.CreateRadioMenu()
	CAKE.Chatbox:AddLine( "<font=BudgetLabel>" .. decoded.text .. "</font>", "Radio" )
	CAKE.AddRadioLine( "<font=BudgetLabel>" .. decoded.text .. "</font>" )
end)

function CLPLUGIN.Init()

end
