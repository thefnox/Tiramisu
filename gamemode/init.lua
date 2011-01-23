-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- init.lua
-- This file calls the rest of the script
-------------------------------

-- Set up the gamemode
DeriveGamemode( "sandbox" );
GM.Name = "Tiramisu";

-- Define global variables
CAKE = {  };
CAKE.Running = false;
CAKE.Loaded = false;
CAKE.Name = GM.Name

-- Server Includes
require( "glon" )
if not(datastream) then  
    require("datastream");  
end  

include( "shared.lua" ); -- Shared Functions
include( "log.lua" ); -- Logging functions
include( "error_handling.lua" ); -- Error handling functions
include( "hooks.lua" ); -- CakeScript Hook System
include( "configuration.lua" ); -- Configuration data
include( "player_data.lua" ); -- Player data functions
include( "player_shared.lua" ); -- Shared player functions
include( "player_util.lua" ); -- Player functions
include( "admin.lua" ); -- Admin functions
include( "admin_cc.lua" ); -- Admin commands
include( "chat.lua" ); -- Chat Commands
include( "concmd.lua" ); -- Concommands
include( "util.lua" ); -- Functions
include( "charactercreate.lua" ); -- Character Creation functions
include( "items.lua" ); -- Items system
include( "schema.lua" ); -- Schema system
include( "plugins.lua" ); -- Plugin system
include( "teams.lua" ); -- Teams system
include( "client_resources.lua" ); -- Sends files to the client
include( "animations.lua" ); -- Animations
include( "doors.lua" ); -- Doors
include( "resources.lua" ) -- Automatic resource handling
include( "resourcex.lua" ) -- Resource downloading
include( "sn3_base_sv.lua" )

CAKE.LoadSchema( CAKE.ConVars[ "Schema" ] ); -- Load the schema and plugins, this is NOT initializing.

CAKE.Loaded = true; -- Tell the server that we're loaded up

function GM:Initialize( ) -- Initialize the gamemode
	
	-- My reasoning for this certain order is due to the fact that plugins are meant to modify the gamemode sometimes.
	-- Plugins need to be initialized before gamemode and schema so it can modify the way that the plugins and schema actually work.
	-- AKA, hooks.
	
	CAKE.DayLog( "script.txt", "Plugins Initializing" );
	CAKE.InitPlugins( );
	
	CAKE.DayLog( "script.txt", "Schemas Initializing" );
	CAKE.InitSchemas( );
	
	CAKE.DayLog( "script.txt", "Gamemode Initializing" );
	
	game.ConsoleCommand( "exec cakevars.cfg\n" ) -- Put any configuration variables in cfg/cakevars.cfg, set it using rp_admin setconvar varname value
	
	CAKE.InitSpawns()
	CAKE.InitStashes()
	CAKE.InitTime();
	CAKE.LoadDoors();
	
	timer.Create( "timesave", 120, 0, CAKE.SaveTime );
	timer.Create( "sendtime", 1, 0, CAKE.SendTime );
	
	CAKE.CallHook("GamemodeInitialize");
	
	CAKE.Running = true;
	
end

-- Player Initial Spawn
function GM:PlayerInitialSpawn( ply )
	
	CAKE.SpawnPointHandle(ply)
	
	-- Call the hook before we start initializing the player
	CAKE.CallHook( "Player_Preload", ply );
	
	-- Send them valid models
	for k, v in pairs( CAKE.ValidModels ) do
		umsg.Start( "addmodel", ply );
		
			umsg.String( v );
			
		umsg.End( );
	end
	
	for k, v in pairs( CAKE.Schemafile ) do
		umsg.Start( "addschema", ply );
			
			print(v)
			umsg.String( v );
			
		umsg.End( );
	end

	for k, v in pairs( CAKE.CurrencyData ) do
		umsg.Start( "addcurrency", ply )
			umsg.String( v.Name )
			umsg.String( v.Slang )
			umsg.String( v.Abr )
		umsg.End()
	end

	
	-- Set some default variables
	ply.Ready = false;
	ply:SetNWInt( "chatopen", 0 );
	ply:SetModel( "models/kleiner.mdl" )
	ply:ChangeMaxHealth(CAKE.ConVars[ "DefaultHealth" ]);
	ply:ChangeMaxArmor(0);
	ply:ChangeMaxWalkSpeed(CAKE.ConVars[ "WalkSpeed" ]);
	ply:ChangeMaxRunSpeed(CAKE.ConVars[ "RunSpeed" ]);
	
	/*
	-- Check if they are admins
	if( ply:IsUserGroup("admin") )	then
		--ply:SetUserGroup( "superadmin" );
		CAKE.SetPlayerField( ply, "adrank", "Administrator" )
	end
	
	if( ply:IsUserGroup("superadmin") ) then
		--ply:SetUserGroup( "admin" );
		CAKE.SetPlayerField( ply, "adrank", "Super Administrator" )
	end
	*/
	
	-- Send them all the teams
	CAKE.InitTeams( ply );
	
	-- Load their data, or create a new datafile for them.
	CAKE.LoadPlayerDataFile( ply );

	-- Call the hook after we have finished initializing the player
	CAKE.CallHook( "Player_Postload", ply );
	
	self.BaseClass:PlayerInitialSpawn( ply )

end

function GM:PlayerLoadout(ply)

	CAKE.CallHook( "PlayerLoadout", ply );
	if(ply:GetNWInt("charactercreate") != 1) then
		
		if(CAKE.Teams[ply:Team()] != nil) then
		
			for k, v in pairs(CAKE.Teams[ply:Team()]["weapons"]) do
			
				ply:Give(v);
				
			end
			
		end

		ply:Give("hands");
		
		ply:SelectWeapon("hands");
		
	end
	
