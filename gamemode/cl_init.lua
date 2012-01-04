-- Set up the gamemode
CAKE = {  }
DeriveGamemode( "sandbox" )
require( "datastream" )

--Load up the configuration file
include( "configuration.lua" )

--Initializing global variables. Don't touch this
CAKE.ItemData = {}
CAKE.Running = false
CAKE.Loaded = false
CAKE.Skin = "Tiramisu"
CAKE.CharCreate = function() end
CAKE.Clothing = "none"
CAKE.Helmet = "none"
CAKE.Gear = {}
CAKE.ClothingTbl = {}
CAKE.MyGroup = {}
readysent = false
CAKE.MenuTabs = {}
CAKE.ActiveTab = nil
CAKE.MenuOpen = false
CAKE.DisplayMenu = false
CAKE.ViewRagdoll = false
CAKE.FreeScroll = false
CAKE.ForceFreeScroll = false
CAKE.Notifications = {}
CAKE.ActiveNotifications = {}

--Schema configuration options

CAKE.Thirdperson = CreateClientConVar( "rp_thirdperson", 0, true, true ) -- Set this to 1 to have thirdperson enabled by default.
CAKE.ThirdpersonDistance = CreateClientConVar( "rp_thirdpersondistance", 50, true, true ) --Maximum thirdperson distance
CAKE.CameraSmoothFactor = CreateClientConVar( "rp_camerasmooth", 12, true, true ) --Camera smoothing factor, affects speed.
CAKE.FirstpersonBody = CreateClientConVar( "rp_firstpersonbody", 0, true, true ) --The return of first person legs!
CAKE.StayCrouched = CreateClientConVar( "rp_crouchtoggle", 0, true, true ) -- Enables crouch toggle.
CAKE.TitleDrawDistance = CreateClientConVar( "rp_titledrawdistance", 600, true, true ) --Maximum distance a player can be to have his or her title drawn
CAKE.MinimalHUD = CreateClientConVar( "rp_minimalhud", 0, true, true ) --Disables HUD elements for a more clear view.
CAKE.Headbob = CreateClientConVar( "rp_headbob", 1, true, true ) --Set this to 0 to have headbob disabled by default.

surface.CreateFont(CAKE.MenuFont2, 48, 500, true, false, "Tiramisu48Font", false, true) -- Biggest font used.
surface.CreateFont(CAKE.MenuFont2, 32, 500, true, false, "Tiramisu32Font", false, true) -- Second biggest font used. Used in 3D titles and main character title.
surface.CreateFont(CAKE.MenuFont2, 24, 500, true, false, "Tiramisu24Font", false, true) -- Third biggest font used. Used in 3D titles and main character title.
surface.CreateFont(CAKE.MenuFont, 18, 500, true, false, "Tiramisu18Font", true, false ) -- Big font used for button labels.
surface.CreateFont(CAKE.MenuFont, 18, 500, true, false, "Tiramisu16Font", true, false ) -- Mid size button used for category headers.
surface.CreateFont(CAKE.MenuFont, 14, 500, true, false, "Tiramisu14Font", false, true) -- A moderate size font used for the main title's subtitle
surface.CreateFont(CAKE.MenuFont, 14, 300, true, false, "TiramisuDefaultFont") -- Replacement for "Default"
surface.CreateFont(CAKE.MenuFont, 12, 400, true, false, "Tiramisu12Font", true ) -- Smallest, used in tabs and the quick menu
surface.CreateFont(CAKE.WhisperFont, ScreenScale(5), 500, true, false, "TiramisuWhisperFont", true ) -- Used only for whispering
surface.CreateFont(CAKE.YellFont, ScreenScale(10), 700, true, false, "TiramisuYellFont", true ) -- Used only for yelling

-- Client Includes
include( "sh_animations.lua" )
include( "sh_anim_tables.lua" )
include( "shared.lua" )
include( "cl_binds.lua" )
include( "cl_skin.lua" )

CAKE.Loaded = true

-- Initialize the gamemode
function GM:Initialize( )

	CAKE.Running = true

	self.BaseClass:Initialize( )

