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
	if self[fieldname] == nil then
		local query = TIRA.Query("SELECT " .. fieldname .. " FROM tiramisu_groups WHERE id = ".. self.UniqueID.."")
		if query then
			if type(TIRA.GroupFields[fieldname]) == "table" then self[fieldname] = von.deserialize(query[1]) end
			if type(TIRA.GroupFields[fieldname]) == "string" then self[fieldname] = tostring(query[1]) end
			if type(TIRA.GroupFields[fieldname]) == "number" then self[fieldname] = tonumber(query[1]) end
			if type(TIRA.GroupFields[fieldname]) == "boolean" then self[fieldname] = util.tobool(query[1]) end
		end 
	end
	return self[fieldname] or TIRA.GroupFields[fieldname] or false
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
	--file.Write(TIRA.Name .. "/groups/" .. TIRA.ConVars[ "Schema" ] .. "/" .. self.UniqueID.. ".txt", von.serialize(self))
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
	return TIRA.RankFields[field]
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
		for field, value in pairs(TIRA.RankFields) do
			self:SetRankField( rankname, field, value, true )
		end
	end
	self:SetField( "ranks", ranks )
end

--Does this rank exist?
function meta:IsRank( rankname )
	local ranks = self:GetRanks()
	if ranks[rankname] then
		return true
	end
	return false
end

--Alias for self:GetField( "defaultrank" )
function meta:GetDefaultRank()
	return self:GetField( "defaultrank" )
end

function meta:Delete()
	for _, ply in pairs( self:GetOnlineCharacters() ) do
		TIRA.LeaveGroup( ply, self.UniqueID )
	end
	TIRA.Query( "DELETE FROM tiramisu_groups WHERE id=" .. self.UniqueID )
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
			roster[TIRA.FormatText(ply:SteamID()) .. ";" .. ply:GetNWString( "uid" )] = tbl
			self:SetField( "roster", roster )
		end
	end
end

--Removes an online player from the roster.
function meta:RemoveFromRoster( ply )
	if ValidEntity( ply ) and ply:IsTiraPlayer() and ply:IsCharLoaded() then
		if self:GetCharacterInfo( ply ) then
			local roster = self:GetRoster()
			roster[TIRA.FormatText(ply:SteamID()) .. ";" .. ply:GetNWString( "uid" )] = nil
			self:SetField( "roster", roster )
		end
	end
	if table.Count( self:GetRoster() ) < 1 and self:GetField( "type" ) != "faction" then
		self:Delete()
	end
end

TIRA.Groups = {}
TIRA.GroupFields = {}
TIRA.RankFields = {}

--Creates an unique ID for the currently active group.
function TIRA.CreateGroupID()
	return TIRA.GetTableNextID("tiramisu_groups") or 1
	/*
	local repnum = 0
	local uidfile = file.Exists( TIRA.Name .. "/groups/" .. TIRA.ConVars[ "Schema" ] .. "/" .. os.time() .. repnum .. ".txt" )
	while uidfile do
		repnum = repnum + 1
		uidfile = file.Exists( TIRA.Name .. "/groups/" .. TIRA.ConVars[ "Schema" ] .. "/" .. os.time() .. repnum .. ".txt" )
	end
	return os.time() .. repnum*/
end

--Loads a group from file.
function TIRA.LoadGroup( uid )
	local group = TIRA.CreateGroupObject(uid)
	TIRA.Groups[group.UniqueID] = group
end

--Creates a new group and adds it to the group list.
function TIRA.CreateGroup()
	local group = TIRA.CreateGroupObject()
	TIRA.Groups[group.UniqueID] = group
	return group
end

--Does this group currently exist in the group list? Second argument, does the file for this group exist?
function TIRA.GroupExists( uid )
	if !uid then return false end
	return TIRA.Groups[uid] or false, file.Exists(TIRA.Name .. "/groups/" .. TIRA.ConVars[ "Schema" ] .. "/" .. uid.. ".txt")
end

function TIRA.IsGroup( uid )
	return TIRA.GroupExists( uid ) --Just an alias. 
end

--Fetches a group, if it exists.
function TIRA.GetGroup( uid )
	if TIRA.GroupExists( uid ) then
		return TIRA.Groups[uid]
	end
	return false
end

--Returns true if the name introduced is currently assigned to a group
function TIRA.GroupNameExists( name )
	for id, group in pairs( TIRA.Groups ) do
		if group and group:Name() == name then
			return true
		end
	end
	return false
end

--Finds a group object based on a name
function TIRA.FindGroupByName( name )
	for id, group in pairs( TIRA.Groups ) do
		if group and group:Name() == name then
			return group
		end
	end	
	return false
end

function TIRA.CreateGroupInventory(uid)
	local container = TIRA.CreateContainerObject()
	container:SetSize(10,5)
	container.Group = uid
	container:Save()
	return container.UniqueID
