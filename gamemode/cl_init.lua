-- Set up the gamemode
DeriveGamemode( "sandbox" );

--Initializing global variables. Don't touch this
CAKE = {  };
CAKE.Running = false;
CAKE.Loaded = false;
CAKE.Skin = "default"
CAKE.CharCreate = function() end
CAKE.Clothing = "none"
CAKE.Helmet = "none"
CAKE.Gear = {}
CAKE.ClothingTbl = {}
CAKE.MyGroup = {}
readysent = false;
CAKE.MenuTabs = {}
CAKE.ActiveTab = nil
CAKE.MenuOpen = false
CAKE.DisplayMenu = false
CAKE.ViewRagdoll = false
CAKE.FreeScroll = false
CAKE.ForceFreeScroll = false

--Schema configuration options

CAKE.MenuFont = "Harabara" -- The default font for the whole schema
CAKE.BaseColor = Color( 100, 100, 115, 150 ) --The schema's default color. Can be set in game
CAKE.Webpage = "http://www.facepunch.com/" --Set this to whatever you want to, it'll be accessible on the "Forums" tab
CAKE.Thirdperson = CreateClientConVar( "rp_thirdperson", 0, true, true ) -- Set this to 1 to have thirdperson enabled by default.
CAKE.ThirdpersonDistance = CreateClientConVar( "rp_thirdpersondistance", 50, true, true ) --Maximum thirdperson distance
CAKE.Headbob = CreateClientConVar( "rp_headbob", 1, true, true ) --Set this to 0 to have headbob disabled by default.
CAKE.UseIntro = true --Set this to false if you want the player to go directly into the character menu when they join
CAKE.IntroText = "Welcome to Tiramisu" -- Character menu and intro text
CAKE.IntroSubtitle = "A ROLEPLAY REVOLUTION" -- Character menu and intro subtitle. If you want this gone just set it to ""
CAKE.ChatFont = "ChatFont" -- Main font used in chatting

surface.CreateFont(CAKE.MenuFont, 32, 500, true, false, "TiramisuTitlesFont", false, true) -- Biggest font used. Used in 3D titles and main character title.
surface.CreateFont(CAKE.MenuFont, 18, 500, true, false, "TiramisuTimeFont", true, false ) -- Second biggest used. 
surface.CreateFont(CAKE.MenuFont, 14, 500, true, false, "TiramisuSubtitlesFont", false, true) -- A moderate size font used for the main title's subtitle
surface.CreateFont(CAKE.MenuFont, 12, 400, true, false, "TiramisuTabsFont", true ) -- Smallest, used in tabs and the quick menu
surface.CreateFont("DefaultSmallDropShadow", ScreenScale(5), 500, true, false, "TiramisuWhisperFont", true ) -- Used only for whispering
surface.CreateFont("Trebuchet18", ScreenScale(10), 700, true, false, "TiramisuYellFont", true ) -- Used only for yelling


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
end )

RclickTable = {}

function AddRclicks(schema)
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua" )	
	for k,v in pairs( list ) do
		local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/" .. v
		RCLICK = { }
		include( path )
		table.insert(RclickTable, RCLICK);
	end
end

CAKE.CLPlugin = {}

function AddPlugins( schema, filename )

	local tbl = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/*" ) 
	local list = {}

	for _, folder in pairs( tbl ) do
	    if folder != "." and folder != ".." then
	        for k, v in pairs( file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/" .. folder .. "/*.lua" )) do
                if v:sub( 1, 3 ) == "cl_" or v:sub( 1, 3 ) == "sh_" then
                   PLUGIN = {} -- Support for shared plugins. 
                   CLPLUGIN = { }
                   include( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/" .. folder .. "/" .. v )
                   CLPLUGIN.Name = CLPLUGIN.Name or CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/" .. folder .. "/" .. v 
                   CAKE.CLPlugin[CLPLUGIN.Name] = {}
                   if CLPLUGIN and CLPLUGIN.Init then
                       	CAKE.CLPlugin[CLPLUGIN.Name].Init = CLPLUGIN.Init or function() end
                      	CAKE.CLPlugin[CLPLUGIN.Name].Init()
                   end
               end
	        end
	    end    
	end
end

function CAKE.RegisterCharCreate( passedfunc )

	CAKE.CharCreate = passedfunc

end

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