TIRA.Containers = {}

hook.Add("Tiramisu.CreateSQLTables", "Tiramisu.CreateContainerTable", function()
	if TIRA.ConVars["SQLEngine"] == "sqlite" then
		if !sql.TableExists("tiramisu_containers") then
			TIRA.Query("CREATE TABLE tiramisu_containers ( id int NOT NULL PRIMARY KEY, udata text )")
		end
	else
		TIRA.Query("CREATE TABLE IF NOT EXISTS tiramisu_containers ( id int NOT NULL PRIMARY KEY, udata text )")
	end
end)

function TIRA.ContainerExists(uid)
	if !uid then return false end
	local query = TIRA.Query("SELECT udata FROM tiramisu_containers WHERE id = '"..uid .. "'" )
	if query and query[1]["udata"] then
		return true
	end
		
	return false
end

function TIRA.CreateContainerID()
	return TIRA.GetTableNextID("tiramisu_containers") or 1
end

function TIRA.CreateContainerObject( uid )
	local container = FindMetaTable("Container"):New()

	if uid and TIRA.ContainerExists(uid) then
		local query = TIRA.Query("SELECT udata FROM tiramisu_containers WHERE id = '".. uid .. "'" )
		local tbl = von.deserialize( query[1]["udata"] )
		container.UniqueID = uid
		container:SetSize(tbl.Width, tbl.Height)
		container.Items = tbl.Items or {}
		container:Save()
	else
		container.UniqueID = TIRA.CreateContainerID()
		MsgN("Creating container " .. container.UniqueID .. "...\n" )
		TIRA.Query("INSERT INTO tiramisu_containers (id,udata) VALUES ('" .. container.UniqueID .. "','" .. von.serialize(container) .. "')" )
		container:Save()
	end
	return container
end

function TIRA.CreateContainer()
	local container = TIRA.CreateContainerObject()
	TIRA.Containers[container.UniqueID] = container
	return container
end

--Fetches a container, if it exists.
function TIRA.GetContainer( uid )
	if TIRA.ContainerExists( uid ) then
		TIRA.LoadContainer( uid )
		return TIRA.Containers[uid]
	end
	return false
end

function TIRA.IsContainer( uid )
	return TIRA.ContainerExists( uid ) --Just an alias. 
end

--Loads a container from file.
function TIRA.LoadContainer( uid )
	local container = TIRA.CreateContainerObject( uid )
	TIRA.Containers[container.UniqueID] = container
end

--Makes a container accessible by a group only
function TIRA.SetGroup( uid, groupid )
	if TIRA.IsContainer(uid) then
		TIRA.GetContainer(uid).Group = groupid
	end
end

--Makes a container accessible by a player only
function TIRA.SetPlayer( uid, ply )
	if TIRA.IsContainer(uid) then
		TIRA.GetContainer(uid).Player = TIRA.FormatText( ply:SteamID() )
	end
end

--Makes a container accessible by a character only
function TIRA.SetCharacter( uid, ply )
	if TIRA.IsContainer(uid) then
		TIRA.GetContainer(uid).Char = TIRA.FormatText(ply:SteamID()) .. ";" .. ply:GetNWString( "uid" )
	end
end

function TIRA.GetPlyTrackingContainer( uid )
	local rf = RecipientFilter()
	for _, ply in pairs( player.GetAll() ) do
		if !ply.TrackingContainers then
			ply.TrackingContainers = {}
		end
		if table.HasValue(ply.TrackingContainers, uid) then
			rf:AddPlayer( ply )
		end
	end
	return rf
end

function TIRA.CanOpenContainer( ply, uid )
	if TIRA.IsContainer(uid) then
		local container = TIRA.GetContainer(uid)
		if container.Group then
			if table.HasValue(TIRA.GetCharField( ply, "groups"), container.Group) then
				return true
			else
				return false
			end
		elseif container.Player then
			if container.Player == TIRA.FormatText(ply:SteamID()) then
				return true
			else
				return false
			end
		elseif container.Char then
			if container.Char == TIRA.FormatText(ply:SteamID()) .. ";" .. ply:GetNWString( "uid" ) then
				return true
			else
				return false
			end
		else
			return true
		end
	end
	return false
end

function TIRA.OpenContainer( ply, uid )
	local containerexist, fileexist = TIRA.ContainerExists( uid )
	if !containerexist and fileexist then
		TIRA.LoadContainer( uid )
	end
	if TIRA.IsContainer(uid) then
		local container = TIRA.GetContainer(uid)
		local udata = {}
		for i=1, container.Height do
			for j=1, container.Width do
				if !container:IsSlotEmpty( j, i ) then
					if container.Items[i][j] and container.Items[i][j].itemid then
						local tbl = {}
						tbl.Name = TIRA.GetUData( container.Items[i][j].itemid, "name" )
						tbl.Model = TIRA.GetUData( container.Items[i][j].itemid, "model" )
						tbl.Wearable = TIRA.ItemData[ container.Items[i][j].class ].Wearable or TIRA.GetUData( container.Items[i][j].itemid, "wearable" )
						tbl.Container = TIRA.GetUData( container.Items[i][j].itemid, "container" )
						udata[container.Items[i][j].itemid] = tbl
					end 
				end
			end
		end

		if TIRA.CanOpenContainer( ply, uid ) then
			datastream.StreamToClients( ply, "Tiramisu.OpenContainer", {
				["items"] = container.Items,
				["uid"] = container.UniqueID,
				["width"] = container.Width,
				["height"] = container.Height,
				["udata"] = udata
			})
		end
		if !ply.TrackingContainers then
			ply.TrackingContainers = {}
		end
		if !table.HasValue(ply.TrackingContainers, uid) then
			table.insert(ply.TrackingContainers, uid)
		end
	end
