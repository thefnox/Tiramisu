PLUGIN.Name = "Arrest Utilities" -- What is the plugin name
PLUGIN.Author = "FNox" -- Author of the plugin
PLUGIN.Description = "Utilities for zipties." -- The description or purpose of the plugin

local function ccArrest( ply, cmd, args )

	local trace = ply:GetEyeTrace( )
	if trace.StartPos:Distance( trace.HitPos ) < 150 then
		if ply:HasItem( "zipties" ) then
			if trace.Entity:IsTiraPlayer() then
				CAKE.ArrestPlayer( ply, trace.Entity )
			elseif trace.Entity.ply:IsTiraPlayer() then
				CAKE.ArrestPlayer( ply, trace.Entity.ply )
			end
		end
	end
	
end
concommand.Add( "rp_arrest", ccArrest )

--Arrests a player. First argument is the person detaining the player on the second argument.
function CAKE.ArrestPlayer( ply, detainee )
	
	if ply:HasItem( "weapon_zipties" ) and !detainee:GetNWBool( "arrested", false ) then
		timer.Create( ply:SteamID() .. "arresttimer", 0.25, 7, function()
			if ply:KeyDown( IN_ATTACK ) then
				umsg.Start( "ArrestMsg", detainee )
					umsg.Short( 1 )
				umsg.End()
				umsg.Start( "ArrestMsg", ply )
					umsg.Short( 2 )
				umsg.End()
			else
				umsg.Start( "ClearArrest", detainee )
				umsg.End()
				umsg.Start( "ClearArrest", ply )
				umsg.End()
				timer.Destroy( detainee:SteamID() .. "arrested" )
				timer.Destroy( ply:SteamID() .. "arresttimer" )
			end
		end)
		timer.Create( detainee:SteamID() .. "arrested", 2, 1, function()
			umsg.Start( "ClearArrest", detainee )
			umsg.End()
			umsg.Start( "ClearArrest", ply )
			umsg.End()
			detainee:SetAiming( false )
			detainee:SetNWBool( "arrested", true )
		end)
	end

end

--Unties a player. The first argument is the player performing the untying.
function CAKE.UnArrestPlayer( ply, detainee )
	
	if detainee:GetNWBool( "arrested", false ) then
		timer.Create( detainee:SteamID() .. "unarrested", 2, 1, function()
			detainee:SetNWBool( "arrested", false )
			umsg.Start( "ClearArrest", detainee )
			umsg.End()
			umsg.Start( "ClearArrest", ply )
			umsg.End()
		end)
		timer.Create( ply:SteamID() .. "unarresttimer", 0.25, 7, function()
			if ply:KeyDown( IN_ATTACK2 ) then
				umsg.Start( "ArrestMsg", detainee )
					umsg.Short( 3 )
				umsg.End()
				umsg.Start( "ArrestMsg", ply )
					umsg.Short( 4 )
				umsg.End()
			else
				umsg.Start( "ClearArrest", detainee )
				umsg.End()
				umsg.Start( "ClearArrest", ply )
				umsg.End()
				timer.Destroy( detainee:SteamID() .. "unarrested" )
				timer.Destroy( ply:SteamID() .. "unarresttimer" )
			end
		end)
	end
	
end

function PLUGIN.Init()

end
