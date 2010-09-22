CLPLUGIN.Name = "Overlays"
CLPLUGIN.Author = "FNox"

CAKE.Overlay = nil

local pingrandom = {
	"Transmitting coordinates...",
	"Regulating craneal temperature...",
	"Modulating brain waves...",
	"Hash checking unit serials...",
	"Updating control settings...",
	"Amplifying vocal distortion...",
	"Downloading recent dictionaries...",
	"Establishing new connection...",
	"Synchronizing patrol data...",
	"Recalculating glial cell count ...",
	"Translating auxiliary data...",
	"Flushing network stack...",
	"Scanning for hostiles...",
	"Adquiring new memory bank...",
	"Waiting for orders..."
};


function CAKE.CreatePingPanel()
	if !PingPanel then
		PingPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
		PingPanel:SetPos( 10,0 ) -- Position on the players screen
		PingPanel:SetSize( 500, 300 ) -- Size of the frame
		PingPanel:SetTitle("" ) -- Title of the frame
		PingPanel:SetVisible( true )
		PingPanel:SetDraggable( false ) -- Draggable by mouse?
		PingPanel:ShowCloseButton( false ) -- Show the close button?
		function PingPanel:Paint()
		end

		PingList = vgui.Create( "DPanelList", PingPanel )
		PingList:SetPos( 0,25 )
		PingList:SetSize( 500, 277 )
		PingList:SetSpacing( 1 ) -- Spacing between items
		PingList:SetPadding( 0 ) -- Spacing between items
		PingList:EnableHorizontal( false ) -- Only vertical items
		PingList:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
		function PingList:Paint()
		end
		
		timer.Create( "randompingmessages", 4, 0, function()
			if PingPanel then
				CAKE.AddPingLine( table.Random( pingrandom ), Color( 255, 255, 255 ) )
			else
				timer.Destroy( "randompingmessages" )
			end
		end)
	end
end

function CAKE.AddPingLine( text, color )
	if PingPanel then
		local label= vgui.Create("DLabel" )
		label:SetText( "<::" .. text .. "::>" )
		label:SetWrap(true)
		label:SetFont( "BudgetLabel" )
		label:SetTextColor( color )
		local count = string.len( text )
		if count > 50 then
			label:SetSize( 500, 13 * math.ceil( ( count / 50 ) ) )
		else
			label:SetSize( 500, 13 )
		end
		PingList:AddItem( label )
		timer.Simple( 10, function()
			label:Remove()
			label = nil
		end)
	end
end

local function AddPingMsg( um )
	local text = um:ReadString()
	local color = Color( um:ReadShort(), um:ReadShort(), um:ReadShort() )
	CAKE.AddPingLine( text, color )
end
usermessage.Hook( "AddPingLine", AddPingMsg )

local function CreatePing()
	CAKE.CreatePingPanel()
end
usermessage.Hook( "CreatePing", CreatePing )

local function RemovePing()
	if PingPanel then
		PingPanel:Remove()
		PingPanel = nil
	end
end
usermessage.Hook( "RemovePing", RemovePing )

local function AddOverlay( um )
	local type = um:ReadShort() or 1
	CAKE.Overlay = type
end
usermessage.Hook( "addtiramisuoverlay", AddOverlay )

local function RemoveOverlay( um )
	CAKE.Overlay = nil
end
usermessage.Hook( "removetiramisuoverlay", RemoveOverlay )

local function DrawOverlay()
	if CAKE.Overlay and !CAKE.MenuOpen then
		if CAKE.Overlay == 1 then
			if PingPanel then
				PingPanel:SetVisible( true )
			end
			DrawMaterialOverlay( "effects/combine_binocoverlay.vmt", 0.1 )
		end
	else
		if PingPanel then
			PingPanel:SetVisible( false )
		end
	end
end
hook.Add( "RenderScreenspaceEffects", "TiramisuOverlay", DrawOverlay )

function CLPLUGIN.Init()

end
