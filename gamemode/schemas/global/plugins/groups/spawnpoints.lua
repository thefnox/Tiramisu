CAKE.SpawnPoints = {}

--rp_admin addspawn, while standing on the point you want the player to spawn on.
local function Admin_AddSpawn( ply, cmd, args)
	
	local spawngroup = tonumber(args[1])
	table.remove(args, 1)
	local name = table.concat( args, " " )

	if CAKE.SpawnPoints[spawngroup] and CAKE.SpawnPoints[spawngroup][name] then
		CAKE.SendError( ply, "Spawnpoint already exists! Please enter another name.")
	else
		CAKE.AddSpawn(name, ply:GetPos(), ply:GetAngles(), spawngroup)
		CAKE.SendSpawnPoints(ply)
	end

end

local function Admin_RemoveSpawn( ply, cmd, args)
	
	local spawngroup = tonumber(args[1])
	table.remove(args, 1)
	local name = table.concat( args, " " )

	if CAKE.SpawnPoints[spawngroup] and CAKE.SpawnPoints[spawngroup][name] then
		CAKE.SpawnPoints[spawngroup][name] = nil
	end

	CAKE.SaveSpawns()
	CAKE.SendSpawnPoints(ply)

end

--Adds a spawnpoint

function CAKE.AddSpawn(name, pos, ang, spawngroup)
	spawngroup = spawngroup or 0

	if !CAKE.SpawnPoints[spawngroup] then
		CAKE.SpawnPoints[spawngroup] = {}
	end

	CAKE.SpawnPoints[spawngroup][name] = {}
	CAKE.SpawnPoints[spawngroup][name].pos = pos
	CAKE.SpawnPoints[spawngroup][name].ang = ang

	CAKE.SaveSpawns()
end

--Destroys all spawnpoints

function CAKE.ClearSpawns()
	CAKE.SpawnPoints = {}
	CAKE.SaveSpawns()
end

--Saves Spawnpoints to MapInfo

function CAKE.SaveSpawns()
	file.Write( CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt" , glon.encode(CAKE.SpawnPoints))
end

--Internal function used to determine where shall a player spawn

function CAKE.SpawnPointHandle(ply)
	local spawngroup = 0
	if ply:IsCharLoaded() then
		if CAKE.GroupExists( CAKE.GetCharField( ply, "activegroup" )) then
			spawngroup = tonumber(CAKE.GetGroup(CAKE.GetCharField( ply, "activegroup" )):GetField( "spawngroup" ) or 0)
		end
	end 
	
	if CAKE.SpawnPoints[spawngroup] and table.Count(CAKE.SpawnPoints[spawngroup]) > 0 then
		local spawn
		while(!spawn) do
			spawn = table.Random(CAKE.SpawnPoints[spawngroup])
		end
		ply:SetPos(spawn.pos)
		ply:SetEyeAngles(spawn.ang)
	end
end

--Initializes all spawnpoints

function CAKE.InitSpawns()
	if(file.Exists(CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt")) then
		CAKE.SpawnPoints = glon.decode(file.Read(CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt"))
	end
end

function CAKE.SendSpawnPoints( ply )
	if CAKE.PlayerRank(ply) > 3 then
		datastream.StreamToClients( ply, "Tiramisu.ReceiveSpawnPoints", CAKE.SpawnPoints )
	end
end

hook.Add( "Initialize", "TiramisuInitSpawns", function()
	CAKE.InitSpawns()
end)

hook.Add( "PlayerSpawn", "TiramisuSpawnHandle", function( ply )
	CAKE.SpawnPointHandle(ply)
	CAKE.SendSpawnPoints(ply)
end)

function PLUGIN.Init()
	CAKE.AdminCommand( "addspawn", Admin_AddSpawn, "Add a new spawn point on your position.", true, true, 4 )
	CAKE.AdminCommand( "removespawn", Admin_RemoveSpawn, "Removes a spawnpoint", true, true, 4 )
end