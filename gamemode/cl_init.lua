-- Set up the gamemode
DeriveGamemode( "sandbox" );
GM.Name = "Tiramisu";

-- Define global variables
CAKE = {  };
CAKE.Running = false;
CAKE.Loaded = false;
CAKE.Skin = "default"
CAKE.CharCreate = function() end
CAKE.MenuFont = "Harabara"
CAKE.BaseColor = Color( 100, 100, 115, 150 ) --The schema's default frame color

CAKE.ViewRagdoll = false

CAKE.Clothing = "none"
CAKE.Helmet = "none"
CAKE.Gear = {}
CAKE.ClothingTbl = {}

CAKE.MyGroup = {}

CAKE.models = {  };
readysent = false;

CAKE.MenuTabs = {}
CAKE.ActiveTab = nil
CAKE.MenuOpen = false
CAKE.DisplayMenu = false

require( "datastream" )
-- Client Includes
include( "animations.lua" )
include( "shared.lua" )
include( "cl_binds.lua" );

CAKE.Loaded = true;

-- Initialize the gamemode
function GM:Initialize( )

	CAKE.Running = true;

	self.BaseClass:Initialize( );

end

function GM:Think( )

	if( vgui and readysent == false ) then -- VGUI is initalized, tell the server we're ready for character creation.
	
		LocalPlayer( ):ConCommand( "rp_ready\n" );
		readysent = true;
		
	end
	
end

function GM:ForceDermaSkin()

	return CAKE.Skin
	
end

function GM:StartChat()
        return true -- That's what the chatbox is there for.
end

function GM:FinishChat()
end

function GM:ChatTextChanged()
end

usermessage.Hook( "runconcommand", function( um ) --Simple fix to garry's fuckup.
	
	local cmd = um:ReadString()
	local exp = string.Explode( " ", cmd )
	cmd = exp[1]
	local args = ""
	table.remove( exp, 1 )
	if #exp > 1 then
		args = table.concat( exp, " " )
	else
		args = exp[1] or ""
	end
	
	RunConsoleCommand( cmd, args )
	
end)

CurrencyTable = {}

usermessage.Hook( "addcurrency", function( um )
	local currencydata = {}
	currencydata.name = um:ReadString()
	currencydata.slang = um:ReadString()
	currencydata.abr   = um:ReadString()
	CurrencyTable = currencydata
end)

Schemas = {}

usermessage.Hook("addschema", function(data)
	local schema = data:ReadString()
	AddRclicks(schema)
        AddPlugins(schema)
	AddCLPlugins(schema)
end )

RclickTable = {}

function AddRclicks(schema)
	local list = file.FindInLua( "tiramisu/gamemode/schemas/" .. schema .. "/rclick/*.lua" )	
	for k,v in pairs( list ) do
		local path = "tiramisu/gamemode/schemas/" .. schema .. "/rclick/" .. v
		RCLICK = { }
		include( path )
		table.insert(RclickTable, RCLICK);
	end
end

function AddPlugins( schema, filename )
        filename = filename or ""
        local path = "gamemodes/tiramisu/gamemode/schemas/" .. schema .. "/plugins/" .. filename .. "/"
        local list = file.Find( path .. "/*", true ) or {}

        for k, v in pairs( list ) do
                if string.GetExtensionFromFilename( v ) and string.GetExtensionFromFilename( v ) == "lua" then
                        --It's a lua file! So it's time to include it according to what it actually is.
                        if v:sub( 1, 3 ) == "cl_" or v:sub( 1, 3 ) == "sh_" then
                                PLUGIN = {} -- Support for shared plugins. 
                                CLPLUGIN = { }
                                include( "tiramisu/gamemode/schemas/" .. schema .. "/plugins/" .. filename .. "/" .. v )
                                CAKE.CLPlugin[CLPLUGIN.Name or path .. "/" .. v ] = {}
                                if CLPLUGIN.Init then
                                        CAKE.CLPlugin[CLPLUGIN.Name].Init = CLPLUGIN.Init
                                        CAKE.CLPlugin[CLPLUGIN.Name].Init()
                                end
                        end
                else --It's a directory
                        AddPlugins( schema, v ) -- So we recursively make it add all it's files
                end
        end
end

CAKE.CLPlugin = {}

function AddCLPlugins(schema)

		local list = file.FindInLua( "tiramisu/gamemode/schemas/" .. schema .. "/clplugin/*.lua" )	
		for k,v in pairs( list ) do
			local path = "tiramisu/gamemode/schemas/" .. schema .. "/clplugin/" .. v
			CLPLUGIN = { }
			include( path )
			CAKE.CLPlugin[CLPLUGIN.Name] = {}
			if CLPLUGIN.Init then
				CAKE.CLPlugin[CLPLUGIN.Name].Init = CLPLUGIN.Init
				CAKE.CLPlugin[CLPLUGIN.Name].Init()
			end
		end
end

function CAKE.RegisterCharCreate( passedfunc )

	CAKE.CharCreate = passedfunc

end

TeamTable = {};


ExistingChars = {  }

local function ReceiveChar( data )

	local n = data:ReadLong( );
	ExistingChars[ n ] = {  }
	ExistingChars[ n ][ 'name' ] = data:ReadString( );
	ExistingChars[ n ][ 'model' ] = data:ReadString( );
	ExistingChars[ n ][ 'title' ] = data:ReadString( );
	
end
usermessage.Hook( "ReceiveChar", ReceiveChar );

usermessage.Hook( "characterselection",  function( )

	CAKE.SetActiveTab( "Characters" )
	InitHiddenButton()
	
end );

usermessage.Hook( "charactercreation", function()
	
	CAKE.CharCreate()

end)

usermessage.Hook( "senderror", function( um )
	
	local text = um:ReadString()
	CAKE.Message( text, "Message", "OK" )

end)

function CAKE.RegisterMenuTab( name, func, closefunc ) --The third argument is the function used for closing your panel.
	CAKE.MenuTabs[ name ] = {}
	CAKE.MenuTabs[ name ][ "function" ] = func or function() end
	CAKE.MenuTabs[ name ][ "closefunc" ] = closefunc or function() end
end

function CAKE.CloseTabs()
	for k, v in pairs( CAKE.MenuTabs ) do
		v[ "closefunc" ]()
	end
	CAKE.ActiveTab = nil
end

function CAKE.SetActiveTab( name )
	--CAKE.MenuOpen = true
	CAKE.CloseTabs()
	if CAKE.MenuTabs and CAKE.MenuTabs[ name ] then
		CAKE.MenuTabs[ name ][ "function" ]()
	else
		timer.Simple( 1, function()
			if CAKE.MenuTabs and CAKE.MenuTabs[ name ] then
				CAKE.MenuTabs[ name ][ "function" ]()
			end
		end)
	end
	CAKE.ActiveTab = name
end