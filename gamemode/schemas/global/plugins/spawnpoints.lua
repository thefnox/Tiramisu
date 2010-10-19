PLUGIN.Name = "Sitting"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles the process of putting your ass on top of something"; -- The description or purpose of the plugin

CAKE.SpawnPoints = {}

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

function CAKE.ClearSpawns()
	CAKE.SpawnPoints = {}
	CAKE.SaveSpawns()
end

function CAKE.SaveSpawns()
		local gloncomspawns = glon.encode(CAKE.SpawnPoints)
		file.Write( CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt" , gloncomspawns)
end

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

function CAKE.InitSpawns()

	if(file.Exists(CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt")) then
	
		local keydspawntable = file.Read(CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_spawns.txt")
		CAKE.SpawnPoints = glon.decode(keydspawntable)
		
	end
	
end

function PLUGIN.Init()
end