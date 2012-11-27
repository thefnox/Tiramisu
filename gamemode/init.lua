-- Set up the gamemode
DeriveGamemode( "sandbox" )

-- Define global variables
TIRA = {  } //As of Tiramisu 3, we're setting the namespace for all our globals to TIRA.
CAKE = TIRA //Luckily, we can just make the TIRA table point to TIRA, so there's no need to change anything in your code.
TIRA.Running = false
TIRA.Loaded = false

-- Server Includes

function TIRA.Serialize(tbl)
	return util.TableToJSON(tbl)
end

function ValidEntity(ent)
	if ent then
		if ent.IsValid then return ent:IsValid() end
	end
	return false
end

function TIRA.Deserialize(str)
	return util.JSONToTable(string.gsub(str, "\\", ""))
end

include( "shared.lua" ) -- Shared Functions
include( "log.lua" ) -- Logging functions
include( "configuration.lua" ) -- Configuration data
include( "mysql.lua" ) --MySQL
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

GM.Name = "Tiramisu " .. TIRA.ConVars[ "Tiramisu" ]
TIRA.LoadSchema( TIRA.ConVars[ "Schema" ] ) -- Load the schema and plugins, this is NOT initializing.

TIRA.Loaded = true -- Tell the server that we're loaded up

function GM:Initialize( ) -- Initialize the gamemode
	
	-- My reasoning for this certain order is due to the fact that plugins are meant to modify the gamemode sometimes.
	-- Plugins need to be initialized before gamemode and schema so it can modify the way that the plugins and schema actually work.
	-- AKA, hooks.

	TIRA.DayLog( "script.txt", "Plugins Initializing" )
	TIRA.InitPlugins( )

	TIRA.DayLog( "script.txt", "Schemas Initializing" )
	TIRA.InitSchemas( )

	TIRA.DayLog( "script.txt", "SQL Database Initializing" )
	TIRA.InitializeSQLDatabase()
	
	TIRA.DayLog( "script.txt", "Gamemode Initializing" )
	
	--Timer to save the current gamemode time
	timer.Create( "timesave", 120, 0, TIRA.SaveTime )

	--Timer to send the time to the player
	timer.Create( "sendtime", 1, 0, TIRA.SendTime )
	
	TIRA.Running = true
	
end

local runonce = false

-- Player Initial Spawn
function GM:PlayerInitialSpawn( ply )

	if(!runonce) then 
		runonce = true
		TIRA.ConnectToDatabase()
	end
	
	ply.LastOOC = -100000 -- This is so people can talk for the first time without having to wait.
	
	for k, v in ipairs( TIRA.Schemafile ) do
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
	TIRA.LoadPlayerDataFile( ply )
	
	self.BaseClass:PlayerInitialSpawn( ply )

end

function GM:PlayerLoadout(ply)
end

function GM:PlayerSpawn( ply )

	if( !ply:IsCharLoaded() ) then
		return -- Player data isn't loaded. This is an initial spawn.
	end
	
	TIRA.SavePlayerData( ply )
	
	umsg.Start( "Tiramisu.ReceiveRagdoll", ply )
		umsg.Short( nil )
	umsg.End()--This is to reset the player's view back to their character after they die.

	umsg.Start("Tiramisu.EnableBlackScreen", ply) --This is to disable the black screen after the player spawns.
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
		if ValidEntity( ply ) then
			TIRA.SavePlayerData( ply )
		end
	end)

	ply:RefreshInventory( )

	ply:SetNWInt( "TiramisuAdminLevel", TIRA.PlayerRank(ply) )
	ply:Give("hands")
	ply:SelectWeapon("hands")

	ply:SetNWString( "model", TIRA.GetCharField( ply, "model" ))
	
	self.BaseClass:PlayerSpawn( ply )
	GAMEMODE:SetPlayerSpeed( ply, TIRA.ConVars[ "WalkSpeed" ], TIRA.ConVars[ "RunSpeed" ] )
	
end


function GM:PlayerSetModel(ply)
	if ply:IsCharLoaded() and (TIRA.GetCharField(ply, "specialmodel") == "none" or TIRA.GetCharField(ply, "specialmodel") == "") then
		local m = TIRA.GetCharField( ply, "gender" )
		ply:SetNWBool( "specialmodel", false )
		ply:SetModel( Anims[m][ "models" ][1] )
		ply:SetNWString( "gender", m )
		ply:SetMaterial("models/null")
		ply:AddEffects( EF_NOSHADOW )
		ply:SetPersonality( TIRA.GetCharField( ply, "personality" ))
	elseif ply:IsCharLoaded() and !(TIRA.GetCharField(ply, "specialmodel") == "none" or TIRA.GetCharField(ply, "specialmodel") == "") then
		ply:SetSpecialModel( TIRA.GetCharField(ply, "specialmodel") )
		ply:SetNWString( "gender", "Male" )
	else
		ply:SetSpecialModel( "models/kleiner.mdl" )
	end
end

function GM:PlayerDisconnected( ply )
	TIRA.SavePlayerData( ply )
end


function GM:PlayerSpawnSWEP( ply, class )

	if( TIRA.PlayerRank( ply ) > 0 ) then return true end
	return false
	
end

function GM:PlayerGiveSWEP( ply )

	if( TIRA.PlayerRank( ply ) > 0 ) then return true end
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
	
	if( TIRA.PlayerRank( ply ) > 0 ) then return true end
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