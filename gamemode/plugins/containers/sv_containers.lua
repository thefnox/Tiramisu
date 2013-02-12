CAKE.Containers = {}

function CAKE.CreateContainerID()
	local repnum = 0
	local uidfile = file.Exists( CAKE.Name .. "/containers/" .. CAKE.ConVars[ "Schema" ] .. "/" .. os.time() .. repnum .. ".txt", "DATA" )
	while uidfile do
		repnum = repnum + 1
		uidfile = file.Exists( CAKE.Name .. "/containers/" .. CAKE.ConVars[ "Schema" ] .. "/" .. os.time() .. repnum .. ".txt", "DATA" )
	end
	return os.time() .. repnum
end

function CAKE.CreateContainerObject( filename )
	local container = FindMetaTable("Container"):New()

	if filename and file.Exists( filename, "DATA" ) then
		-- local tbl = glon.decode( file.Read(filename) )
		local tbl = CAKE.DeserializeFile(filename)
		container.UniqueID = tbl.UniqueID
		container:SetSize(tbl.Width, tbl.Height)
		container.Items = tbl.Items
		container:Save()
	else
		container.UniqueID = CAKE.CreateContainerID()
		container:Save()
	end
	return container
end

function CAKE.CreateContainer()
	local container = CAKE.CreateContainerObject()
	CAKE.Containers[container.UniqueID] = container
	return container
end

--Fetches a container, if it exists.
function CAKE.GetContainer( uid )
	local containerexist, fileexist = CAKE.ContainerExists( uid )
	if !containerexist and fileexist then
		CAKE.LoadContainer( uid )
	end
	if CAKE.ContainerExists( uid ) then
		return CAKE.Containers[uid]
	end
	return false
end

--Does this container currently exist in the container list? Second argument, does the file for this container exist?
function CAKE.ContainerExists( uid )
	if !uid then return false end
	return CAKE.Containers[uid] or false, file.Exists(CAKE.Name .. "/containers/" .. CAKE.ConVars[ "Schema" ] .. "/" .. uid.. ".txt", "DATA")
end

function CAKE.IsContainer( uid )
	return CAKE.ContainerExists( uid ) --Just an alias. 
end

--Loads a container from file.
function CAKE.LoadContainer( uid )
	local container = CAKE.CreateContainerObject( CAKE.Name .. "/containers/" .. CAKE.ConVars[ "Schema" ] .. "/" .. uid.. ".txt" )
	CAKE.Containers[container.UniqueID] = container
end

--Makes a container accessible by a group only
function CAKE.SetGroup( uid, groupid )
	if CAKE.IsContainer(uid) then
		CAKE.GetContainer(uid).Group = groupid
	end
end

--Makes a container accessible by a player only
function CAKE.SetPlayer( uid, ply )
	if CAKE.IsContainer(uid) then
		CAKE.GetContainer(uid).Player = CAKE.FormatText( ply:SteamID() )
	end
end

--Makes a container accessible by a character only
function CAKE.SetCharacter( uid, ply )
	if CAKE.IsContainer(uid) then
		CAKE.GetContainer(uid).Char = CAKE.FormatText(ply:SteamID()) .. ";" .. ply:GetNWString( "uid" )
	end
end

function CAKE.GetPlyTrackingContainer( uid )
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

function CAKE.CanOpenContainer( ply, uid )
	if CAKE.IsContainer(uid) then
		local container = CAKE.GetContainer(uid)
		if container.Group then
			if table.HasValue(CAKE.GetCharField( ply, "groups"), container.Group) then
				return true
			else
				return false
			end
		elseif container.Player then
			if container.Player == CAKE.FormatText(ply:SteamID()) then
				return true
			else
				return false
			end
		elseif container.Char then
			if container.Char == CAKE.FormatText(ply:SteamID()) .. ";" .. ply:GetNWString( "uid" ) then
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

