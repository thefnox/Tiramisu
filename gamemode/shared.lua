CAKE.Name = string.Replace( GM.Folder, "gamemodes/", "" )

local meta = FindMetaTable( "Player" )

function meta:CanTraceTo( ent ) -- Can the player and the entity "see" eachother?

	local trace = {  }
	trace.start = self:EyePos( )
	trace.endpos = ent:LocalToWorld(ent:OBBCenter())
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