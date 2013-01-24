-- Set up the gamemode
DeriveGamemode( "sandbox" )
include("glon.lua")

-- Define global variables
CAKE = {  }
TIRA = CAKE
CAKE.Running = false
CAKE.Loaded = false

-- Server Includes
-- include( "von.lua" )

--if not(datastream) then  
--    require("datastream");  
--end  

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

resource.AddFile( "resource/fonts/YanoneKaffeesatz-Bold.ttf")
resource.AddFile( "resource/fonts/YanoneKaffeesatz-Regular.ttf")
resource.AddFile( "materials/models/null.vmt" )
resource.AddFile( "materials/models/null.vtf" )

util.AddNetworkString( "TiramisuAddToChat" )
util.AddNetworkString( "Tiramisu.ReadNote" )
util.AddNetworkString( "refreshbusiness" )
util.AddNetworkString( "refreshbusiness_false" )
util.AddNetworkString( "TiramisuChatHandling" )
util.AddNetworkString( "TiramisuAddToRadio" )
util.AddNetworkString( "TiramisuAddToOOC" )
util.AddNetworkString( "Tiramisu.OpenContainer" )
util.AddNetworkString( "Tiramisu.GetEditFaction" )
util.AddNetworkString( "Tiramisu.GetEditGroup" )
util.AddNetworkString( "Tiramisu.ReceiveFactions" )
util.AddNetworkString( "Tiramisu.EditFaction" )
util.AddNetworkString( "Tiramisu.GetFactionInfo" )
util.AddNetworkString( "Tiramisu.ReceiveGroups" )
util.AddNetworkString( "Tiramisu.ReceiveSpawnPoints" )
util.AddNetworkString( "TiramisuAddToGroupChat" )
util.AddNetworkString( "Tiramisu.EditGroup" )
util.AddNetworkString( "Tiramisu.GetGroupInfo" )
util.AddNetworkString( "Tiramisu.EditCharInfo" )
util.AddNetworkString( "Tiramisu.GetSearchResults" )
util.AddNetworkString( "Tiramisu.SendInventory" )
util.AddNetworkString( "Tiramisu.GetEditGear" ) 
util.AddNetworkString( "Tiramisu.WriteNote" )

GM.Name = "Tiramisu " .. CAKE.ConVars[ "Tiramisu" ]
CAKE.LoadSchema( CAKE.ConVars[ "Schema" ] ) -- Load the schema and plugins, this is NOT initializing.

CAKE.Loaded = true -- Tell the server that we're loaded up

local fw = file.Write
function file.Write( name, content )
	if not file.IsDir( string.GetPathFromFilename( name ) or ".", "DATA" ) then
		local dirs = string.Explode( "/", string.GetPathFromFilename( name ) )
		for k, v in pairs( dirs ) do
			if k > 1 then
				local path = dirs[1]
				for i = 2, k do
					path = path .. "/" .. dirs[i]
				end
				print( path )
				file.CreateDir( path )
			else
				file.CreateDir( v )
			end
		end
	end
	fw( name, content )
end

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
	-- timer.Create( "timesave", 120, 0, CAKE.SaveTime )
	timer.Create( "timesave", 120, 0, function() CAKE.SaveTime() end )

	--Timer to send the time to the player
	-- timer.Create( "sendtime", 1, 0, CAKE.SendTime )
	timer.Create( "sendtime", 1, 0, function() CAKE.SendTime() end )
	
	CAKE.Running = true
	
end

-- Player Initial Spawn
function GM:PlayerInitialSpawn( ply )
	
	ply.LastOOC = -100000 -- This is so people can talk for the first time without having to wait.
	
	for k, v in ipairs( CAKE.Schemafile ) do
		umsg.Start( "Tiramisu.AddSchema", ply )
			umsg.String( v )
		umsg.End( )
	end
	print( ply:Name(), "has spawned.")

	-- Set some default variables
	ply.Ready = false
	ply:SetNWBool( "chatopen", false )
	ply:SetNWBool( "specialmodel", true ) 
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

	umsg.Start("Tiramisu.EnableDeathScreen", ply) --This is to disable the death screen after the player spawns.
		umsg.Bool( false )
	umsg.End()
	
	ply:StripWeapons( )
	
	if ply:GetNWInt( "deathmode", 0 ) != 0 then
	
		ply:SetNWInt( "deathmode", 0 )
		ply:SetViewEntity( ply )
		
	end
	if( ply:GetNWBool( "ragdollmode", false ) ) then 
		ply:SetNWBool( "ragdollmode", false )
		ply:SetViewEntity( ply )
	end
	
	timer.Create( ply:SteamID() .. "savetimer", 30, 0, function()
		if IsValid( ply ) then
			CAKE.SavePlayerData( ply )
		end
	end)

	ply:RefreshInventory( )

	ply:SetNWInt( "TiramisuAdminLevel", CAKE.PlayerRank(ply) )
	ply:Give("hands")
	ply:SelectWeapon("hands")

	ply:SetNWString( "model", CAKE.GetCharField( ply, "model" ))
	
	self.BaseClass:PlayerSpawn( ply )
	GAMEMODE:SetPlayerSpeed( ply, CAKE.ConVars[ "WalkSpeed" ], CAKE.ConVars[ "RunSpeed" ] )
	
end


function GM:PlayerSetModel(ply)
	if ply:IsCharLoaded() and !(CAKE.GetCharField( "specialmodel") == "none" or CAKE.GetCharField( "specialmodel") == "") then
		local m = CAKE.GetCharField( ply, "gender" )
		ply:SetNWBool( "specialmodel", false )
		ply:SetModel( Anims[m][ "models" ][1] )
		ply:SetNWString( "gender", m )
		ply:SetMaterial("models/null")
		ply:SetColor( 255, 255, 255, 0 )
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:AddEffects( EF_NOSHADOW )
		ply:SetPersonality( CAKE.GetCharField( ply, "personality" ))
	elseif ply:IsCharLoaded() and (CAKE.GetCharField( "specialmodel") == "none" or CAKE.GetCharField( "specialmodel") == "") then
		ply:SetSpecialModel( CAKE.GetCharField( "specialmodel") )
		ply:SetNWString( "gender", "Male" )
	else
		ply:SetSpecialModel( "models/kleiner.mdl" )
	end
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
	
	umsg.Start( "showscoreboard", ply )
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