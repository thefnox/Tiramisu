CAKE.Name = string.Replace( GM.Folder, "gamemodes/", "" )

local meta = FindMetaTable( "Player" )

function meta:CanTraceTo( ent, filter ) -- Can the player and the entity "see" eachother?
	filter = self
	local trace = {  }
	if CLIENT and self == LocalPlayer() then
		trace.start = CAKE.CameraPos
	else
		trace.start = self:EyePos()
	end
	if ent:IsTiraPlayer() then
		trace.endpos = ent:EyePos()
	else
		trace.endpos = ent:GetPos()
	end
	trace.filter = filter
	trace.mask = CONTENTS_SOLID
	
	local tr = util.TraceLine( trace )
	
	if !tr.HitWorld or tr.Entity == ent then return true end
	
	return false

end

local oldNick = meta.Nick
function meta:Nick( ) -- Hotfix. Allows you to fetch a character's name quickly.
	
	if self:IsCharLoaded() then
		
		return self:GetNWString("name", "Unnamed")
		
	else
		
		return oldNick(self)
		
	end
	
end

function meta:Title()
	
	return self:GetNWString("title", "")
	
end

--Calculates the position where an item should be created when dropped.
function meta:CalcDrop( )

	local pos = self:GetShootPos( )
	local ang = self:GetAimVector( )
	local tracedata = {  }
	tracedata.start = pos
	tracedata.endpos = pos+( ang*80 )
	tracedata.filter = self
	local trace = util.TraceLine( tracedata )
	
	return trace.HitPos
	
end

--Does the player have a character currently loaded?
function meta:IsCharLoaded()
	
	return self:GetNWBool( "charloaded", false )

end

--Returns a door's title
function CAKE.GetDoorTitle( door )
	return door:GetNWString( "doortitle", "" )
end

-- This formats a player's SteamID for things such as data file names
-- For example, STEAM_0:1:5947214 would turn into 015947214
function CAKE.FormatText( SteamID )

	local SteamID = SteamID or "STEAM_0:0:0"

	s = string.gsub( SteamID,"STEAM","" )
	s = string.gsub( s,":","" )
	s = string.gsub( s,"_","" )
	s = string.gsub( s," ","" )
	
	return s
	
end

--Finds a player based on their OOC name, their IC name or their SteamID
function CAKE.FindPlayer(name)
	local count = 0

	local name = name:lower()

	for _, ply in pairs(player.GetAll()) do
		if game.SinglePlayer() then
			return ply --There'll be just one player on the game, so return the sole player that should be on the player list.
		end
		if string.lower(ply:Nick()):match(name) or string.lower(ply:Name()):match(name) or string.lower(ply:SteamID()):match(name) or CAKE.FormatText(ply:SteamID()):match( name ) then
			return ply
		end	
	end
	
	return false
	
end

// i can't believe it took me ages to find out schema.lua wasn't clientside

-- Entity Loading by VorteX
function CAKE.AddEntity(path)
	
	local tbl = string.Explode("/", path)
	local filename = tbl[#tbl]:gsub(".lua", "")
	
	if file.IsDir(path, "LUA") then
		
		// just incase something breaks while loading the ent
		ENT = {
			
			Type = "anim"
			
			}
		
		if SERVER then
			
			include(path .. "init.lua")
			
		elseif CLIENT then
			
			include(path .. "init.lua")
			
		end
		
		// ok, so including those files should have created the ENT table
		-- scripted_ents.Register(ENT, filename) // register the entity
		scripted_ents.Register(ENT, tbl[#tbl - 1]) // register the entity
		ENT = nil // clear the entity table

	else

		// just incase something breaks while loading the ent
		ENT = {
			
			Type = "anim"
			
			}
		
		include(path)
		// ok, so including that file should have created the ENT table
		scripted_ents.Register(ENT, filename) // register the entity
		ENT = nil // clear the entity table

	end

end

function CAKE.AddWeapon(path)
	
	local tbl = string.Explode("/", path)
	local filename = tbl[#tbl]:gsub(".lua", "")
	
	if file.IsDir(path, "LUA") then
		
		// just incase something breaks while loading the swep
		SWEP = {
			
			Base = "weapon_base",
			Primary = {},
			Secondary = {}
			
			}
		
		if SERVER then
			
			if file.Exists(path .. "init.lua", "LUA") then
				
				include(path .. "init.lua")
				
			end
			
			if file.Exists(path .. "shared.lua", "LUA") then
				
				include(path .. "shared.lua")
				
			end
			
		elseif CLIENT then
			
			if file.Exists(path .. "cl_init.lua", "LUA") then
				
				include(path .. "cl_init.lua")
				
			end
			
			if file.Exists(path .. "shared.lua", "LUA") then
				
				include(path .. "shared.lua")
				
			end
			
		end
		
		// ok, so including that file should have created the SWEP table
		-- weapons.Register(SWEP, filename) // register the swep
		weapons.Register(SWEP, tbl[#tbl - 1]) // register the swep
		SWEP = nil // clear the swep table

	else
		
		// just incase something breaks while loading the swep
		SWEP = {
			
			Base = "weapon_base",
			Primary = {},
			Secondary = {}
			
			}
		
		include(path)
		// ok, so including that file should have created the SWEP table
		weapons.Register(SWEP, filename) // register the swep
		SWEP = nil // clear the swep table

	end
	
end

function CAKE.AddEffect(path)
	
	local tbl = string.Explode("/", path)
	local filename = tbl[#tbl]:gsub(".lua", "")
	if CLIENT then
		
		EFFECT = {}
			
	end
		
	if SERVER then
			
		AddCSLuaFile(path)
			
	else
			
		include(path)
			
	end
		
	if CLIENT then
			
		// ok, so including those files should have created the EFFECT table
		effects.Register(EFFECT, filename) // register the effect
		EFFECT = nil // clear the entity table
		
	end

end


function CAKE.AddSchemaEntities(schema, global)

	local dir1 = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/entities/"
	if global then dir1 = CAKE.Name .. "/gamemode/entities/" end
	
	local entityfiles, entitydirs = file.Find(dir1 .. "entities/*", "LUA")

	for k, v in pairs(entityfiles) do
		
		CAKE.AddEntity(dir1 .. "entities/" .. v)
		
	end

	for k, v in pairs(entitydirs) do
		
		CAKE.AddEntity(dir1 .. "entities/" .. v .. "/")
		
	end

	local weaponfiles, weapondirs = file.Find(dir1 .. "weapons/*", "LUA")

	for k, v in pairs(weaponfiles) do
		
		CAKE.AddWeapon(dir1 .. "weapons/" .. v)
		
	end

	for k, v in pairs(weapondirs) do
		
		CAKE.AddWeapon(dir1 .. "weapons/" .. v .. "/")
		
	end

	local _, effectdirs = file.Find(dir1 .. "effects/*", "LUA")

	for k, v in pairs(effectdirs) do

		CAKE.AddEffect(dir1 .. "effects/" .. V .. "/init.lua")
			
	end

end