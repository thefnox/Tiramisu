-- Set up the gamemode
DeriveGamemode( "sandbox" );

--Initializing global variables. Don't touch this
CAKE = {  };
CAKE.ItemData = {}
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
CAKE.Notifications = {}
CAKE.ActiveNotifications = {}

--Schema configuration options

CAKE.MenuFont = "Harabara" -- The default font for the whole schema
CAKE.BaseColor = Color( 100, 100, 115, 150 ) --The schema's default color. Can be set in game
CAKE.Webpage = "http://deadzonerebirth.wikia.com/" --Set this to whatever you want to, it'll be accessible on the "Forums" tab
CAKE.Thirdperson = CreateClientConVar( "rp_thirdperson", 0, true, true ) -- Set this to 1 to have thirdperson enabled by default.
CAKE.ThirdpersonDistance = CreateClientConVar( "rp_thirdpersondistance", 50, true, true ) --Maximum thirdperson distance
CAKE.CameraSmoothFactor = CreateClientConVar( "rp_camerasmooth", 12, true, true ) --Camera smoothing factor, affects speed.
CAKE.Headbob = CreateClientConVar( "rp_headbob", 1, true, true ) --Set this to 0 to have headbob disabled by default.
CAKE.UseIntro = true --Set this to false if you want the player to go directly into the character menu when they join
CAKE.IntroText = "Welcome to Tiramisu" -- Character menu and intro text. NOTE, the HL2RP scheme changes this
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
include( "sh_animations.lua" )
include( "sh_anim_tables.lua" )
include( "sh_stats.lua" )
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

local panel = FindMetaTable( "Panel" )

--Utility function, allows a panel to track a world position.
function panel:TrackPos( vector, margin, allowclipoff, keepoffmouse )
	margin = margin or 0
	if vector then
		local toscreen = vector:ToScreen()
		local x, y
		if allowclipoff then
			--Just let it follow the on screen position, regardless of if it is actually fully on screen
			if toscreen.visible then
				x, y = toscreen.x, toscreen.y
			else
				x, y = ScrW(), ScrH()
			end
		else
			if !toscreen.visible then
				toscreen.x, toscreen.y = ScrW(), ScrH()
			end
			--Try to keep it on screen.
			if toscreen.x + self:GetWide() + margin > ScrW() then
				x = ScrW() - self:GetWide() - margin
			elseif toscreen.x < 0 then
				x = margin
			else
				x = toscreen.x
			end 
			if toscreen.y + self:GetTall() + margin > ScrH() then
				y = ScrH() - self:GetTall() - margin
			elseif toscreen.y < 0 then
				y = margin
			else
				y = toscreen.y
			end 
		end
		if keepoffmouse and vgui.CursorVisible() and CAKE.PosInRegion( gui.MouseX(), gui.MouseY(), x,y, self:GetWide() + x, self:GetTall() + y ) then
			local deltax, deltay = gui.MouseX() - toscreen.x, gui.MouseY() - toscreen.y
			if deltax > self:GetWide() / 2 then
				toscreen.x = toscreen.x - ( x + self:GetWide() / 2 - gui.MouseX() )
			else
				toscreen.x = toscreen.x + deltax
			end
			if deltay > self:GetTall() / 2 then
				toscreen.y = toscreen.y - ( y + self:GetTall() / 2 - gui.MouseY() )
			else
				toscreen.y = toscreen.y + deltay
			end
			if allowclipoff then
				--Just let it follow the on screen position, regardless of if it is actually fully on screen
				if toscreen.visible then
					x, y = toscreen.x, toscreen.y
				else
					x, y = ScrW(), ScrH()
				end
			else
				if !toscreen.visible then
					toscreen.x, toscreen.y = ScrW(), ScrH()
				end
				--Try to keep it on screen.
				if toscreen.x + self:GetWide() + margin > ScrW() then
					x = ScrW() - self:GetWide() - margin
				elseif toscreen.x < 0 then
					x = margin
				else
					x = toscreen.x
				end 
				if toscreen.y + self:GetTall() + margin > ScrH() then
					y = ScrH() - self:GetTall() - margin
				elseif toscreen.y < 0 then
					y = margin
				else
					y = toscreen.y
				end 
			end
		end
		return x, y
	end
end

meta = nil

--And a non panel version.
function CAKE.TrackPos( wide, tall, vector, margin, allowclipoff )
	margin = margin or 0
	if vector then
		local toscreen = vector:ToScreen()
		local x, y
		if allowclipoff then
			--Just let it follow the on screen position, regardless of if it is actually fully on screen
			if toscreen.visible then
				x, y = toscreen.x, toscreen.y
			else
				x, y = ScrW(), ScrH()
			end
		else
			--Try to keep it on screen.
			if toscreen.x + wide + margin > ScrW() then
				x = ScrW() - wide - margin
			elseif toscreen.x < 0 then
				x = margin
			else
				x = toscreen.x
			end 
			if toscreen.y + tall + margin > ScrH() then
				y = ScrW() - tall - margin
			elseif toscreen.y < 0 then
				y = margin
			else
				y = toscreen.y
			end 
		end
		return x, y
	end
end

--And a helper function, to check if a point is within a region in space.
function CAKE.PosInRegion( x, y, topx, topy, botx, boty, z, topz, botz )
	if !z then --Keep it bidimensional 
		if ( x >= topx and x <= botx ) and ( y >= topy and y <= boty ) then
			return true
		end
	else
		if (topx <= x and botx >= x) and (topy <= y and boty >= y) and (topz <= z and botz >= z) then
			return true
		end
	end
	return false
end


function CAKE.AddNotification( text, pos, color, textcolor, allowclipoff, radius, callback, runonce )
	local tbl = {}
	tbl["text"] = text or "-none-"
	tbl["pos"] = pos or Vector( 0, 0, 0 )
	tbl["color"] = color or CAKE.BaseColor
	tbl["textcolor"] = textcolor or Color( 255, 255, 255, 255 )
	tbl["radius"] = radius or 0
	tbl["callback"] = callback or true
	tbl["runonce"] = runonce

	table.insert( CAKE.Notifications, tbl ) 
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
		table.insert(RclickTable, RCLICK);
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
				ITEM = {  };
				include( path .. v );
				for k,v in pairs(ITEM) do
					if type(v) == "function" then
						ITEM[k] = nil
					end
				end
				CAKE.ItemData[ ITEM.Class ] = ITEM;
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