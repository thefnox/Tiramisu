-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_charactercreate.lua
-- Houses some functions for the character creation.
-------------------------------

CAKE.CLPlugin = {}
steps = 0
step = 0

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

function ReceiveChar( data )

	local n = data:ReadLong( );
	ExistingChars[ n ] = {  }
	ExistingChars[ n ][ 'name' ] = data:ReadString( );
	ExistingChars[ n ][ 'model' ] = data:ReadString( );
	ExistingChars[ n ][ 'title' ] = data:ReadString( );
	ExistingChars[ n ][ 'title2' ] = data:ReadString( );
	
end
usermessage.Hook( "ReceiveChar", ReceiveChar );

local function CharacterCreatePanel( )

	CAKE.SetActiveTab( "Characters" )
	InitHUDMenu()
	
end
usermessage.Hook( "charactercreate", CharacterCreatePanel );


