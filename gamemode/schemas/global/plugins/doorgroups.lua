PLUGIN.Name = "Doorgroups"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles doors"; -- The description or purpose of the plugin

function GM:PlayerUse(ply, entity)

	if(CAKE.IsDoor(entity)) then
		local doorgroups = CAKE.GetDoorGroup(entity)
		local groupdoor = CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "doorgroups" ) or 0
		for k, v in pairs(doorgroups) do
			if( tonumber( CAKE.GetCharField( ply, "doorgroup" ) ) == tonumber( v ) or tonumber( groupdoor ) == tonumber( v ) ) then
				entity:Fire( "open", "", 0 );
			end
		end
	end
	return self.BaseClass:PlayerUse(ply, entity);
end

local function usepressed(ply, key) --Override for City 8 doors.
	if( key == IN_USE ) then
		local trace = ply:GetEyeTrace( )
		if( trace.HitNonWorld ) then
			local entity = trace.Entity
			if(CAKE.IsDoor(entity)) then
				local doorgroups = CAKE.GetDoorGroup(entity)
				local groupdoor = CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "doorgroups" ) or 0
				for k, v in pairs(doorgroups) do
					if( tonumber( groupdoor ) == tonumber( v ) ) then
						entity:Fire( "open", "", 0 );
					end
				end
			end
			if( entity:GetClass() == "item_prop" ) then
				ply:ConCommand( "rp_pickup " .. tostring( entity:EntIndex() ) )
			end
		end
	end
end
hook.Add( "KeyPress", "usepressedoverride", usepressed )

function Admin_SetDoorGroup( ply, cmd, args )

	   if( #args != 2 ) then
	   
		   CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin setdoorgroup \"name\" doorgroup )" );
		   return;
		   
	   end
	   
	   local plyname = args[ 1 ];
	   local doorgroup = args[ 2 ];
	   local pl = CAKE.FindPlayer( plyname );
	   if( pl != nil and pl:IsValid( ) and pl:IsPlayer( ) ) then
	   
		   CAKE.SetCharField( pl, "doorgroup", doorgroup )
		   CAKE.SendChat( pl, "Your doorgroup has been set to " .. tostring( doorgroup ) )
	   
	   else
	   
		   CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" );
		   
	   end
end
CAKE.AdminCommand( "setdoorgroup", Admin_SetDoorGroup, "Set a players doorgroup", true, true, 3 );

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "doorgroup", 0 );
	
end