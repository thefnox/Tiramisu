CAKE.SpawnPoints = {}

--rp_admin addspawn, while standing on the point you want the player to spawn on.
local function Admin_AddSpawn( ply, cmd, args)
	
	if #args == 1 then
		local pos = ply:GetPos()
		local ang = ply:EyeAngles( )
		local team = team.GetName(ply:Team())
		CAKE.AddSpawn(pos, ang, team)
	else
		local pos = ply:GetPos()
		local ang = ply:EyeAngles( )
		CAKE.AddSpawn(pos, ang)
	end
	
end

--Adds a spawnpoint

function CAKE.AddSpawn(pos, ang, plyteam)
	map = game.GetMap()
	if !plyteam then
	
		if !CAKE.SpawnPoints then 
			CAKE.SpawnPoints = {}
		end
		
		spawn = {}
		spawn.pos = pos
		spawn.ang = ang
		
		table.insert(CAKE.SpawnPoints, spawn)
		CAKE.SaveSpawns()
		
	else
	
		if !CAKE.SpawnPoints[plyteam] then 
			CAKE.SpawnPoints[plyteam] = {}
		end
		
		spawn = {}
		spawn.pos = pos
		spawn.ang = ang
		
		table.insert(CAKE.SpawnPoints[plyteam], spawn)
		CAKE.SaveSpawns()
		
	end
end

--Destroys all spawnpoints

function CAKE.ClearSpawns()
	CAKE.SpawnPoints = {}
	CAKE.SaveSpawns()
end

--Saves Spawnpoints to MapInfo

function CAKE.SaveSpawns()
		local gloncomspawns = glon.encode(CAKE.SpawnPoints)
		file.Write( CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt" , gloncomspawns)
end

--Internal function used to determine where shall a player spawn

function CAKE.SpawnPointHandle(ply)
	map = game.GetMap()
	
	if #CAKE.SpawnPoints > 0 then
		if CAKE.SpawnPoints[team.GetName(ply:Team())] then
			if #CAKE.SpawnPoints[team.GetName(ply:Team())] > 0 then
				spawn = CAKE.SpawnPoints[team.GetName(ply:Team())][math.random(1,#CAKE.SpawnPoints[team.GetName(ply:Team())])]
				ply:SetPos(spawn.pos)
				ply:SetEyeAngles(spawn.ang)
				return
			end
		end
		spawn = table.Random( CAKE.SpawnPoints )
		ply:SetPos(spawn.pos)
		ply:SetEyeAngles(spawn.ang)
	end
  	
end

--Initializes all spawnpoints

function CAKE.InitSpawns()

	if(file.Exists(CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt")) then
	
		local keydspawntable = file.Read(CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt")
		CAKE.SpawnPoints = glon.decode(keydspawntable)
		
	end
	
end

hook.Add( "Initialize", "TiramisuInitSpawns", function()
	CAKE.InitSpawns()
end)

hook.Add( "PlayerSpawn", "TiramisuSpawnHandle", function( ply )
	CAKE.SpawnPointHandle(ply)
end)

function PLUGIN.Init()
	CAKE.AdminCommand( "addspawn", Admin_AddSpawn, "Add a new spawn point on your position.", true, true, 4 )
end