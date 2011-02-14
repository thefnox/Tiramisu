-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_init.lua
-- This file calls the rest of the script
-- As you can see, the clientside of CakeScript is pretty simple compared to the serverside.
-------------------------------

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

require( "datastream" )

-- Client Includes
include( "shared.lua" );
include( "player_shared.lua" );
include( "cl_hud.lua" );
include( "cl_binds.lua" );
include( "cl_charactercreate.lua" );
include( "cl_playermenu.lua" );
include( "animations.lua" )
include( "resourcex.lua" ) -- Resource downloading

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

usermessage.Hook( "tiramisuaddtochat", function( um )
	local string = um:ReadString()
	local font = um:ReadString()
	if aChat and aChat.AddChatLine then
		aChat.AddChatLine( "<color=135,209,255,255><font=" .. font .. ">" .. string .. "</font></color>" )
	end
end)

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
