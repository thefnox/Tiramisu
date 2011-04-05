-- Set up the gamemode
DeriveGamemode( "sandbox" );
GM.Name = "Tiramisu";

-- Define global variables
CAKE = {  };
CAKE.Running = false;
CAKE.Loaded = false;

-- Server Includes
require( "glon" )
if not(datastream) then  
    require("datastream");  
end  

include( "shared.lua" ); -- Shared Functions
include( "log.lua" ); -- Logging functions
include( "configuration.lua" ); -- Configuration data
include( "player_data.lua" ); -- Player data functions
include( "player_util.lua" ); -- Player functions
include( "admin.lua" ); -- Admin functions
include( "concmd.lua" ); -- Concommands
include( "items.lua" )
include( "util.lua" ); -- Functions
include( "schema.lua" ); -- Schema system
include( "plugins.lua" ); -- Plugin system
include( "client_resources.lua" ); -- Sends files to the client
include( "animations.lua")

resource.AddFile( "models/Tiramisu/AnimationTrees/alyxanimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/combineanimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/maleanimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/playeranimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/femaleanimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/policeanimtree.mdl" )
resource.AddFile( "models/Tiramisu/AnimationTrees/barneyanimtree.mdl" )
resource.AddFile( "models/Tiramisu/blank_model.mdl")
resource.AddFile( "materials/tiramisu/invisible.vmt")
resource.AddFile( "materials/tiramisu/invisible.vtf")
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

	CAKE.DayLog( "script.txt", "Schemas Initializing" );
	CAKE.InitSchemas( );
	
	CAKE.DayLog( "script.txt", "Gamemode Initializing" );
	
	--Timer to save the current gamemode time
	timer.Create( "timesave", 120, 0, CAKE.SaveTime );

	--Timer to send the time to the player
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
	
	for k, v in ipairs( CAKE.Schemafile ) do
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

	if( !ply:IsCharLoaded() ) then
		return; -- Player data isn't loaded. This is an initial spawn.
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
		if ValidEntity( ply ) then
			CAKE.SavePlayerData( ply )
		end
	end)

	timer.Simple( 1, function()
		ply:RefreshInventory( )
		ply:RefreshBusiness( )
	end)
	
	self.BaseClass:PlayerSpawn( ply )
	GAMEMODE:SetPlayerSpeed( ply, CAKE.ConVars[ "WalkSpeed" ], CAKE.ConVars[ "RunSpeed" ] );
	
end


function GM:PlayerSetModel(ply)
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
			ply:SetNWInt("deathmoderemaining", 0);
			
		end
		
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	-- We don't want kills, deaths, nor ragdolls being made. Kthx.
	
end

function GM:PlayerSpawnSWEP( ply, class )

	if( CAKE.PlayerRank( ply ) > 0 ) then return true; end
	return false;
	
end

function GM:PlayerGiveSWEP( ply )

	if( CAKE.PlayerRank( ply ) > 0 ) then return true; end
	return false; 
	
end

-- This is the help menu
function GM:ShowHelp( ply )
	
	umsg.Start( "showhelpmenu", ply )
	umsg.End()

end

function GM:ShowTeam( ply )

	umsg.Start( "toggleinventory", ply )
	umsg.End()

end

function GM:ShowSpare1( ply )

	ply:SetAiming( !ply:GetAiming() )

end

function GM:ShowSpare2( ply )

	umsg.Start( "togglethirdperson", ply )
	umsg.End()

end

-- NO SENT FOR YOU.
function GM:PlayerSpawnSENT( ply, class )
	
	if( CAKE.PlayerRank( ply ) > 0 ) then return true; end
	return false;
	
end

-- Disallows suicide
function GM:CanPlayerSuicide( ply )

	if( !CAKE.ConVars[ "SuicideEnabled" ] ) then
	
		ply:ChatPrint( "Suicide is disabled!" )
		return false
		
	end
	
	return true;
	
end