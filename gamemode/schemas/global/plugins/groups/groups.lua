-- lol
_R.Group = {}
local meta = FindMetaTable("Group")

function meta:New()
	local new = {}
	setmetatable( new, self )
	self.__index = self
	return new
end

--Fetches a field from the group object.
function meta:GetField( fieldname )
	return self[fieldname] or CAKE.GroupFields[fieldname] or false
end

--Sets a field on the group object.
function meta:SetField( fieldname, value, dontsave )
	if type( value ) == "table" then
		self[fieldname] = table.Copy( value )
	else
		self[fieldname] = value
	end
	if !dontsave then
		self:Save()
	end
end

--Saves all data to file.
function meta:Save()
	file.Write(CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/" .. self.UniqueID.. ".txt", glon.encode(self))
end

--Obtains the information of all the players in the group.
function meta:GetRoster()
	return self:GetField( "roster" )
end

--Obtains the group's name
function meta:Name()
	return self:GetField( "name" )
end

function meta:GetInventory()
	return self:GetField( "inventory" )
end

function meta:SetInventory( tbl )
	self:SetField( "inventory", tbl )
end

--Obtains all ranks from the group
function meta:GetRanks()
	return self:GetField( "ranks" )
end

function meta:GetRankField( rankname, field )
	local ranks = self:GetRanks()
	if ranks[rankname] then
		return ranks[rankname][field]
	end
	return CAKE.RankFields[field]
end

function meta:SetRankField( rankname, field, value, dontsave )
	local ranks = self:GetRanks()
	if ranks[rankname] then
		ranks[rankname][field] = value
	end
	self:SetField( "ranks", ranks, dontsave )
end

--Adds a new rank to the group.
function meta:AddRank( rankname )
	local ranks = self:GetRanks()
	if !ranks[rankname] then
		ranks[rankname] = {}
		for field, value in pairs(CAKE.RankFields) do
			self:SetRankField( rankname, field, value, true )
		end
	end
	self:SetField( "ranks", ranks )
end

--Does this rank exist?
function meta:IsRank( rankname )
	local ranks = self:GetRanks()
	return ranks[rankname] or false
end

--Alias for self:GetField( "defaultrank" )
function meta:GetDefaultRank()
	return self:GetField( "defaultrank" )
end

function meta:Delete()
	for _, ply in pairs( self:GetOnlineCharacters() ) do
		CAKE.LeaveGroup( ply, self.UniqueID )
	end
	file.Delete( CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/" .. self.UniqueID .. ".txt"  )
	self = nil
end

--Is the player in the group?
function meta:PlayerInGroup( ply )
	if ValidEntity( ply ) and ply:IsTiraPlayer() and ply:IsCharLoaded() then
		for _, v in pairs(self:GetRoster()) do
			if v and v.SteamID == ply:SteamID() then
				return true
			end
		end
	end
	return false
end

--Is the currently active character of this player in the group?
function meta:CharacterInGroup( ply )
	if ValidEntity( ply ) and ply:IsTiraPlayer() and ply:IsCharLoaded() then
		for _, v in pairs(self:GetRoster()) do
			if v and v.SteamID == ply:SteamID() and v.UID == ply:GetNWString( "uid" ) then
				return true
			end
		end
	end
	return false
end

function meta:CharInGroup( ply )
	return self:CharacterInGroup( ply )
end

function meta:CharIsMember( ply )
	return self:CharacterInGroup( ply )
end

--Fetches the information of a character, given a player.
function meta:GetCharacterInfo( ply )
	if ValidEntity( ply ) and ply:IsTiraPlayer() and ply:IsCharLoaded() then
		for plyid, v in pairs(self:GetRoster()) do
			if v and v.SteamID == ply:SteamID() and v.UID == ply:GetNWString( "uid" ) then
				return v
			end
		end
	end
	return false
end

function meta:GetCharInfo( ply )
	return self:GetCharacterInfo( ply )
end

function meta:CharInfo( ply )
	return self:GetCharacterInfo( ply )
end


--Fetches the information of a member, given an id.
function meta:GetMemberInfo( text )
	for ply, v in pairs(self:GetRoster()) do
		if ply:match( text ) then
			return v
		end
	end
	return false
end

--Fetches the list of currently online players (regardless of if they're in the character that belongs to the group) that are in the group.
function meta:GetOnlinePlayers()
	local tbl = {}
	for _, ply in pairs(player.GetHumans()) do
		if self:PlayerInGroup( ply ) then
			table.insert( tbl, ply )
		end
	end
	return tbl
end

--Fetches the list of currently online characters belonging to the group.
function meta:GetOnlineCharacters()
	local tbl = {}
	for _, ply in pairs(player.GetHumans()) do
		if self:CharacterInGroup( ply ) then
			table.insert( tbl, ply )
		end
	end
	return tbl
end

function meta:GetOnlineChars()
	return self:GetOnlineCharacters()
end

--Adds an online player to the roster.
function meta:AddToRoster( ply, rank )
	if ValidEntity( ply ) and ply:IsTiraPlayer() and ply:IsCharLoaded() then
		if !self:GetCharacterInfo( ply ) then
			local tbl = {}
			tbl.Name = ply:Nick()
			tbl.SteamID = ply:SteamID()
			tbl.UID = ply:GetNWString( "uid" )
			tbl.Rank = rank or self:GetDefaultRank()
			local roster = self:GetRoster()
			roster[CAKE.FormatText(ply:SteamID()) .. ";" .. ply:GetNWString( "uid" )] = tbl
			self:SetField( "roster", roster )
		end
	end
end

--Removes an online player from the roster.
function meta:RemoveFromRoster( ply )
	if ValidEntity( ply ) and ply:IsTiraPlayer() and ply:IsCharLoaded() then
		if self:GetCharacterInfo( ply ) then
			local roster = self:GetRoster()
			roster[CAKE.FormatText(ply:SteamID()) .. ";" .. ply:GetNWString( "uid" )] = nil
			self:SetField( "roster", roster )
		end
	end
	if table.Count( self:GetRoster() ) < 1 then
		self:Delete()
	end
end

CAKE.Groups = {}
CAKE.GroupFields = {}
CAKE.RankFields = {}

--Creates an unique ID for the currently active group.
function CAKE.CreateGroupID()
	local repnum = 0
	local uidfile = file.Read( CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/" .. os.time() .. repnum .. ".txt" )
	while uidfile do
		repnum = repnum + 1
		uidfile = file.Read( CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/" .. os.time() .. repnum .. ".txt" )
	end
	return os.time() .. repnum
end

--Loads a group from file.
function CAKE.LoadGroup( uid )
	local group = CAKE.CreateGroupObject( CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/" .. uid.. ".txt" )
	CAKE.Groups[group.UniqueID] = group
end

--Creates a new group and adds it to the group list.
function CAKE.CreateGroup()
	local group = CAKE.CreateGroupObject()
	CAKE.Groups[group.UniqueID] = group
	return group
end

--Does this group currently exist in the group list? Second argument, does the file for this group exist?
function CAKE.GroupExists( uid )
	if !uid then return false end
	return CAKE.Groups[uid] or false, file.Exists(CAKE.Name .. "/groups/" .. CAKE.ConVars[ "Schema" ] .. "/" .. uid.. ".txt")
end

function CAKE.IsGroup( uid )
	return CAKE.GroupExists( uid ) --Just an alias. 
end

--Fetches a group, if it exists.
function CAKE.GetGroup( uid )
	if CAKE.GroupExists( uid ) then
		return CAKE.Groups[uid]
	end
	return false
end

--Returns true if the name introduced is currently assigned to a group
function CAKE.GroupNameExists( name )
	for id, group in pairs( CAKE.Groups ) do
		if group and group:Name() == name then
			return true
		end
	end
	return false
end

function CAKE.CreateGroupObject( filename )
	local group = FindMetaTable("Group"):New()

	if filename and file.Exists( filename ) then
		local tbl = glon.decode( file.Read(filename) )
		for k, v in pairs(tbl) do
			group:SetField( k, v, true )
		end
		group.UniqueID = tbl.UniqueID
		group:Save()
	else
		group.UniqueID = CAKE.CreateGroupID()
		for k, v in pairs(CAKE.GroupFields) do
			group:SetField( k, v, true )
		end
		group:Save()
	end
	return group
end

function CAKE.AddGroupField( fieldname, default )
	if !CAKE.GroupFields[fieldname] then
		CAKE.GroupFields[fieldname] = default
	end
end

function CAKE.AddRankField( fieldname, default )
	if !CAKE.RankFields[fieldname] then
		CAKE.RankFields[fieldname] = default
	end
end

--Makes a character promote another to a certain rank, if possible.
function CAKE.PromoteCharacter( group, promoter, ply, rank )
	if ValidEntity(promoter) and promoter:IsTiraPlayer() and ValidEntity(ply) and ply:IsTiraPlayer() and CAKE.GroupExists( group ) then
		group = CAKE.GetGroup( group )
		if !group:CharacterInGroup( ply ) then return end
		if !group:CharacterInGroup( promoter ) then return end
		if !group:IsRank( rank ) then return end
		local promoinfo = group:GetCharacterInfo( promoter )
		local plyinfo = group:GetCharacterInfo( ply )
		if !group:GetRankField(promoinfo.Rank, "canpromote") then return end
		if tonumber(group:GetRankField( rank, "level" )) > tonumber(group:GetRankField(promoinfo.Rank, "level")) then return end
		plyinfo.Rank = rank
		group:Save()
		CAKE.SendGroupToClient( ply )
	end
end

--Makes a player leave a group, given a group ID
function CAKE.LeaveGroup( ply, uid, reason )
	if CAKE.GroupExists( uid ) then
		group = CAKE.GetGroup( uid )
		group:RemoveFromRoster( ply )
		local plygroups = CAKE.GetCharField( ply, "groups")
		local activegroup = CAKE.GetCharField( ply, "activegroup")
		for k, v in pairs( plygroups ) do
			if v == uid then
				table.remove( plygroups, k )
			end
		end
		if activegroup == uid and table.Count(plygroups) > 1 then
			CAKE.SetCharField( ply, "activegroup", table.Random(plygroups))
		end
		CAKE.SetCharField( ply, "groups", table.Copy(plygroups) )
		group:Save()
		CAKE.SendGroupToClient( ply )
		CAKE.SendError( ply, reason or "You have left " .. group:GetField( "name" ))
	end
end

function CAKE.JoinGroup( ply, uid, referral )
	if ValidEntity( ply ) and ply:IsPlayer() and CAKE.GroupExists( uid ) and ply:IsCharLoaded() then
		local group = CAKE.GetGroup( uid )
		if group:GetField("type") == "public" or (ValidEntity( referral ) and referral:IsPlayer() and ply.AuthorizedToJoin == uid and group:GetCharacterInfo( referral ) and group:GetRankField(group:GetCharacterInfo( referral ).Rank, "caninvite")) then
			if !group:GetCharacterInfo( ply ) then
				local plygroups = CAKE.GetCharField( ply, "groups")
				if !table.HasValue( plygroups, uid ) then
					table.insert( plygroups, uid )
				end
				CAKE.SetCharField( ply, "groups", table.Copy(plygroups))
				CAKE.SetCharField( ply, "activegroup", uid)
				group:AddToRoster( ply )
				CAKE.SendError( ply, "You have joined " .. group:GetField( "name" ))
				if ValidEntity( referral ) and referral:IsPlayer() then
					CAKE.SendError( referral, ply:Nick() .. " has accepted your invitation to join " .. group:GetField( "name" ))
				end
				group:Save()
				CAKE.SendGroupToClient( ply )
			else
				CAKE.SendError( ply, "You are already a member of " .. group:GetField( "name" ))
			end
			ply.AuthorizedToJoin = false
		end
	end
end

function CAKE.SendGroupToClient( ply )
	local tbl = {}
	local groups = CAKE.GetCharField( ply, "groups" )
	local group
	local activegroup = CAKE.GetCharField( ply, "activegroup" )
	tbl["groups"] = {}
	for k, v in pairs(groups) do
		if CAKE.GroupExists( v ) then
			group = CAKE.GetGroup( v )
			tbl["groups"][group.UniqueID] = group:Name()
		end
	end
	tbl["activegroup"] = activegroup
	group = CAKE.GetGroup( activegroup )
	tbl["rankpermissions"] = {}

	if activegroup == "none" or !group or !group:GetCharacterInfo( ply ) then
		tbl["rankpermissions"]["canpromote"] = false
		tbl["rankpermissions"]["cankick"] = false
		tbl["rankpermissions"]["caninvite"] = false
		tbl["rankpermissions"]["canedit"] = false
		tbl["rankpermissions"]["cannotice"] = false
		tbl["rankpermissions"]["cantakeinventory"] = false
		tbl["rankpermissions"]["canplaceinventory"] = false
	else
		local rank = group:GetCharacterInfo( ply ).Rank
		tbl["rankpermissions"]["canpromote"] = group:GetRankField( rank, "canpromote" )
		tbl["rankpermissions"]["cankick"] = group:GetRankField( rank, "cankick" )
		tbl["rankpermissions"]["caninvite"] = group:GetRankField( rank, "caninvite" )
		tbl["rankpermissions"]["canedit"] = group:GetRankField( rank, "canedit" )
		tbl["rankpermissions"]["cannotice"] = group:GetRankField( rank, "cannotice" )
		tbl["rankpermissions"]["cantakeinventory"] = group:GetRankField( rank, "cantakeinventory" )
		tbl["rankpermissions"]["canplaceinventory"] = group:GetRankField( rank, "canplaceinventory" )
	end

	datastream.StreamToClients( ply, "Tiramisu.ReceiveGroups", tbl)
end

function PLUGIN.Init()
	CAKE.AddGroupField( "roster", {} )
	CAKE.AddGroupField( "ranks", {
		["founder"] = {
			["canedit"] = true,
			["cankick"] = true,
			["caninvite"] = true,
			["canpromote"] = true,
			["cannotice"] = true,
			["cantakeinventory"] = true,
			["canplaceinventory"] = true,
			["level"] = 100,
			["name"] = "Group Founder",
			["handler"] = "founder",
			["description"] = "The one who founded the group"
		}
	} )
	CAKE.AddGroupField( "doorgroup", 0 )
	CAKE.AddGroupField( "notices", {} )
	CAKE.AddGroupField( "inventory", {} )
	CAKE.AddGroupField( "defaultrank", "none" )
	CAKE.AddGroupField( "name", "New Group" )
	CAKE.AddGroupField( "description", "None available." )
	CAKE.AddGroupField( "founder", "none" )
	CAKE.AddGroupField( "type", "public" )

	--Rank Fields
	CAKE.AddRankField( "canedit", false )
	CAKE.AddRankField( "cankick", false )
	CAKE.AddRankField( "caninvite", false )
	CAKE.AddRankField( "canpromote", false )
	CAKE.AddRankField( "cannotice", false )
	CAKE.AddRankField( "cantakeinventory", false )
	CAKE.AddRankField( "canplaceinventory", false )
	CAKE.AddRankField( "level", 0 )
	CAKE.AddRankField( "name", "none" )
	CAKE.AddRankField( "handler", "none" )
	CAKE.AddRankField( "description", "none" )
	CAKE.AddRankField( "loadout", {} )
	CAKE.AddRankField( "weapons", {} )

	--Player Fields
	CAKE.AddDataField( 2, "groups", {} )
	CAKE.AddDataField( 2, "activegroup", "none" )
	CAKE.AddDataField( 2, "lastonline", 0 )

end
