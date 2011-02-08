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

usermessage.Hook( "ConfirmCharRemoval", function( um )

	local namestr = um:ReadString()
	local agestr = tostring( um:ReadShort() )
	local titlestr = um:ReadString()
	local title2str = um:ReadString()
	local modelstr = um:ReadString()
	local id = um:ReadLong()

	local frame = vgui.Create( "DFrameTransparent" )
	frame:SetSize( 250, 228 )
	frame:SetTitle( "Confirm Removal" )
	frame:Center()
	frame:ShowCloseButton( false )
	frame:MakePopup()

	local panel = vgui.Create( "DPanel", frame )
	panel:SetSize( 240, 195 )
	panel:SetPos( 5, 28 )

	local confirmbutton = vgui.Create( "DButton", panel )
	confirmbutton:SetSize( 100, 30 )
	confirmbutton:SetText( "Confirm Delete" )
	confirmbutton.DoClick = function()
		LocalPlayer():ConCommand("rp_removechar " .. id);
		ExistingChars[id] = nil
		CAKE.SetActiveTab( "Characters" )
		frame:Remove()
		frame = nil
	end
	confirmbutton:SetPos( 130, 160 )

	local gobackbutton = vgui.Create( "DButton", panel )
	gobackbutton:SetSize( 100, 30 )
	gobackbutton:SetText( "Cancel" )
	gobackbutton.DoClick = function()
		CAKE.SetActiveTab( "Characters" )
		frame:Remove()
		frame = nil
	end
	gobackbutton:SetPos( 15, 160 )

	local model = vgui.Create( "DModelPanel", panel )
	model:SetSize( 120, 120 )
	model:SetModel( modelstr )
	model:SetPos( 110, 20 )

	local name = vgui.Create( "DLabel", panel )
	name:SetSize( 100, 20 )
	name:SetPos( 10, 10 )
	name:SetText( namestr )

	local age = vgui.Create( "DLabel", panel )
	age:SetSize( 100, 20 )
	age:SetPos( 10, 40 )
	age:SetText( "Age: " .. agestr )

	local title = vgui.Create( "DLabel", panel )
	title:SetSize( 100, 20 )
	title:SetPos( 10, 70 )
	title:SetText( titlestr )

	local title2 = vgui.Create( "DLabel", panel )
	title2:SetSize( 100, 20 )
	title2:SetPos( 10, 100 )
	title2:SetText( title2str )

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
	AddCharCreates(schema)
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
