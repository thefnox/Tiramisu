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
include( "configuration.lua" ); -- Configuration data
include( "player_data.lua" ); -- Player data functions
include( "player_shared.lua" ); -- Shared player functions
include( "player_util.lua" ); -- Player functions
include( "admin.lua" ); -- Admin functions
include( "chat.lua" ); -- Chat Commands
include( "concmd.lua" ); -- Concommands
include( "util.lua" ); -- Functions
include( "charactercreate.lua" ); -- Character Creation functions
include( "items.lua" ); -- Items system
include( "schema.lua" ); -- Schema system
include( "plugins.lua" ); -- Plugin system
include( "client_resources.lua" ); -- Sends files to the client
include( "animations.lua" ); -- Animations
include( "doors.lua" ); -- Doors
include( "resourcex.lua" ) -- Resource downloading
include( "sn3_base_sv.lua" )

resource.AddFile( "models/Tiramisu/AnimationTrees/alyxanimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/combineanimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/maleanimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/playeranimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/femaleanimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/policeanimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/barneyanimtree.mdl" )
resource.AddFile( "materials/tiramisu/tabbutton.vmt" )
resource.AddFile( "resource/fonts/Harabara.ttf")

CAKE.LoadSchema( CAKE.ConVars[ "Schema" ] ); -- Load the schema and plugins, this is NOT initializing.

CAKE.Loaded = true; -- Tell the server that we're loaded up

function GM:Initialize( ) -- Initialize the gamemode
	
	-- My reasoning for this certain order is due to the fact that plugins are meant to modify the gamemode sometimes.
	-- Plugins need to be initialized before gamemode and schema so it can modify the way that the plugins and schema actually work.
	-- AKA, hooks.
	
	CAKE.DayLog( "script.txt", "Plugins Initializing" );
	CAKE.InitPlugins( );
	
	CAKE.DayLog( "script.txt", "Loading all groups")
	CAKE.LoadAllGroups()

	CAKE.DayLog( "script.txt", "Schemas Initializing" );
	CAKE.InitSchemas( );
	
	CAKE.DayLog( "script.txt", "Gamemode Initializing" );
	
	game.ConsoleCommand( "exec cakevars.cfg\n" ) -- Put any configuration variables in cfg/cakevars.cfg, set it using rp_admin setconvar varname value
	
	CAKE.InitSpawns()
	CAKE.InitStashes()
	CAKE.InitTime()
	
	timer.Create( "timesave", 120, 0, CAKE.SaveTime );
	timer.Create( "sendtime", 1, 0, CAKE.SendTime );
	
	CAKE.Running = true;
	
end

-- Player Initial Spawn
function GM:PlayerInitialSpawn( ply )
	
	ply.LastOOC = -100000; -- This is so people can talk for the first time without having to wait.

	CAKE.SpawnPointHandle(ply)
	
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
	ply:SetNWBool( "chatopen", false );
	ply:SetModel( "models/kleiner.mdl" )
	ply:ChangeMaxHealth(CAKE.ConVars[ "DefaultHealth" ]);
	ply:ChangeMaxArmor(0);
	ply:ChangeMaxWalkSpeed(CAKE.ConVars[ "WalkSpeed" ]);
	ply:ChangeMaxRunSpeed(CAKE.ConVars[ "RunSpeed" ]);
	
	-- Load their data, or create a new datafile for them.
	CAKE.LoadPlayerDataFile( ply );
	
	self.BaseClass:PlayerInitialSpawn( ply )

end

function GM:PlayerLoadout(ply)

	if(ply:GetNWInt("charactercreate") != 1) then

		ply:Give("hands");
		
		ply:SelectWeapon("hands");
		
	end
	
end

function GM:PlayerSpawn( ply )

	umsg.Start( "TiramisuInitChat", ply )
	umsg.End()

	if( !ply:IsCharLoaded() ) then
		return; -- Player data isn't loaded. This is an initial spawn.
	end

	if !ply.BonemergeGearEntity or ply.BonemergeGearEntity:GetParent() != ply then
		ply.BonemergeGearEntity = ents.Create( "prop_physics" )
		ply.BonemergeGearEntity:SetPos( ply:GetPos() + Vector( 0, 0, 80 ) )
		ply.BonemergeGearEntity:SetAngles( ply:GetAngles() )
		ply.BonemergeGearEntity:SetModel("models/Tiramisu/Tools/blank_model.mdl")
		ply.BonemergeGearEntity:SetParent( ply )
		ply.BonemergeGearEntity:SetSolid( SOLID_NONE )
		ply.BonemergeGearEntity:Spawn()
	end
	
	CAKE.SpawnPointHandle(ply)
	
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
		if ValidEntity( ply ) then
			CAKE.SavePlayerData( ply )
		end
	end)
	
	-- Reset all the variables
	ply:ChangeMaxHealth(CAKE.ConVars[ "DefaultHealth" ] - ply:MaxHealth());
	ply:ChangeMaxArmor(0 - ply:MaxArmor());
	ply:ChangeMaxWalkSpeed(CAKE.ConVars[ "WalkSpeed" ] - ply:MaxWalkSpeed());
	ply:ChangeMaxRunSpeed(CAKE.ConVars[ "RunSpeed" ] - ply:MaxRunSpeed());
	ply:SetAiming( false )
	
	self.BaseClass:PlayerSpawn( ply )
	GAMEMODE:SetPlayerSpeed( ply, CAKE.ConVars[ "WalkSpeed" ], CAKE.ConVars[ "RunSpeed" ] );
	
	
end


function GM:PlayerSetModel(ply)
	if !ply:GetNWBool( "specialmodel", false ) then
		if(ply:IsCharLoaded()) then
				local m = ""
				if( CAKE.GetCharField( ply, "gender" ) == "Female" ) then
					m = "models/Tiramisu/AnimationTrees/femaleanimtree.mdl"
					ply:SetNWString( "gender", "Female" )
				else
					m = "models/Tiramisu/AnimationTrees/maleanimtree.mdl"
					ply:SetNWString( "gender", "Male" )
				end
				
				ply:SetModel( m );
		else
			ply:SetModel("models/kleiner.mdl");
		end
	end

end

function GM:PlayerDisconnected( ply )
	CAKE.SavePlayerData( ply )
end


function GM:PlayerDeath(ply)
	
	CAKE.StandUp( ply )
	CAKE.DeathMode(ply);

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