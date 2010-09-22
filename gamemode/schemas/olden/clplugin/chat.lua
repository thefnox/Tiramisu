CLPLUGIN.Name = "Chat Utilities"
CLPLUGIN.Author = "FNox"
	
function AddOOCLine( handler, id, encoded, decoded )

	local text = decoded.text
	local playername = decoded.playername
	local color = decoded.color
	local line = "<font=defaultbold><color=255,255,255,255>[OOC]</color><color=" .. tostring( color.r ) .. "," .. tostring( color.g ) .. "," .. tostring( color.b ) .. "," .. tostring( color.a ) .. ">" .. playername .. "</color> :<color=255,255,255,255>" .. text .."</color></font>"
	--chat.AddText( line )
	aChat.AddChatLine(line)
 
end
datastream.Hook( "AddOOCLine", AddOOCLine );

function CLPLUGIN.Init()

end