end

function TIRA.CreateGroupObject( uid )
	local group = FindMetaTable("Group"):New()

	if uid then
		group.UniqueID = uid 
	else
	local id = TIRA.GetTableNextID( "tiramisu_groups" )
	local fieldstr = "id,"
	local defaultstr = id .. ","
			-- Let's get the default fields and add them to the table.
		for fieldname, default in pairs( TIRA.GroupFields ) do
			fieldstr = fieldstr .. fieldname .. ","
			if type(default) == "table" then data = "'" .. von.serialize(default) .. "'" end
			if type(default) == "string" then defaultstr = defaultstr .. default .. "," end
			if type(default) == "number" then defaultstr = defaultstr .. tostring(default) .. "," end
			if type(default) == "boolean" then if default then defaultstr = defaultstr .. "1," else defaultstr = defaultstr .. "0," end end
		end
		fieldstr = string.sub(fieldstr, 1, string.len(fieldstr) - 1 ) --Removing the last comma
		defaulstr = string.sub(defaulstr, 1, string.len(defaulstr) - 1 ) --Removing the last comma

		TIRA.Query("INSERT INTO tiramisu_groups (".. fieldstr .. ") VALUES (" .. defaultstr .. ")")
		group.UniqueID = TIRA.GetTableMaxID("tiramisu_groups")
	end
	return group
end

function TIRA.AddGroupField( fieldname, default )
	if !TIRA.GroupFields[fieldname] then
		TIRA.GroupFields[fieldname] = default
	end
end

function TIRA.AddRankField( fieldname, default )
	if !TIRA.RankFields[fieldname] then
		TIRA.RankFields[fieldname] = default
	end
end

--Makes a character promote another to a certain rank, if possible.
function TIRA.PromoteCharacter( group, promoter, ply, rank )
	if ValidEntity(promoter) and promoter:IsTiraPlayer() and ValidEntity(ply) and ply:IsTiraPlayer() and TIRA.GroupExists( group ) then
		group = TIRA.GetGroup( group )
		if !group:CharacterInGroup( ply ) then return end
		if !group:CharacterInGroup( promoter ) then return end
		if !group:IsRank( rank ) then return end
		local promoinfo = group:GetCharacterInfo( promoter )
		local plyinfo = group:GetCharacterInfo( ply )
		if !group:GetRankField(promoinfo.Rank, "canpromote") then return end
		if tonumber(group:GetRankField( rank, "level" )) > tonumber(group:GetRankField(promoinfo.Rank, "level")) then return end
		plyinfo.Rank = rank
		group:Save()
		TIRA.SendGroupToClient( ply )
	end
end

--Makes a player leave a group, given a group ID
function TIRA.LeaveGroup( ply, uid, reason )
	if TIRA.GroupExists( uid ) then
		group = TIRA.GetGroup( uid )
		group:RemoveFromRoster( ply )
		local plygroups = TIRA.GetCharField( ply, "groups")
		local activegroup = TIRA.GetCharField( ply, "activegroup")
		for k, v in pairs( plygroups ) do
			if v == uid then
				table.remove( plygroups, k )
			end
		end
		if activegroup == uid and table.Count(plygroups) > 1 then
			TIRA.SetCharField( ply, "activegroup", table.Random(plygroups))
		end
		TIRA.SetCharField( ply, "groups", table.Copy(plygroups) )
		group:Save()
		TIRA.SendGroupToClient( ply )
		TIRA.SendError( ply, reason or "You have left " .. group:GetField( "name" ))
	end
end

function TIRA.JoinGroup( ply, uid, referral )
	if ValidEntity( ply ) and ply:IsPlayer() and TIRA.GroupExists( uid ) and ply:IsCharLoaded() then
		local group = TIRA.GetGroup( uid )
		if group:GetField("type") == "public" or (ValidEntity( referral ) and referral:IsPlayer() and ply.AuthorizedToJoin == uid and group:GetCharacterInfo( referral ) and group:GetRankField(group:GetCharacterInfo( referral ).Rank, "caninvite")) then
			if !group:GetCharacterInfo( ply ) then
				local plygroups = TIRA.GetCharField( ply, "groups")
				if !table.HasValue( plygroups, uid ) then
					table.insert( plygroups, uid )
				end
				TIRA.SetCharField( ply, "groups", table.Copy(plygroups))
				TIRA.SetCharField( ply, "activegroup", uid)
				group:AddToRoster( ply )
				TIRA.SendError( ply, "You have joined " .. group:GetField( "name" ))
				if ValidEntity( referral ) and referral:IsPlayer() then
					TIRA.SendError( referral, ply:Nick() .. " has accepted your invitation to join " .. group:GetField( "name" ))
				end
				group:Save()
				TIRA.SendGroupToClient( ply )
			else
				TIRA.SendError( ply, "You are already a member of " .. group:GetField( "name" ))
			end
			ply.AuthorizedToJoin = false
		end
	end