function CAKE.OpenContainer( ply, uid )
	local containerexist, fileexist = CAKE.ContainerExists( uid )
	if !containerexist and fileexist then
		CAKE.LoadContainer( uid )
	end
	if CAKE.IsContainer(uid) then
		local container = CAKE.GetContainer(uid)
		local udata = {}
		for i=1, container.Height do
			for j=1, container.Width do
				if !container:IsSlotEmpty( j, i ) then
					if container.Items[i][j] and container.Items[i][j].itemid then
						local tbl = {}
						tbl.Name = CAKE.GetUData( container.Items[i][j].itemid, "name" )
						tbl.Model = CAKE.GetUData( container.Items[i][j].itemid, "model" )
						tbl.Wearable = CAKE.ItemData[ container.Items[i][j].class ].Wearable or CAKE.GetUData( container.Items[i][j].itemid, "wearable" )
						tbl.Container = CAKE.GetUData( container.Items[i][j].itemid, "container" )
						udata[container.Items[i][j].itemid] = tbl
					end 
				end
			end
		end

		if CAKE.CanOpenContainer( ply, uid ) then
			--[[datastream.StreamToClients( ply, "Tiramisu.OpenContainer", {
				["items"] = container.Items,
				["uid"] = container.UniqueID,
				["width"] = container.Width,
				["height"] = container.Height,
				["udata"] = udata
			})]]--
			net.Start("Tiramisu.OpenContainer")
				net.WriteTable({
					["items"] = container.Items,
					["uid"] = container.UniqueID,
					["width"] = container.Width,
					["height"] = container.Height,
					["udata"] = udata
				})
			net.Send(ply)
		end
		if !ply.TrackingContainers then
			ply.TrackingContainers = {}
		end
		if !table.HasValue(ply.TrackingContainers, uid) then
			table.insert(ply.TrackingContainers, uid)
		end
	end
end

function CAKE.CloseContainer( ply, uid )
	if CAKE.IsContainer(uid) then
		CAKE.GetContainer(uid):Save()
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
		CAKE.OpenContainer( ply, uid )
	end
end)

concommand.Add( "rp_closecontainer", function(ply, cmd, args)
	local uid = args[1]
	if uid then
		CAKE.CloseContainer( ply, uid )
	end
end)

concommand.Add( "rp_containerremove", function(ply, cmd, args)
	local uid = args[1]
	local itemid = args[2]
	if uid and itemid then
		local container = CAKE.GetContainer(uid)
		if CAKE.CanOpenContainer( ply, uid ) then
			if container.Group then
				local group = CAKE.GetGroup( container.Group )
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
	if x1 and x2 and y1 and y2 and uid and CAKE.IsContainer(uid) then
		local container = CAKE.GetContainer(uid)
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
	if from and to and itemid and class and CAKE.IsContainer( from ) and CAKE.IsContainer( to ) and CAKE.CanOpenContainer( ply, from ) and CAKE.CanOpenContainer( ply, to ) then
		from = CAKE.GetContainer( from )
		to = CAKE.GetContainer( to )
		if to.Group then
			local group = CAKE.GetGroup( to.Group )
			if group:CharInGroup( ply ) and !group:GetRankField(group:GetCharInfo( ply ).Rank, "canplaceinventory") then
				ply:SendError(ply, "You don't have permission to take from this container!")
				return
			end
		end
		if from.Group then
			local group = CAKE.GetGroup( from.Group )
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
	if !(args[1] and args[2] and args[3]) then CAKE.SendChat(ply, "Invalid number of arguments! ( rp_admin makecontainer \"entity\" \"width\" \"height\" \"pickable\" )") return end
	local ent = ents.GetByIndex( tonumber( args[ 1 ] ))
	local width = tonumber(args[2])
	local height = tonumber(args[3])
	local pickable = util.tobool(args[4])
	local permanent = !pickable
	local container = CAKE.CreateContainerObject()
	container:SetSize(width, height)

	if pickable then
		local id = CAKE.CreateItemID()
		CAKE.SetUData(id, "container", container.UniqueID)
		CAKE.SetUData(id, "creator", ply:Nick() .. ":" .. ply:Name() .. " (" .. ply:SteamID() .. ")")
		CAKE.SetUData(id, "model", ent:GetModel())
		CAKE.CreateItem( "container_base", ent:GetPos(), ent:GetAngles(), id )
		ent:Remove()
	else
		ent:SetNWBool("permaprop", true)
		ent:SetNWString("container", container.UniqueID)
		ent:SetUnFreezable( false )
		ent:SetMoveType( MOVETYPE_NONE )
		CAKE.AddPermaProp( ent:GetModel(), ent:GetPos(), ent:GetAngles(), container.UniqueID )
	end
	container:Save()
end

function PLUGIN.Init()
	CAKE.AdminCommand( "makecontainer", Admin_MakeContainer, "Makes a container out of a prop", true, true, 4 )
end