PLUGIN.Name = "Notes"; -- What is the plugin name
PLUGIN.Author = "FNox"; -- Author of the plugin
PLUGIN.Description = "Handles note writting/spawning/saving/loading"; -- The description or purpose of the plugin

CAKE.NoteModels = {


}

CAKE.Notes = {}

function CAKE.SaveNote( ply, title, note, model )
	
	local salt = ply:SteamID() .. CAKE.GetCharField( ply, "name") .. tostring( CurTime() ) .. tostring( FrameTime() ) -- That's random alright.
	local model = model or ""
	local uniqueid = util.CRC( title .. salt )
	local tbl = {
		["author"] = ply:Nick() .. " (" .. ply.Name .. ")",
		["model"] = model,
		["title"] = title,
		["note"] = note
	}
	note = glon.encode( tbl )
	
	file.Write( CAKE.Name .. "/Notes/" .. uniqueid .. ".txt", note )
	CAKE.Notes[ uniqueid ] = note

end

function CAKE.LoadNote( uniqueid )

	if CAKE.Notes[ uniqueid ] then
		return CAKE.Notes[ uniqueid ]
	elseif file.Exists( CAKE.Name .. "/Notes/" .. uniqueid .. ".txt" ) then
		CAKE.Notes[ uniqueid ] = glon.decode( file.Read( CAKE.Name .. "/Notes/" .. uniqueid .. ".txt" ) )
		return CAKE.Notes[ uniqueid ]
	end
	return false
	
end

local function ccLoadNote( ply, cmd, args )
	
	local note = CAKE.LoadNote( args[1] or "" )
	
	if note then
		datastream.StreamToClients( ply, "LoadNote", note )
	else
		CAKE.SendConsole( ply, "No such note ID!" )
	end
	
end
concommand.Add( "rp_loadnote", ccLoadNote )

local function ccDropNote( ply, cmd, args )
	
end
concommand.Add( "rp_dropnote", ccDropNote )

local function IncomingNote( ply, handler, id, encoded, decoded )
	
	local title = decoded.title
	local note = decoded.note
	local model = decoded.model
	
	CAKE.SaveNote( ply, title, note, model )
	
end
datastream.Hook( "IncomingNote", IncomingNote )

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "notes", {} )
	
end