end

function TIRA.SendGroupToClient( ply )
	local tbl = {}
	local groups = TIRA.GetCharField( ply, "groups" )
	local group
	local activegroup = TIRA.GetCharField( ply, "activegroup" )
	local rank
	tbl["groups"] = {}
	tbl["rankpermissions"] = {}
	for k, v in pairs(groups) do
		if TIRA.GroupExists( v ) then
			group = TIRA.GetGroup( v )
			tbl["groups"][group.UniqueID] = group:Name()
			tbl["rankpermissions"][group.UniqueID] = {}
			rank = group:GetCharacterInfo( ply ).Rank
			tbl["rankpermissions"][group.UniqueID]["canpromote"] = group:GetRankField( rank, "canpromote" )
			tbl["rankpermissions"][group.UniqueID]["cankick"] = group:GetRankField( rank, "cankick" )
			tbl["rankpermissions"][group.UniqueID]["caninvite"] = group:GetRankField( rank, "caninvite" )
			tbl["rankpermissions"][group.UniqueID]["canedit"] = group:GetRankField( rank, "canedit" )
			tbl["rankpermissions"][group.UniqueID]["cannotice"] = group:GetRankField( rank, "cannotice" )
			tbl["rankpermissions"][group.UniqueID]["cantakeinventory"] = group:GetRankField( rank, "cantakeinventory" )
			tbl["rankpermissions"][group.UniqueID]["canplaceinventory"] = group:GetRankField( rank, "canplaceinventory" )
		end
	end
	tbl["activegroup"] = activegroup

	tbl["factions"] = TIRA.Factions

	datastream.StreamToClients( ply, "Tiramisu.ReceiveGroups", tbl)
end

TIRA.AddGroupField( "roster", {} )
TIRA.AddGroupField( "ranks", {
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
TIRA.AddGroupField( "doorgroup", 0 )
TIRA.AddGroupField( "notices", {} )
TIRA.AddGroupField( "inventory", "none" )
TIRA.AddGroupField( "defaultrank", "none" )
TIRA.AddGroupField( "name", "New Group" )
TIRA.AddGroupField( "description", "None available." )
TIRA.AddGroupField( "founder", "none" )
TIRA.AddGroupField( "type", "public" )

--Rank Fields
TIRA.AddRankField( "canedit", false )
TIRA.AddRankField( "cankick", false )
TIRA.AddRankField( "caninvite", false )
TIRA.AddRankField( "canpromote", false )
TIRA.AddRankField( "cannotice", false )
TIRA.AddRankField( "cantakeinventory", false )
TIRA.AddRankField( "canplaceinventory", false )
TIRA.AddRankField( "level", 0 )
TIRA.AddRankField( "name", "none" )
TIRA.AddRankField( "handler", "none" )
TIRA.AddRankField( "description", "none" )
TIRA.AddRankField( "loadout", {} )
TIRA.AddRankField( "weapons", {} )

--Player Fields
TIRA.AddDataField( 2, "groups", {} )
TIRA.AddDataField( 2, "activegroup", "none" )
TIRA.AddDataField( 2, "lastonline", 0 )

hook.Add("Tiramisu.CreateSQLTables", "Tiramisu.CreateGroupTable", function()
	if TIRA.ConVars["SQLEngine"] == "sqlite" then
		if !sql.TableExists("tiramisu_groups") then
			local datastr = "id int NOT NULL PRIMARY KEY,"
			for k, v in pairs(TIRA.GroupFields) do
				datastr = datastr .. k .. " "
				if type(v) == "table" then
					datastr = datastr .. "text"
				elseif type(v) == "string" then
					datastr = datastr .. "text"
				elseif type(v) == "number" then
					datastr = datastr .. "float"
				else --default to bool
					datastr = datastr .. "bit"
				end
				datastr = datastr .. "," 
			end
			datastr = string.sub(datastr, 1, string.len(datastr) - 1 ) --Removing the last comma
			TIRA.Query("CREATE TABLE tiramisu_groups ( " .. datastr .. " )")
		end
	else
		local datastr = "id INT,"
		for k, v in pairs(TIRA.GroupFields) do
			datastr = datastr .. k .. " "
			if type(v) == "table" then
				datastr = datastr .. "MEDIUMTEXT"
			elseif type(v) == "string" then
				datastr = datastr .. "TEXT"
			elseif type(v) == "number" then
				datastr = datastr .. "FLOAT"
			else --default to bool
				datastr = datastr .. "TINYINT"
			end
			datastr = datastr .. "," 
		end
		datastr = datastr .. "PRIMARY KEY (`id`)"
		TIRA.Query("CREATE TABLE IF NOT EXISTS tiramisu_groups ( " .. datastr .. " )")
	end
end)