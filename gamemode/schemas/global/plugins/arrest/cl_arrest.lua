CLPLUGIN.Name = "Arrest Utilities"
CLPLUGIN.Author = "FNox"

TIRA.ArrestMessage = false

local function ArrestMsg( um )
	local type = um:ReadShort()
	if type == 1 then
		TIRA.ArrestMessage = "You are being tied up."
	elseif type == 2 then
		TIRA.ArrestMessage = "Tying up your target."
	elseif type == 3 then
		TIRA.ArrestMessage = "You are being untied."
	elseif type == 4 then
		TIRA.ArrestMessage = "Untying your target."
	end
end
usermessage.Hook( "ArrestMsg", ArrestMsg )

local function ClearArrest( um )
	TIRA.ArrestMessage = false
end
usermessage.Hook( "ClearArrest", ClearArrest )

local function DrawArrestText()
	if TIRA.ArrestMessage then
		draw.DrawText( TIRA.ArrestMessage, "ChatFont", ScrW( ) / 2 - 50, ScrH() / 2 - 20, Color( 255,255,255,255 ), 0 )
	end
	if LocalPlayer():GetNWBool( "arrested", false ) then
		draw.DrawText( "Tied up.", "ChatFont", ScrW( ) / 2 - 20, ScrH() + 20, Color( 255,255,255,255 ), 0 )
	end
end
hook.Add("HUDPaint", "DrawArrestText", DrawArrestText)

function CLPLUGIN.Init()
end
