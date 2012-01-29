CAKE.Name = string.Replace( GM.Folder, "gamemodes/", "" )

local meta = FindMetaTable( "Player" )



function meta:CanTraceTo( ent ) -- Can the player and the entity "see" eachother?

	local trace = {  }
	trace.start = self:EyePos( )
	trace.endpos = ent:GetPos()
	trace.filter = self
	
	local tr = util.TraceLine( trace )
	
	if( tr.Entity:IsValid( ) and tr.Entity:EntIndex( ) == ent:EntIndex( ) ) then return true end
	
	return false

end

function meta:Nick( ) -- Hotfix. Allows you to fetch a character's name quickly.
	
	return self:GetNWString( "name", "Unnamed" )

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

--Finds a player based on its OOC name, its IC name or its SteamID
function CAKE.FindPlayer(name)
	local count = 0

	local name = name:lower()

	for _, ply in pairs(player.GetAll()) do
		if SinglePlayer() then
			return ply --There'll be just one player on the game, so return the sole player that should be on the player list.
		end
		if string.lower(ply:Nick()):match(name) or string.lower(ply:Name()):match(name) or string.lower(ply:SteamID()):match(name) or CAKE.FormatText(ply:SteamID()):match( name ) then
			return ply
		end	
	end
	
	return false
	
end