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

function meta:Nick( ) -- Hotfix. Allows you to fetch a character's name quickly.
	return self:GetNWString( "name", "Unnamed" )
end

function meta:Title()
	return self:GetNWString( "title", "" )
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

local schema = CAKE.ConVars[ "Schema" ]

local dir1 = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/entities/"

local entityfiles, entitydirs = file.Find(dir1 .. "entities/*", "LUA")

for k, v in pairs(entityfiles) do
	
	// just incase something breaks while loading the ent
	ENT = {
		
		Type = "anim"
		
		}
	
	include(dir1 .. "entities/" .. v)
	// ok, so including that file should have created the ENT table
	scripted_ents.Register(ENT, v) // register the entity
	ENT = nil // clear the entity table
	
end

for k, v in pairs(entitydirs) do
	
	// just incase something breaks while loading the ent
	ENT = {
		
		Type = "anim"
		
		}
	
	if SERVER then
		
		include(dir1 .. "entities/" .. v .. "/init.lua")
		
	elseif CLIENT then
		
		include(dir1 .. "entities/" .. v .. "/cl_init.lua")
		
	end
	
	// ok, so including those files should have created the ENT table
	scripted_ents.Register(ENT, v) // register the entity
	ENT = nil // clear the entity table
	
end

local weaponfiles, weapondirs = file.Find(dir1 .. "weapons/*", "LUA")

for k, v in pairs(weaponfiles) do
	
	// just incase something breaks while loading the swep
	SWEP = {
		
		Base = "weapon_base",
		Primary = {},
		Secondary = {}
		
		}
	
	include(dir1 .. "weapons/" .. v)
	// ok, so including that file should have created the SWEP table
	weapons.Register(SWEP, v) // register the swep
	SWEP = nil // clear the swep table
	
end

for k, v in pairs(weapondirs) do
	
	// just incase something breaks while loading the swep
	SWEP = {
		
		Base = "weapon_base",
		Primary = {},
		Secondary = {}
		
		}
	
	if SERVER then
		
		if file.Exists(dir1 .. "weapons/" .. v .. "/init.lua", "LUA") then
			
			include(dir1 .. "weapons/" .. v .. "/init.lua")
			
		end
		
		if file.Exists(dir1 .. "weapons/" .. v .. "/shared.lua", "LUA") then
			
			include(dir1 .. "weapons/" .. v .. "/shared.lua")
			
		end
		
	elseif CLIENT then
		
		if file.Exists(dir1 .. "weapons/" .. v .. "/cl_init.lua", "LUA") then
			
			include(dir1 .. "weapons/" .. v .. "/cl_init.lua")
			
		end
		
		if file.Exists(dir1 .. "weapons/" .. v .. "/shared.lua", "LUA") then
			
			include(dir1 .. "weapons/" .. v .. "/shared.lua")
			
		end
		
	end
	
	// ok, so including that file should have created the SWEP table
	weapons.Register(SWEP, v) // register the swep
	SWEP = nil // clear the swep table
	
end

local _, effectdirs = file.Find(dir1 .. "effects/*", "LUA")

for k, v in pairs(effectdirs) do
	
	if CLIENT then
		
		EFFECT = {}
		
	end
	
	if SERVER then
		
		AddCSLuaFile(dir1 .. "effects/" .. v .. "/init.lua")
		
	else
		
		include(dir1 .. "effects/" .. v .. "/init.lua")
		
	end
	
	if CLIENT then
		
		// ok, so including those files should have created the EFFECT table
		effects.Register(EFFECT, v) // register the effect
		EFFECT = nil // clear the entity table
		
	end
		
end