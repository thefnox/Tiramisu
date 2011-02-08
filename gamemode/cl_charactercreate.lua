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

function AddCharCreates(schema)

		local list = file.FindInLua( "tiramisu/gamemode/schemas/" .. schema .. "/clplugin/*.lua" )	
		for k,v in pairs( list ) do
			local path = "tiramisu/gamemode/schemas/" .. schema .. "/clplugin/" .. v
			CLPLUGIN = { }
			include( path )
			CAKE.CLPlugin[CLPLUGIN.Name] = {}
			CAKE.CLPlugin[CLPLUGIN.Name].Init = CLPLUGIN.Init
			CAKE.CLPlugin[CLPLUGIN.Name].Init()
		end
end

function CAKE.AddStep( passedfunc )

	if !CAKE.Steps then
		CAKE.Steps = {}
	end
	
	CAKE.Steps[#CAKE.Steps+1] = passedfunc

end

local step = 1
function CAKE.NextStep()
	CAKE.Steps[step]()
	step = step + 1
end

function CAKE.ResetStep()
	step = 1
end

TeamTable = {};


ExistingChars = {  }

function ReceiveChar( data )

	local n = data:ReadLong( );
	ExistingChars[ n ] = {  }
	ExistingChars[ n ][ 'name' ] = data:ReadString( );
	ExistingChars[ n ][ 'model' ] = data:ReadString( );
	
end
usermessage.Hook( "ReceiveChar", ReceiveChar );

local function CharacterCreatePanel( )

	CAKE.SetActiveTab( "Characters" )
	InitHUDMenu()
	CAKE.CreateRadioMenu()
	
end
usermessage.Hook( "charactercreate", CharacterCreatePanel );