end

function TIRA.CloseContainer( ply, uid )
	if TIRA.IsContainer(uid) then
		TIRA.GetContainer(uid):Save()
		if !ply.TrackingContainers then
			ply.TrackingContainers = {}
		end
		for k, v in pairs(ply.TrackingContainers) do
			if v == uid then
				table.remove(ply.TrackingContainers, k)
			end
		end
	end
end

concommand.Add( "rp_opencontainer", function(ply, cmd, args)
	local uid = args[1]
	if uid then
		TIRA.OpenContainer( ply, uid )
	end
end)

concommand.Add( "rp_closecontainer", function(ply, cmd, args)
	local uid = args[1]
	if uid then
		TIRA.CloseContainer( ply, uid )
	end
end)

concommand.Add( "rp_containerremove", function(ply, cmd, args)
	local uid = args[1]
	local itemid = args[2]
	if uid and itemid then
		local container = TIRA.GetContainer(uid)
		if TIRA.CanOpenContainer( ply, uid ) then
			if container.Group then
				local group = TIRA.GetGroup( container.Group )
				if group:CharInGroup( ply ) and !group:GetRankField(group:GetCharInfo( ply ).Rank, "cantakeinventory") then
					ply:SendError(ply, "You don't have permission to remove from this container!")
					return
				end
			end
			container:TakeItemID(itemid)
		end
		container:Save()
	end

end)

concommand.Add( "rp_containerswap", function(ply, cmd, args)
	local uid = args[1]
	local x1 = args[2]
	local y1 = args[3]
	local x2 = args[4]
	local y2 = args[5]
	if x1 and x2 and y1 and y2 and uid and TIRA.IsContainer(uid) then
		local container = TIRA.GetContainer(uid)
		x1 = tonumber(x1)
		y1 = tonumber(y1)
		x2 = tonumber(x2)
		y2 = tonumber(y2)
		if x1 > 0 and x1 <= container.Width and x2 > 0 and x2 <= container.Width then
			if y1 > 0 and y1 <= container.Height and y2 > 0 and y2 <= container.Height then
				container:SwapSlots( x1, y1, x2, y2 )
			end
		end
		container:Save()
	end

end)

concommand.Add( "rp_transfertocontainer", function(ply, cmd, args)
	local from = args[1]
	local to = args[2]
	local class = args[3]
	local itemid = args[4]
	local x = args[5]
	local y = args[6]
	if from and to and itemid and class and TIRA.IsContainer( from ) and TIRA.IsContainer( to ) and TIRA.CanOpenContainer( ply, from ) and TIRA.CanOpenContainer( ply, to ) then
		from = TIRA.GetContainer( from )
		to = TIRA.GetContainer( to )
		if to.Group then
			local group = TIRA.GetGroup( to.Group )
			if group:CharInGroup( ply ) and !group:GetRankField(group:GetCharInfo( ply ).Rank, "canplaceinventory") then
				ply:SendError(ply, "You don't have permission to take from this container!")
				return
			end
		end
		if from.Group then
			local group = TIRA.GetGroup( from.Group )
			if group:CharInGroup( ply ) and !group:GetRankField(group:GetCharInfo( ply ).Rank, "cantakeinventory") then
				ply:SendError(ply, "You don't have permission to place on this container!")
				return
			end
		end
		if from:HasItemID( itemid ) and !to:IsFull() then
			if x and y then
				x = math.abs(tonumber(x))
				y = math.abs(tonumber(y))
				if x > 0 and x <= to.Width and y > 0 and y <= to.Height then
					if to:IsSlotEmpty( x, y ) then
						to:FillSlot( x, y, class, itemid )
						from:TakeItemID( itemid )
						to:Save()
						from:Save()
					else
						to:AddItem( class, itemid )
						from:TakeItemID( itemid )
						to:Save()
						from:Save()
					end
				end
			else
				to:AddItem( class, itemid )
				from:TakeItemID( itemid )
				to:Save()
				from:Save()
			end
		end
	end
end)

local function Admin_MakeContainer( ply, cmd, args )
	if !(args[1] and args[2] and args[3]) then TIRA.SendChat(ply, "Invalid number of arguments! ( rp_admin makecontainer \"entity\" \"width\" \"height\" \"pickable\" )") return end
	local ent = ents.GetByIndex( tonumber( args[ 1 ] ))
	local width = tonumber(args[2])
	local height = tonumber(args[3])
	local pickable = util.tobool(args[4])
	local permanent = !pickable
	local container = TIRA.CreateContainerObject()
	container:SetSize(width, height)

	if pickable then
		local id = TIRA.CreateItemID()
		TIRA.SetUData(id, "container", container.UniqueID)
		TIRA.SetUData(id, "creator", ply:Nick() .. ":" .. ply:Name() .. " (" .. ply:SteamID() .. ")")
		TIRA.SetUData(id, "model", ent:GetModel())
		TIRA.CreateItem( "container_base", ent:GetPos(), ent:GetAngles(), id )
		ent:Remove()
	else
		ent:SetNWBool("permaprop", true)
		ent:SetNWString("container", container.UniqueID)
		ent:SetUnFreezable( false )
		ent:SetMoveType( MOVETYPE_NONE )
		TIRA.AddPermaProp( ent:GetModel(), ent:GetPos(), ent:GetAngles(), container.UniqueID )
	end
	container:Save()
end

function PLUGIN.Init()
	TIRA.AdminCommand( "makecontainer", Admin_MakeContainer, "Makes a container out of a prop", true, true, 4 )
end