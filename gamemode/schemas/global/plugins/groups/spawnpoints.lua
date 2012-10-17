TIRA.SpawnPoints = {}

--rp_admin addspawn, while standing on the point you want the player to spawn on.
local function Admin_AddSpawn( ply, cmd, args)
	
	local spawngroup = tonumber(args[1])
	table.remove(args, 1)
	local name = table.concat( args, " " )

	if TIRA.SpawnPoints[spawngroup] and TIRA.SpawnPoints[spawngroup][name] then
		TIRA.SendError( ply, "Spawnpoint already exists! Please enter another name.")
	else
		TIRA.AddSpawn(name, ply:GetPos(), ply:GetAngles(), spawngroup)
		TIRA.SendSpawnPoints(ply)
	end

end

local function Admin_RemoveSpawn( ply, cmd, args)
	
	local spawngroup = tonumber(args[1])
	table.remove(args, 1)
	local name = table.concat( args, " " )

	if TIRA.SpawnPoints[spawngroup] and TIRA.SpawnPoints[spawngroup][name] then
		TIRA.SpawnPoints[spawngroup][name] = nil
	end

	TIRA.SaveSpawns()
	TIRA.SendSpawnPoints(ply)

end

--Adds a spawnpoint

function TIRA.AddSpawn(name, pos, ang, spawngroup)
	spawngroup = spawngroup or 0

	if !TIRA.SpawnPoints[spawngroup] then
		TIRA.SpawnPoints[spawngroup] = {}
	end

	TIRA.SpawnPoints[spawngroup][name] = {}
	TIRA.SpawnPoints[spawngroup][name].pos = pos
	TIRA.SpawnPoints[spawngroup][name].ang = ang

	TIRA.SaveSpawns()
end

--Destroys all spawnpoints

function TIRA.ClearSpawns()
	TIRA.SpawnPoints = {}
	TIRA.SaveSpawns()
end

--Saves Spawnpoints to MapInfo

function TIRA.SaveSpawns()
	file.Write( TIRA.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt" , TIRA.Serialize(TIRA.SpawnPoints))
end

--Internal function used to determine where shall a player spawn

function TIRA.SpawnPointHandle(ply)
	local spawngroup = 0
	if ply:IsCharLoaded() then
		if TIRA.GroupExists( TIRA.GetCharField( ply, "activegroup" )) then
			spawngroup = tonumber(TIRA.GetGroup(TIRA.GetCharField( ply, "activegroup" )):GetField( "spawngroup" ) or 0)
		end
	end 
	
	if TIRA.SpawnPoints[spawngroup] and table.Count(TIRA.SpawnPoints[spawngroup]) > 0 then
		local spawn
		while(!spawn) do
			spawn = table.Random(TIRA.SpawnPoints[spawngroup])
		end
		ply:SetPos(spawn.pos)
		ply:SetEyeAngles(spawn.ang)
	end
end

--Initializes all spawnpoints

function TIRA.InitSpawns()
	if(file.Exists(TIRA.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt")) then
		TIRA.SpawnPoints = TIRA.Deserialize(file.Read(TIRA.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt"))
	end
end

function TIRA.SendSpawnPoints( ply )
	if TIRA.PlayerRank(ply) > 3 then
		datastream.StreamToClients( ply, "Tiramisu.ReceiveSpawnPoints", TIRA.SpawnPoints )
	end
end

hook.Add( "Initialize", "TiramisuInitSpawns", function()
	TIRA.InitSpawns()
end)

hook.Add( "PlayerSpawn", "TiramisuSpawnHandle", function( ply )
	TIRA.SpawnPointHandle(ply)
	TIRA.SendSpawnPoints(ply)
end)

function PLUGIN.Init()
	TIRA.AdminCommand( "addspawn", Admin_AddSpawn, "Add a new spawn point on your position.", true, true, 4 )
	TIRA.AdminCommand( "removespawn", Admin_RemoveSpawn, "Removes a spawnpoint", true, true, 4 )
end