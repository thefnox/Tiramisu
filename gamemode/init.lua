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
include( "daynight.lua" ); -- Day/Night and Cloc
include( "concmd.lua" ); -- Concommands
include( "util.lua" ); -- Functions
include( "charactercreate.lua" ); -- Character Creation functions
include( "items.lua" ); -- Items system
include( "schema.lua" ); -- Schema system
include( "rclick.lua" ) -- Rightclick system
include( "currency.lua" ) -- Currency System
include( "plugins.lua" ); -- Plugin system
include( "teams.lua" ); -- Teams system
include( "client_resources.lua" ); -- Sends files to the client
include( "animations.lua" ); -- Animations
include( "doors.lua" ); -- Doors
include( "sql_main.lua" ); --MySQL handling
include( "spawnpoints.lua" ) -- Handling spawn points.
include( "stashes.lua" ) -- Stashes
include( "resources.lua" ) -- Automatic resource handling
--include( "sv_usermessages.lua" )

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
		datastream.StreamToClients( ply, "addcurrency", 
		{ 
			["name"] = v.Name, 
			["centenials"] = v.Centenials,
			["slang"] = v.Slang,
			["abr"] = v.Abr
		} );
	end
	

	
	-- Set some default variables
	ply.Ready = false;
	ply:SetNWInt( "chatopen", 0 );
	ply:ChangeMaxHealth(CAKE.ConVars[ "DefaultHealth" ]);
	ply:ChangeMaxArmor(0);
	ply:ChangeMaxWalkSpeed(CAKE.ConVars[ "WalkSpeed" ]);
	ply:ChangeMaxRunSpeed(CAKE.ConVars[ "RunSpeed" ]);
	
	-- Check if they are admins
	if( table.HasValue( SuperAdmins, ply:SteamID( ) ) ) then ply:SetUserGroup( "superadmin" ); end
	if( table.HasValue( Admins, ply:SteamID( ) ) ) then ply:SetUserGroup( "admin" ); end
	
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
	
		-- if(ply:IsAdmin() or ply:IsSuperAdmin()) then ply:Give("gmod_tool"); end
		
		if(CAKE.Teams[ply:Team()] != nil) then
		
			for k, v in pairs(CAKE.Teams[ply:Team()]["weapons"]) do
			
				ply:Give(v);
				
			end
			
		end

		ply:Give("hands");
		
		ply:SelectWeapon("hands");
		
	end
	
	if ply.RecieveFactionLoadout then
		local ranks = CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "ranks" )
		local loadout = ranks[ CAKE.GetCharField( ply, "grouprank" ) ][ "loadout" ]
		for k, v in pairs( loadout ) do
			if !ply:HasItem( v ) then
				ply:GiveItem( v )
			end
		end
	end
	
end

