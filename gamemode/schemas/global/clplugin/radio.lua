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
		RadioList:SetSpacing( 1 ) -- Spacing between items
		RadioList:SetPadding( 0 ) -- Spacing between items
		RadioList:EnableHorizontal( false ) -- Only vertical items
		RadioList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
		function RadioList:Paint()
		end
	end
end

function CAKE.AddRadioLine( text, color )
	if RadioList then
		local label= vgui.Create("DLabel" )
		label:SetText( text )
		label:SetWrap(true)
		label:SetFont( "BudgetLabel" )
		label:SetTextColor( color )
		local count = string.len( text )
		if count > 50 then
			label:SetSize( 500, 13 * math.ceil( ( count / 50 ) ) )
		else
			label:SetSize( 500, 13 )
		end
		RadioList:AddItem( label )
		timer.Simple( 10, function()
			label:Remove()
			label = nil
		end)
	end
end

local function AddRadioMsg( um )
	local text = um:ReadString()
	local color = Color( um:ReadShort(), um:ReadShort(), um:ReadShort() )
	CAKE.AddRadioLine( text, color )
end
usermessage.Hook( "AddRadioLine", AddRadioMsg )

local function CreateRadio()
	CAKE.CreateRadioMenu()
end
usermessage.Hook( "CreateRadio", CreateRadio )

function CLPLUGIN.Init()

end
