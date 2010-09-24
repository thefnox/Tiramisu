CLPLUGIN.Name = "Chat Utilities"
CLPLUGIN.Author = "FNox"
	
function AddOOCLine( handler, id, encoded, decoded )

	local text = decoded.text
	local playername = decoded.playername
	local color = decoded.color
	chat.AddText( Color(255,255,255,255), "[OOC]", color, playername, Color(255,255,255,255), " :", Color(255,255,255,255), text )
 
end
datastream.Hook( "AddOOCLine", AddOOCLine );

function CLPLUGIN.Init()

end