end

function GM:Think( )

	if( vgui and readysent == false ) then -- VGUI is initalized, tell the server we're ready for character creation.
	
		LocalPlayer( ):ConCommand( "rp_ready\n" )
		readysent = true
		
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
	CAKE.AddRightClicks(schema)
	CAKE.AddClientsidePlugins(schema)
	CAKE.AddItems(schema)
end )

RclickTable = {}

function CAKE.AddRightClicks(schema)
	local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua" )	
	for k,v in pairs( list ) do
		local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/" .. v
		RCLICK = { }
		include( path )
		table.insert(RclickTable, RCLICK)
	end
end

CAKE.CLPlugin = {}

function CAKE.AddClientsidePlugins( schema, filename )

	local filename = filename or ""
	local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/" .. filename
	local list = file.FindInLua( path .. "*" ) or {}


	for k, v in pairs( list ) do
		if v != "." and v != ".." then
			if string.GetExtensionFromFilename( v ) and string.GetExtensionFromFilename( v ) == "lua" then
				if v:sub( 1, 3 ) == "cl_" or v:sub( 1,3 ) == "sh_" then --Filters out serverside files that may have got sent
					PLUGIN = {} -- Support for shared plugins. 
					CLPLUGIN = {}
					include( path .. v )
					CLPLUGIN.Name = CLPLUGIN.Name or schema .. "/plugins/" .. filename .. v 
					CAKE.CLPlugin[CLPLUGIN.Name] = {}
					if CLPLUGIN and CLPLUGIN.Init then
						CAKE.CLPlugin[CLPLUGIN.Name].Init = CLPLUGIN.Init or function() end
					   	CAKE.CLPlugin[CLPLUGIN.Name].Init()
					end
				end
			else --It's a folder
				CAKE.AddClientsidePlugins( schema, filename .. v .. "/" )
			end
		end
	end

end

function CAKE.AddItems( schema )

	local filename = filename or ""
	local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/items/"
	local list = file.FindInLua( path .. "*" ) or {}


	for k, v in pairs( list ) do
		if v != "." and v != ".." then
			if string.GetExtensionFromFilename( v ) and string.GetExtensionFromFilename( v ) == "lua" then
				ITEM = {  }
				include( path .. v )
				for k,v in pairs(ITEM) do
					if type(v) == "function" then
						ITEM[k] = nil
					end
				end
				CAKE.ItemData[ ITEM.Class ] = ITEM
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

local matBlurScreen = Material( "pp/blurscreen" ), x, y, n
local gradientup = surface.GetTextureID("gui/gradient_up")
local gradientdown = surface.GetTextureID("gui/gradient_down")
function CAKE.DrawBlurScreen()
	color = CAKE.BaseColor or Color( 100, 100, 115, 150 )

	// new hip way of doing gradients

	x,y = ScrW(), ScrH()

	surface.SetTexture(gradientdown)
	surface.SetDrawColor( 0, 0, 0, 250 ) 
	surface.DrawTexturedRectUV( 0, 0, x, y/5 , 0, y/5, y/5 )
	surface.SetTexture(gradientup)
	surface.DrawTexturedRectUV( 0, y - y/5, x, y/5 , 0, y/5, y/5 )
	surface.SetTexture()
	
	// Background 
	surface.SetMaterial( matBlurScreen ) 
	surface.SetDrawColor( 255, 255, 255, 255 ) 
	
	matBlurScreen:SetMaterialFloat( "$blur", 5 ) 
	render.UpdateScreenEffectTexture() 
	
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() ) 
	
	surface.SetDrawColor( color.r, color.g, color.b, 150 ) 
	surface.DrawRect( 0, 0, ScrW(), ScrH() ) 


	// Pretentious line bullshit :P
	x = math.floor( ScrW() / 5 )
	y = math.floor( ScrH() / 5 )

	surface.SetDrawColor( 50, 50, 50, 110 ) 

	for i = 1, ScrW() / 5 * 2  do
		surface.DrawLine( ( i * 5 ),0, 0, ( i * 5 ) )
	end

end