end

function GM:PlayerSpawn( ply )

	if( !ply:IsCharLoaded() ) then
		return; -- Player data isn't loaded. This is an initial spawn.
	end
	
	CAKE.SpawnPointHandle(ply)
	
	if( ply:IsUserGroup("admin") )	then
		CAKE.SetPlayerField( ply, "adrank", "Administrator" )
	end
	
	if( ply:IsUserGroup("superadmin") ) then
		CAKE.SetPlayerField( ply, "adrank", "Super Administrator" )
	end
	
	CAKE.SavePlayerData( ply )
	
	umsg.Start( "recieveragdoll", ply )
		umsg.Short( nil )
	umsg.End()--This is to reset the player's view back to their character after they die.
	
	ply:StripWeapons( );
	
	if( ply:GetNWInt( "deathmode" ) == 1 ) then
	
		ply:SetNWInt( "deathmode", 0 );
		ply:SetViewEntity( ply );
		
	end
	if( ply:GetNWBool( "ragdollmode", false ) ) then 
		ply:SetNWBool( "ragdollmode", false );
		ply:SetViewEntity( ply );
	end
	
	timer.Create( ply:SteamID() .. "savetimer", 10, 0, function()
		CAKE.SavePlayerData( ply )
	end)
	
	-- Reset all the variables
	ply:ChangeMaxHealth(CAKE.ConVars[ "DefaultHealth" ] - ply:MaxHealth());
	ply:ChangeMaxArmor(0 - ply:MaxArmor());
	ply:ChangeMaxWalkSpeed(CAKE.ConVars[ "WalkSpeed" ] - ply:MaxWalkSpeed());
	ply:ChangeMaxRunSpeed(CAKE.ConVars[ "RunSpeed" ] - ply:MaxRunSpeed());
	ply:SetAiming( false )
	
	self.BaseClass:PlayerSpawn( ply )
	GAMEMODE:SetPlayerSpeed( ply, CAKE.ConVars[ "WalkSpeed" ], CAKE.ConVars[ "RunSpeed" ] );
	CAKE.CallHook( "PlayerSpawn", ply )
	CAKE.CallTeamHook( "PlayerSpawn", ply ); -- Change player speeds perhaps?
	
	
end


function GM:PlayerSetModel(ply)
	if !ply:GetNWBool( "specialmodel", false ) then
		if(ply:IsCharLoaded()) then
				local m = ""
				if( CAKE.GetCharField( ply, "gender" ) == "Female" ) then
					m = "models/Gustavio/femaleanimtree.mdl"
					ply:SetNWString( "gender", "Female" )
				else
					m = "models/Gustavio/maleanimtree.mdl"
					ply:SetNWString( "gender", "Male" )
				end
				
				ply:SetModel( m );
				CAKE.CallHook( "PlayerSetModel", ply, m);
		else
			
			ply:SetModel("models/kleiner.mdl");
			CAKE.CallHook( "PlayerSetModel", ply, m);
			
		end
	end
	CAKE.CallTeamHook( "PlayerSetModel", ply, m or ply:GetModel()); -- Hrm. Looks like the teamhook will take priority over the regular hook.. PREPARE FOR HELLFIRE (puts on helmet)

end

local function FunkyPlayerDisconnect( ply )
	timer.Destroy( ply:SteamID() .. "rechargetimer" )
	--CAKE.SetPlayerField( ply, "lastlogin", tostring( CAKE.ClockMins ) .. ";" .. tostring( CAKE.ClockMonth ) .. "/" .. tostring( CAKE.ClockDay ) .. "/" .. tostring( CAKE.ClockYear ) )
	CAKE.SavePlayerData( ply )
end
hook.Add( "PlayerDisconnected", "CAKE.PlayerDisconnect", FunkyPlayerDisconnect )


function GM:PlayerDeath(ply)
	
	CAKE.StandUp( ply )
	CAKE.DeathMode(ply);
	CAKE.CallHook("PlayerDeath", ply);
	CAKE.CallTeamHook("PlayerDeath", ply);
	
end

function GM:PlayerDeathThink(ply)

	ply.nextsecond = CAKE.NilFix(ply.nextsecond, CurTime())
	ply.deathtime = CAKE.NilFix(ply.deathtime, CAKE.ConVars[ "Respawn_Timer" ]);
	
	if(CurTime() > ply.nextsecond) then
	
		if(ply.deathtime < CAKE.ConVars[ "Respawn_Timer" ]) then
		
			ply.deathtime = ply.deathtime + 1;
			ply.nextsecond = CurTime() + 1;
			ply:SetNWInt("deathmoderemaining", CAKE.ConVars[ "Respawn_Timer" ] - ply.deathtime);
			
		else
			/*
			if ply.CheatedDeath then --If the player used !acceptdeath then just spawn him normally
				ply:Spawn();
			else
				ply:Spawn();
				ply:SetPos( ply.deathrag:GetPos() + Vector( 0, 10, 0 ) )
				ply:SetHealth( 10 )
				ply.deathrag:Remove()
				ply.deathrag = nil
			end*/
			CAKE.StandUp( ply )
			ply:Spawn()
			ply.deathtime = nil;
			ply.nextsecond = nil;
			ply:SetNWInt("deathmode", 0);
			ply:SetNWInt("deathmoderemaining", 0);
			
		end
		
	end
	
end


function GM:DoPlayerDeath( ply, attacker, dmginfo )

	-- We don't want kills, deaths, nor ragdolls being made. Kthx.
	
end