function GM:PlayerSpawn( ply )
	
	if( !ply:IsCharLoaded() ) then
		return; -- Player data isn't loaded. This is an initial spawn.
	end
	
	CAKE.SavePlayerData( ply )
	
	datastream.StreamToClients( ply, "RecieveViewRagdoll", { ["ragdoll"] = false } )
	
	ply.DamageProtection = {}
	ply:StripWeapons( );
	
	CAKE.SpawnPointHandle( ply )
	
	if( ply:GetNWInt( "deathmode" ) == 1 ) then
	
		ply:SetNWInt( "deathmode", 0 );
		ply:SetViewEntity( ply );
		
	end
	if( ply:GetNWBool( "ragdollmode", false ) ) then 
		ply:SetNWBool( "ragdollmode", false );
		ply:SetViewEntity( ply );
	end
	
	if !timer.IsTimer( ply:SteamID() .. "rechargetimer" ) then
		timer.Create( ply:SteamID() .. "rechargetimer", 1, 0, function()
			if ValidEntity( ply ) and ply:Health() < 61 then
				ply:SetHealth( ply:Health() + 1 )
			end
		end )
	else
		timer.Start( ply:SteamID() .. "rechargetimer" )
	end
	
	timer.Create( ply:SteamID() .. "savetimer", 10, 0, function()
		CAKE.SavePlayerData( ply )
	end)
	
	timer.Create( ply:SteamID() .. "gunchecktimer", 0.1, 0, function()
		ply:HideActiveWeapon()
	end)
	
	-- Reset all the variables
	ply:ChangeMaxHealth(CAKE.ConVars[ "DefaultHealth" ] - ply:MaxHealth());
	ply:ChangeMaxArmor(0 - ply:MaxArmor());
	ply:ChangeMaxWalkSpeed(CAKE.ConVars[ "WalkSpeed" ] - ply:MaxWalkSpeed());
	ply:ChangeMaxRunSpeed(CAKE.ConVars[ "RunSpeed" ] - ply:MaxRunSpeed());
	ply:SetPoseParameter("move_yaw", 0 )
	MakeUnAim( ply )
	
	ply:RefreshExtraInventory( )
	
	if CAKE.GetCharField( ply, "group" ) == "None" or CAKE.GetCharField( ply, "group" ) == "none" then
		datastream.StreamToClients( ply, "recievemygroup", {} )
	else
		local name = CAKE.GetCharField( ply, "group" )
		local rank = CAKE.GetCharField( ply, "grouprank" )
		local rankname = CAKE.GetRankPermission( name, rank, "formalname" )
		local type = CAKE.GetGroupField( name, "Type" )
		local founder = CAKE.GetGroupField( name, "Founder" )
		local rankpermissions = CAKE.GetRankPermissions( name, rank )
		datastream.StreamToClients( ply, "recievemygroup", {
			[ "Name" ]		= name,
			[ "Type" ]		= type,
			[ "Founder" ]	= founder,
			[ "Rank" ]		= rankname,
			[ "RankPermissions" ] = rankpermissions,
			[ "Inventory" ]	= {}
		})
	end
	
	self.BaseClass:PlayerSpawn( ply )
	GAMEMODE:SetPlayerSpeed( ply, CAKE.ConVars[ "WalkSpeed" ], CAKE.ConVars[ "RunSpeed" ] );
	CAKE.CallHook( "PlayerSpawn", ply )
	CAKE.CallTeamHook( "PlayerSpawn", ply ); -- Change player speeds perhaps?
	umsg.Start( "closeplayermenu", ply );
	umsg.End( )
	
end


function GM:PlayerSetModel(ply)
	
	if !ply:GetNWBool( "specialmodel", false ) then
		if(ply:IsCharLoaded()) then
				local m = ""
				if( CAKE.GetCharField( ply, "gender" ) == "Female" ) then
					m = "models/Gustavio/femaleanimtree.mdl"
					--m = "models/alyx.mdl"
					ply:SetNWString( "gender", "Female" )
				else
					m = "models/Gustavio/maleanimtree.mdl"
					--m = "models/barney.mdl"
					ply:SetNWString( "gender", "Male" )
				end
				
				ply:SetModel( m );
				--ply:SetMaterial( "null" )
				--ply:SetRenderMode( RENDERMODE_NORMAL )
				CAKE.CallHook( "PlayerSetModel", ply, m);
		else
			
			local m = "models/kleiner.mdl";
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

	CAKE.DeathMode(ply);
	CAKE.CallHook("PlayerDeath", ply);
	CAKE.CallTeamHook("PlayerDeath", ply);
	
end

function GM:PlayerDeathThink(ply)

	ply.nextsecond = CAKE.NilFix(ply.nextsecond, CurTime())
	ply.deathtime = CAKE.NilFix(ply.deathtime, 60);
	
	if(CurTime() > ply.nextsecond) then
	
		if(ply.deathtime < 59) then
		
			ply.deathtime = ply.deathtime + 1;
			ply.nextsecond = CurTime() + 1;
			ply:SetNWInt("deathmoderemaining", 60 - ply.deathtime);
			
		else
			if ply.CheatedDeath then
				ply:Spawn();
			else
				ply:Spawn();
				ply:SetPos( ply.deathrag:GetPos() + Vector( 0, 10, 0 ) )
				ply:SetHealth( 10 )
				ply.deathrag:Remove()
				ply.deathrag = nil
			end
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