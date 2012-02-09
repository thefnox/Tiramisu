CLPLUGIN.Name = "Clientside Group Utilities"
CLPLUGIN.Author = "FNox"

CAKE.Groups = {}
CAKE.ActiveGroup = "none"
CAKE.RankPermissions = {}

datastream.Hook( "TiramisuAddToGroupChat", function( handler, id, encoded, decoded )
	
	local color = decoded.color
	local playername = decoded.name
	local text = decoded.text
	local channel = decoded.channel
	local handler = decoded.handler

	text = text:gsub("<%s*%w*%s*=%s*%w*%s*>", "")
	text = text:gsub("</font>", "")
	text = text:gsub("<%s*%w*%s*=%s*%w*%s*,%s*%w*%s*,%s*%w*%s*,%s*%w*%s*>", "")
	text = text:gsub("</color>", "")
	CAKE.Chatbox:AddLine(  "<font=TiramisuOOCFont><color=" .. tostring( color.r ) .. "," .. tostring( color.g ) .. "," .. tostring( color.b ) .. ">".. playername .. "</color><color=white>:" .. text .. "</color></font>", "OOC", channel, handler or "/g " )

	text = "[" .. channel .. "]" .. playername .. ": " .. text

	for i = 0, text:len() / 255 do
		MsgN(string.sub( text, i * 255 + 1, i * 255 + 255 ) )
	end
end)

datastream.Hook( "ReceiveGroups", function( handler, id, encoded, decoded )

	CAKE.Groups = decoded["groups"]
	CAKE.ActiveGroup = decoded["activegroup"]
	CAKE.RankPermissions = decoded["rankpermissions"]

end )

usermessage.Hook( "Tiramisu.GetInvite", function( um )
	local ply = um:ReadEntity()
	local uid = um:ReadString()
	local name = um:ReadString()

	CAKE.Query( "You have been invited to join group: " .. name .. ", accept?", "Group Invite",
		"Accept", function() RunConsoleCommand( "rp_joingroup", uid, CAKE.FormatText(ply:SteamID()))end, 
		"Deny",	function() end)
end)

usermessage.Hook( "Tiramisu.GroupCreateQuery", function( um )
	BeginGroupCreation( um:ReadString() )
end)

function CAKE.GetRankPermission( name )
	if CAKE.Groups and CAKE.ActiveGroup != "none" and CAKE.RankPermissions then
		return CAKE.RankPermissions[name]
	end
	return false
end

local function OpenGroups()

	if table.Count(CAKE.Groups) < 1 then
		CAKE.Query( "You do not currently belong to any groups, would you like to create one?", "Groups",
		"Yes", function() BeginGroupCreation() end, 
		"No",	function() end)
	else

	end

end

function BeginGroupCreation( title )
	CAKE.StringRequest( "Group Creation", "Please enter the name of the group you want to create", title or "New Group",
	function( entry )
		RunConsoleCommand( "rp_creategroup", entry )
	end,
	function() end, "Create Group", "Cancel" )
end

local function CloseGroups()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
function CLPLUGIN.Init()
	--CAKE.RegisterMenuTab( "Groups", OpenGroups, CloseGroups )
end
