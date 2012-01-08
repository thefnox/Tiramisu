-- Set up the gamemode
DeriveGamemode( "sandbox" )

-- Define global variables
CAKE = {  }
CAKE.Running = false
CAKE.Loaded = false

-- Server Includes
require( "glon" )
if not(datastream) then  
    require("datastream")  
end  

include( "shared.lua" ) -- Shared Functions
include( "log.lua" ) -- Logging functions
include( "configuration.lua" ) -- Configuration data
include( "player_data.lua" ) -- Player data functions
include( "player_util.lua" ) -- Player functions
include( "admin.lua" ) -- Admin functions
include( "concmd.lua" ) -- Concommands
include( "items.lua" ) --Items
include( "util.lua" ) -- Functions
include( "schema.lua" ) -- Schema system
include( "plugins.lua" ) -- Plugin system
include( "client_resources.lua" ) -- Sends files to the client
include( "sh_animations.lua" ) --Animaaaaations.
include( "sh_anim_tables.lua" ) --Animation tables

resource.AddFile( "models/tiramisu/gearhandler.mdl")
resource.AddFile( "materials/tiramisu/gearhandler.vmt")
resource.AddFile( "materials/tiramisu/gearhandler.vtf")
resource.AddFile( "resource/fonts/YanoneKaffeesatz-Bold.ttf")
resource.AddFile( "resource/fonts/YanoneKaffeesatz-Regular.ttf")

GM.Name = "Tiramisu " .. CAKE.ConVars[ "Tiramisu" ]
CAKE.LoadSchema( CAKE.ConVars[ "Schema" ] ) -- Load the schema and plugins, this is NOT initializing.

CAKE.Loaded = true -- Tell the server that we're loaded up

function GM:Initialize( ) -- Initialize the gamemode
	
	-- My reasoning for this certain order is due to the fact that plugins are meant to modify the gamemode sometimes.
	-- Plugins need to be initialized before gamemode and schema so it can modify the way that the plugins and schema actually work.
	-- AKA, hooks.
	
	CAKE.DayLog( "script.txt", "Plugins Initializing" )
	CAKE.InitPlugins( )

	CAKE.DayLog( "script.txt", "Schemas Initializing" )
	CAKE.InitSchemas( )
	
	CAKE.DayLog( "script.txt", "Gamemode Initializing" )
	
	--Timer to save the current gamemode time
	timer.Create( "timesave", 120, 0, CAKE.SaveTime )

	--Timer to send the time to the player
	timer.Create( "sendtime", 1, 0, CAKE.SendTime )
	
	CAKE.Running = true
	
end

-- Player Initial Spawn
function GM:PlayerInitialSpawn( ply )
	
	ply.LastOOC = -100000 -- This is so people can talk for the first time without having to wait.
	
	for k, v in ipairs( CAKE.Schemafile ) do
		umsg.Start( "Tiramisu.AddSchema", ply )
			
			print(v)
			umsg.String( v )
			
		umsg.End( )
	end

	for k, v in pairs( CAKE.CurrencyData ) do
		umsg.Start( "Tiramisu.AddCurrency", ply )
			umsg.String( v.Name )
			umsg.String( v.Slang )
			umsg.String( v.Abr )
		umsg.End()
	end

	-- Set some default variables
	ply.Ready = false
	ply:SetNWBool( "chatopen", false )
	ply:SetModel( "models/kleiner.mdl" )

	-- Load their data, or create a new datafile for them.
	CAKE.LoadPlayerDataFile( ply )
	
	self.BaseClass:PlayerInitialSpawn( ply )

end

function GM:PlayerLoadout(ply)
end

function GM:PlayerSpawn( ply )

	if( !ply:IsCharLoaded() ) then
		return -- Player data isn't loaded. This is an initial spawn.
	end
	
	CAKE.SavePlayerData( ply )
	
	umsg.Start( "Tiramisu.ReceiveRagdoll", ply )
		umsg.Short( nil )
	umsg.End()--This is to reset the player's view back to their character after they die.

	umsg.Start("Tiramisu.EnableBlackScreen", ply) --This is to disable the black screen after the player spawns.
		umsg.Bool( false )
	umsg.End()
	
	ply:StripWeapons( )
	
	if( ply:GetNWInt( "deathmode" ) == 1 ) then
	
		ply:SetNWInt( "deathmode", 0 )
		ply:SetViewEntity( ply )
		
	end
	if( ply:GetNWBool( "ragdollmode", false ) ) then 
		ply:SetNWBool( "ragdollmode", false )
		ply:SetViewEntity( ply )
	end
	
	timer.Create( ply:SteamID() .. "savetimer", 30, 0, function()
		if ValidEntity( ply ) then
			CAKE.SavePlayerData( ply )
		end
	end)

	timer.Simple( .5, function()
		ply:RefreshInventory( )
	end)

	ply:SetNWInt( "TiramisuAdminLevel", CAKE.PlayerRank(ply) )
	ply:Give("hands")
	ply:SelectWeapon("hands")
	
	self.BaseClass:PlayerSpawn( ply )
	GAMEMODE:SetPlayerSpeed( ply, CAKE.ConVars[ "WalkSpeed" ], CAKE.ConVars[ "RunSpeed" ] )
	
end


function GM:PlayerSetModel(ply)
end

function GM:PlayerDisconnected( ply )
	CAKE.SavePlayerData( ply )
end


function GM:PlayerSpawnSWEP( ply, class )

	if( CAKE.PlayerRank( ply ) > 0 ) then return true end
	return false
	
end

function GM:PlayerGiveSWEP( ply )

	if( CAKE.PlayerRank( ply ) > 0 ) then return true end
	return false 
	
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

-- NO SENT FOR YOU. Unless you're an admin
function GM:PlayerSpawnSENT( ply, class )
	
	if( CAKE.PlayerRank( ply ) > 0 ) then return true end
	return false
	
end

--Useless for RP, so we disable gravity gun punting
function GM:GravGunPunt( ply, ent )
	return false
end

--Even more useless for RP are sprays.
function GM:PlayerSpray(ply)
	return true
end