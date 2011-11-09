CLPLUGIN.Name = "Arrest Utilities"
CLPLUGIN.Author = "FNox"

CAKE.ArrestMessage = false

local function ArrestMsg( um )
	local type = um:ReadShort()
	if type == 1 then
		CAKE.ArrestMessage = "You are being tied up."
	elseif type == 2 then
		CAKE.ArrestMessage = "Tying up your target."
	elseif type == 3 then
		CAKE.ArrestMessage = "You are being untied."
	elseif type == 4 then
		CAKE.ArrestMessage = "Untying your target."
	end
end
usermessage.Hook( "ArrestMsg", ArrestMsg )

local function ClearArrest( um )
	CAKE.ArrestMessage = false
end
usermessage.Hook( "ClearArrest", ClearArrest )

local function DrawArrestText()
	if CAKE.ArrestMessage then
		draw.DrawText( CAKE.ArrestMessage, "ChatFont", ScrW( ) / 2 - 50, ScrH() / 2 - 20, Color( 255,255,255,255 ), 0 );
	end
	if LocalPlayer():GetNWBool( "arrested", false ) then
		draw.DrawText( "Tied up.", "ChatFont", ScrW( ) / 2 - 20, ScrH() + 20, Color( 255,255,255,255 ), 0 );
	end
end
hook.Add("HUDPaint", "DrawArrestText", DrawArrestText);

function CLPLUGIN.Init()
end
