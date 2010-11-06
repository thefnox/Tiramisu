-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- admin.lua
-- Admin functions. Admin concommands are in admin_cc.lua
-------------------------------

SuperAdmins = { };
Admins = { };

CAKE.AdminCommands = {  }
CAKE.AdminRanks = {  } 

function CAKE.AnnounceAction( ply, action )

	local s = "[ ADMIN ] " .. ply:Name( ) .. " " .. action;

	for k, v in pairs( player.GetAll( ) ) do

		CAKE.SendChat( v, s )
		
	end

end

-- This will create an admin function.
function CAKE.AdminCommand( ccName, func, description, CanRunFromConsole, CanRunFromAdmin, MinRank )

		local cmd = {  };
		cmd.func = func;
		cmd.desc = description;
		cmd.CanRunFromConsole = CAKE.NilFix(CanRunFromConsole, true);
		cmd.CanRunFromAdmin = CAKE.NilFix(CanRunFromAdmin, true);
		cmd.MinRank = CAKE.NilFix(MinRank, 0);

		CAKE.AdminCommands[ ccName ] = cmd;
	
end

function CAKE.PlayerRank(ply)
	if CAKE.GetPlayerField( ply, "adrank" ) == "Player" then
		return 0
	else
		return CAKE.AdminRanks[CAKE.GetPlayerField( ply, "adrank" )].rank
	end
end

-- Syntax is rp_admin command args
function ccAdmin( ply, cmd, args )

	local cmd = CAKE.NilFix( CAKE.AdminCommands[args[ 1 ]], 0);
	
	if( cmd == 0 ) then
	
		CAKE.SendChat( ply, "That is not a valid command!" );
		return;
		
	end
	
	local func = cmd.func; -- Retrieve the function
	local CanRunFromConsole = cmd.CanRunFromConsole; -- Can it be run from the console
	local CanRunFromAdmin = cmd.CanRunFromAdmin; -- Can it be run from a player's console
	local MinRank = cmd.MinRank
	local CMDName = args[1]
	
	table.remove( args, 1 ); -- Remove the admin command from the arguments
	if( ply:EntIndex( ) == 0 ) then -- We're dealing with a console
		
		if( CanRunFromConsole ) then
		
			func( ply, cmd, args );
			
		else

			CAKE.PrintConsole( "You cannot run this command from server console!" );
			
		end
		
	else	
	
		if CAKE.PlayerRank(ply) > 0 then -- We're dealing with an admin.
			
			if CAKE.PlayerRank(ply) > cmd.MinRank then
			
				func( ply, cmd, args )
				
			else
			
				if !ply:IsSuperAdmin() then CAKE.SendChat( ply, "You are of insufficient rank!" ) end
				
			end
			
			if ply:IsSuperAdmin() then
			
				if CMDName == "setrank" then
				
					func( ply, cmd, args)
			
				end
			
			end
		
		else 
		
			if ply:IsSuperAdmin() then
			
				if CMDName == "setrank" then
				
					func( ply, cmd, args)
			
				end
			
			end
		
			if CAKE.PlayerRank(ply) == 0 then
				CAKE.SendChat( ply, "You are not an admin!")
			end
		
		end
	
	end
		
end
concommand.Add("rp_admin", ccAdmin) 

function CAKE.AddAdminRank(name, int)
	
	rank = {}
	rank.rank = int
	rank.name = name
	
	CAKE.AdminRanks[name] = rank
	
end

CAKE.AddAdminRank("Player", 0)