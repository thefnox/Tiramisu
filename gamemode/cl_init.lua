-- Set up the gamemode
CAKE = {  }
TIRA = CAKE
include("glon.lua")

DeriveGamemode( "sandbox" )
-- require( "datastream" )

-- Menu texture, don't touch this
EMPTY_TEXTURE = surface.GetTextureID("VGUI/white.vtf")
 
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
CAKE.NearbyPlayers = {}

--Schema configuration options

CAKE.Thirdperson = CreateClientConVar( "rp_thirdperson", 1, true, true ) -- Set this to 1 to have thirdperson enabled by default.
CAKE.ThirdpersonDistance = CreateClientConVar( "rp_thirdpersondistance", 50, true, true ) --Maximum thirdperson distance
CAKE.CameraSmoothFactor = CreateClientConVar( "rp_camerasmooth", 12, true, true ) --Camera smoothing factor, affects speed.
CAKE.FirstpersonBody = CreateClientConVar( "rp_firstpersonbody", 1, true, true ) --The return of first person legs!
CAKE.FirstpersonForward = CreateClientConVar( "rp_firstpersonforward", 6, true, true ) --How much forward should the firstperson camera be
CAKE.FirstpersonUp = CreateClientConVar( "rp_firstpersonup", 1, true, true ) --How much higher should the firstperson camera be
CAKE.StayCrouched = CreateClientConVar( "rp_crouchtoggle", 1, true, true ) -- Enables crouch toggle.
CAKE.TitleDrawDistance = CreateClientConVar( "rp_titledrawdistance", CAKE.ConVars[ "TitleDrawDistance"], true, true ) --Maximum distance a player can be to have his or her title drawn
CAKE.FadeNames = CreateClientConVar( "rp_fadenames", CAKE.ConVars[ "FadeNames"], true, true ) --Will character names fade over time?
CAKE.FadeTitles = CreateClientConVar( "rp_fadetitles", CAKE.ConVars[ "FadeTitles"], true, true ) --Will character titles fade over time?
CAKE.TitlesFadeTime = CreateClientConVar( "rp_titlefadetime", CAKE.ConVars[ "TitleFadeTime"], true, true ) --Amount of time in seconds it takes for titles to fade.
CAKE.MinimalHUD = CreateClientConVar( "rp_minimalhud", 1, true, true ) --Disables HUD elements for a more clear view.
CAKE.Headbob = CreateClientConVar( "rp_headbob", 1, true, true ) --Set this to 0 to have headbob disabled by default.
CAKE.AlwaysIntro = CreateClientConVar( "rp_alwaysintro", 0, true, true ) -- Set this to 1 to have the intro always display
 
surface.CreateFont( "Tiramisu64Font",
{

	font		= CAKE.ConVars[ "MenuFont2" ],
	size		= 64,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "Tiramisu48Font",
{

	font		= CAKE.ConVars[ "MenuFont2" ],
	size		= 48,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "Tiramisu32Font",
{

	font		= CAKE.ConVars[ "MenuFont2" ],
	size		= 32,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "Tiramisu24Font",
{

	font		= CAKE.ConVars[ "MenuFont2" ],
	size		= 24,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "Tiramisu18Font",
{

	font		= CAKE.ConVars[ "MenuFont" ],
	size		= 18,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "Tiramisu16Font",
{

	font		= CAKE.ConVars[ "MenuFont" ],
	size		= 18,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "Tiramisu14Font",
{

	font		= CAKE.ConVars[ "MenuFont" ],
	size		= 14,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "TiramisuDefaultFont",
{

	font		= CAKE.ConVars[ "MenuFont" ],
	size		= 14,
	antialias	= true,
	weight		= 300

} )

surface.CreateFont( "Tiramisu12Font",
{

	font		= CAKE.ConVars[ "MenuFont" ],
	size		= 12,
	antialias	= true,
	weight		= 400

} )

surface.CreateFont( "Tiramisu12Font",
{

	font		= CAKE.ConVars[ "MenuFont" ],
	size		= 12,
	antialias	= true,
	weight		= 400

} )

surface.CreateFont( "TiramisuWhisperFont",
{

	font		= CAKE.ConVars[ "WhisperFont" ],
	size		= 12,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "TiramisuWhisperFontOutline",
{

	shadow	= true,
	font		= CAKE.ConVars[ "WhisperFont" ],
	size		= 12,
	antialias	= true,
	weight		= 400

} )

surface.CreateFont( "TiramisuYellFont",
{

	font		= CAKE.ConVars[ "YellFont" ],
	size		= 24,
	antialias	= true,
	weight		= 700

} )

surface.CreateFont( "TiramisuYellFontOutline",
{
	shadow	= true,
	font		= CAKE.ConVars[ "YellFont" ],
	size		= 24,
	antialias	= true,
	weight		= 550

} )

surface.CreateFont( "TiramisuChatFont",
{

	font		= CAKE.ConVars[ "ChatFont" ],
	size		= 16,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "TiramisuChatFontOutline",
{
	shadow	= true,
	font		= CAKE.ConVars[ "ChatFont" ],
	size		= 16,
	antialias	= true,
	weight		= 400

} )

surface.CreateFont( "TiramisuEmoteFont",
{

	font		= CAKE.ConVars[ "EmoteFont" ],
	size		= 16,
	antialias	= true,
	weight		= 400

} )

surface.CreateFont( "TiramisuEmoteFontOutline",
{
	shadow	= true,
	font		= CAKE.ConVars[ "EmoteFont" ],
	size		= 16,
	antialias	= true,
	weight		= 400

} )

surface.CreateFont( "TiramisuOOCFont",
{

	font		= CAKE.ConVars[ "OOCFont" ],
	size		= 16,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "TiramisuOOCFontOutline",
{
	shadow	= true,
	font		= CAKE.ConVars[ "OOCFont" ],
	size		= 16,
	antialias	= true,
	weight		= 400

} )

surface.CreateFont( "TiramisuNoteFont",
{

	font		= CAKE.ConVars[ "NoteFont" ],
	size		= 18,
	antialias	= true,
	weight		= 500

} )

surface.CreateFont( "TiramisuNamesFont",
{

	font		= CAKE.ConVars[ "NamesFont" ],
	size		= 20,
	antialias	= true,
	weight		= 400

} )

surface.CreateFont( "TiramisuTitlesFont",
{

	font		= CAKE.ConVars[ "TitlesFont" ],
	size		= 14,
	antialias	= true,
	weight		= 400

} )

-- surface.CreateFont(CAKE.ConVars[ "MenuFont2" ], 64, 500, true, false, "Tiramisu64Font", false, true) -- Biggest font used only once on the intro.
-- surface.CreateFont(CAKE.ConVars[ "MenuFont2" ], 48, 500, true, false, "Tiramisu48Font", false, true) -- Biggest font used.
-- surface.CreateFont(CAKE.ConVars[ "MenuFont2" ], 32, 500, true, false, "Tiramisu32Font", false, true) -- Second biggest font used. Used in 3D titles and main character title.
-- surface.CreateFont(CAKE.ConVars[ "MenuFont2" ], 24, 500, true, false, "Tiramisu24Font", false, true) -- Third biggest font used. Used in 3D titles and main character title.
-- surface.CreateFont(CAKE.ConVars[ "MenuFont" ], 18, 500, true, false, "Tiramisu18Font", true, false ) -- Big font used for button labels.
-- surface.CreateFont(CAKE.ConVars[ "MenuFont" ], 18, 500, true, false, "Tiramisu16Font", true, false ) -- Mid size button used for category headers.
-- surface.CreateFont(CAKE.ConVars[ "MenuFont" ], 14, 500, true, false, "Tiramisu14Font", false, true) -- A moderate size font used for the main title's subtitle
-- surface.CreateFont(CAKE.ConVars[ "MenuFont" ], 14, 300, true, false, "TiramisuDefaultFont") -- Replacement for "Default"
-- surface.CreateFont(CAKE.ConVars[ "MenuFont" ], 12, 400, true, false, "Tiramisu12Font", true ) -- Smallest, used in tabs and the quick menu
-- surface.CreateFont(CAKE.ConVars[ "WhisperFont" ], 12, 500, true, false, "TiramisuWhisperFont") -- Used only for whispering
-- surface.CreateFont(CAKE.ConVars[ "WhisperFont" ], 12, 500, true, false, "TiramisuWhisperFontOutline", false, false)
-- surface.CreateFont(CAKE.ConVars[ "YellFont" ], 24, 700, true, false, "TiramisuYellFont") -- Used only for yelling
-- surface.CreateFont(CAKE.ConVars[ "YellFont" ], 24, 700, true, false, "TiramisuYellFontOutline", false, false)
-- surface.CreateFont(CAKE.ConVars[ "ChatFont" ], 16, 500, true, false, "TiramisuChatFont")
-- surface.CreateFont(CAKE.ConVars[ "ChatFont" ], 16, 500, true, false, "TiramisuChatFontOutline", false, false)
-- surface.CreateFont(CAKE.ConVars[ "EmoteFont" ], 16,500, true, false, "TiramisuEmoteFont")
-- surface.CreateFont(CAKE.ConVars[ "EmoteFont" ], 16,500, true, false, "TiramisuEmoteFontOutline", false, false)
-- surface.CreateFont(CAKE.ConVars[ "OOCFont" ], 16, 500, true, false, "TiramisuOOCFont")
-- surface.CreateFont(CAKE.ConVars[ "OOCFont" ], 16, 500, true, false, "TiramisuOOCFontOutline", false, false)
-- surface.CreateFont(CAKE.ConVars[ "NoteFont" ], 18, 500, true, false, "TiramisuNoteFont" )
-- surface.CreateFont(CAKE.ConVars[ "NamesFont"], 20, 400, true, false, "TiramisuNamesFont" ) --Font used for names
-- -- surface.CreateFont(CAKE.ConVars[ "TitlesFont"], 14, 400, true, false, "TiramisuTitlesFont" ) --Font used for titles

-- Client Includes
include( "sh_animations.lua" )
include( "sh_anim_tables.lua" )
include( "shared.lua" )
include( "cl_binds.lua" )
include( "cl_skin.lua" )

for _,mdl in pairs(CAKE.ConVars[ "DefaultModels" ].Male) do
	util.PrecacheModel( mdl )
end

for _,mdl in pairs(CAKE.ConVars[ "DefaultModels" ].Female) do
	util.PrecacheModel( mdl )
end


CAKE.Loaded = true

--Some quick utility stuff
local sin,cos,rad = math.sin,math.cos,math.rad
local tmp,s,c
function surface.DrawNPolyOffset( x, y, radius, sides, rotation )
	surface.NPoly = surface.NPoly or {}
	surface.NPoly[sides] = surface.NPoly[sides] or {}
	rotation = rotation or 0

	x,y = x + radius, y + radius

	if !surface.NPoly[sides][radius .. x .. y .. rotation] then
		surface.NPoly[sides][radius .. x .. y .. rotation] = {}
		for i=1,sides do
			tmp = rad(i*360)/sides
			s = sin(tmp + rotation)
			c = cos(tmp + rotation)
			surface.NPoly[sides][radius .. x .. y .. rotation][i] = {x = x + c*radius,y = y + s*radius,u = (c+1)/2,v = (s+1)/2}
		end
	end

	surface.DrawPoly( surface.NPoly[sides][radius .. x .. y .. rotation] )
end

function surface.DrawNPoly( x, y, radius, sides, rotation )
	surface.NPoly = surface.NPoly or {}
	surface.NPoly[sides] = surface.NPoly[sides] or {}
	rotation = rotation or 0

	if !surface.NPoly[sides][radius .. x .. y .. rotation] then
		surface.NPoly[sides][radius .. x .. y .. rotation] = {}
		for i=1,sides do
			tmp = rad(i*360)/sides
			s = sin(tmp + rotation)
			c = cos(tmp + rotation)
			surface.NPoly[sides][radius .. x .. y .. rotation][i] = {x = x + c*radius,y = y + s*radius,u = (c+1)/2,v = (s+1)/2}
		end
	end

	surface.DrawPoly( surface.NPoly[sides][radius .. x .. y .. rotation] )
end

-- Initialize the gamemode
function GM:Initialize()

	CAKE.Running = true

	self.BaseClass:Initialize()

end

function GM:InitPostEntity()

	self.BaseClass:InitPostEntity()

	RunConsoleCommand( "rp_ready" )
	if CAKE.ConVars[ "ForceJigglebones" ] then
		RunConsoleCommand( "cl_jiggle_bone_framerate_cutoff", "1" )
	end
	CAKE.EnableBlackScreen( CAKE.ConVars[ "SpawnWithBlackScreen" ], CAKE.ConVars[ "SpawnWithBlackScreen" ] )
	
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

usermessage.Hook("CAKE.SendConsole", function(um)

	local msg = um:ReadString()
	local clrstr = um:ReadString()
	local clrtbl = string.Explode(":", clrstr)
	local clr = Color(clrtbl[1], clrtbl[2], clrtbl[3], 255)

	MsgC(clr, msg .. "\n")

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

Schemas = {}

usermessage.Hook("Tiramisu.AddSchema", function(data)
	local schema = data:ReadString()
	CAKE.AddSchemaEntities(schema)
	CAKE.AddRightClicks(schema)
	CAKE.AddClientsidePlugins(schema)
	CAKE.AddItems(schema)
end )

usermessage.Hook( "Tiramisu.EnableBlackScreen", function( um)
	CAKE.EnableBlackScreen( um:ReadBool(), false )
end)

usermessage.Hook( "Tiramisu.SendError", function( um )
	
	local text = um:ReadString()
	CAKE.Message( text, "Message", "OK" )

end)

local button 
usermessage.Hook( "Tiramisu.DisplayRespawnButton", function(um)
	if um:ReadBool() then
		gui.EnableScreenClicker( true )
		button = vgui.Create( "DButton" )
		button:SetText( "Respawn" )
		button:SetSize( 74, 25 )
		button:SetPos( ScrW() / 2 - 32, 90 )
		button.DoClick = function()
			RunConsoleCommand( "rp_acceptdeath" )
			button:Remove()
			button = nil
		end
	else
		gui.EnableScreenClicker( false )
		if button then
			button:Remove()
			button = nil
		end
	end
end)

RclickTable = {}

function CAKE.AddRightClicks(schema)
	-- local list = file.FindInLua( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua" )	
	local files, folders = file.Find( CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua", "LUA" )
	
	for k,v in pairs( files ) do
		local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/rclick/" .. v
		RCLICK = { }
		MsgN( "Loading " .. path )
		include( path )
		table.insert(RclickTable, RCLICK)
	end
end

CAKE.CLPlugin = {}

function CAKE.AddClientsidePlugins( schema, filename )

	local filename = filename or ""
	local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/plugins/" .. filename
	-- local list = file.FindInLua( path .. "*" ) or {}
	-- local list = file.Find( path .. "*", "LUA" ) or {}
	local files, folders = file.Find( path .. "*", "LUA" )


	for k, v in pairs( files ) do
		if v:sub( 1, 3 ) == "cl_" or v:sub( 1,3 ) == "sh_" then --Filters out serverside files that may have got sent
			PLUGIN = {} -- Support for shared plugins. 
			CLPLUGIN = {}
			MsgN( "Loading " .. path ..v )
			include( path .. v )
			CLPLUGIN.Name = CLPLUGIN.Name or schema .. "/plugins/" .. filename .. v
			CAKE.CLPlugin[CLPLUGIN.Name] = {}
			if CLPLUGIN and CLPLUGIN.Init then
				CAKE.CLPlugin[CLPLUGIN.Name].Init = CLPLUGIN.Init or function() end
				CAKE.CLPlugin[CLPLUGIN.Name].Init()
	--[[ for k, v in pairs( list ) do
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
				CAKE.AddClientsidePlugins( schema, filename .. v .. "/" ) ]]--
			end
		end
	end

	for k, v in pairs( folders ) do 
		CAKE.AddClientsidePlugins( schema, filename .. v .. "/" )
	end
end

function CAKE.AddItems( schema )

	local filename = filename or ""
	local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/items/"
	-- local list = file.FindInLua( path .. "*" ) or {}
	-- local list = file.Find( path .. "*", "LUA" ) or {}
	local files, folders = file.Find( path .. "*", "LUA" )

	for k, v in pairs( files ) do
		ITEM = {  }
		MsgN( "Loading " .. path ..v )
		include( path .. v )
		for k,v in pairs(ITEM) do
			if type(v) == "function" then
				ITEM[k] = nil
	--[[ for k, v in pairs( list ) do
		if v != "." and v != ".." then
			if string.GetExtensionFromFilename( v ) and string.GetExtensionFromFilename( v ) == "lua" then
				ITEM = {  }
				include( path .. v )
				for k,v in pairs(ITEM) do
					if type(v) == "function" then
						ITEM[k] = nil
					end
				end
				CAKE.ItemData[ ITEM.Class ] = ITEM --]]
			end
		end
		CAKE.ItemData[ ITEM.Class ] = ITEM
	end

end

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

local blackscreenalpha = 0
hook.Add( "PostDrawHUD", "Tiramisu.DrawBlackScreen", function()
	if CAKE.DrawBlackScreen then
		if !CAKE.ForceBlackScreen then
			blackscreenalpha = Lerp( RealFrameTime() * 1.5, blackscreenalpha, 255 )
		else
			blackscreenalpha = 255
		end
		surface.SetDrawColor( 0, 0, 0, blackscreenalpha )
		surface.DrawRect( -1, -1, ScrW() + 1, ScrH() + 1 )
	else
		if blackscreenalpha != 0 then
			blackscreenalpha = Lerp( RealFrameTime(), blackscreenalpha, 0 )
			surface.SetDrawColor( 0, 0, 0, blackscreenalpha )
			surface.DrawRect( -1, -1, ScrW() + 1, ScrH() + 1 )
		end
	end
end)

function CAKE.EnableBlackScreen( bool, force )
	CAKE.DrawBlackScreen, CAKE.ForceBlackScreen = bool, force
end

function CAKE.DrawBlurScreen()
	derma.SkinHook( "Paint", "BlurScreen" )
end

--This function was made by Nori, not me, as many other parts of the gamemode. This one's special though, since it's from Cakescript G3 lol.
function CAKE.CalculateDoorTextPosition(door, reversed)
	if !IsValid(door) then return false end
	local traceData = {}
	local obbCenter = door:OBBCenter()
	local obbMaxs = door:OBBMaxs()
	local obbMins = door:OBBMins()
		
	traceData.endpos = door:LocalToWorld(obbCenter)
	traceData.filter = ents.FindInSphere(traceData.endpos, 20)
		
	for k, v in pairs(traceData.filter) do
		if (v == door) then
			traceData.filter[k] = nil
		end
	end
		
	local length = 0
	local size = obbMins - obbMaxs
		
	size.x = math.abs(size.x)
	size.y = math.abs(size.y)
	size.z = math.abs(size.z)
		
	if (size.z < size.x and size.z < size.y) then
		length = size.z
		
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetUp() * length)
		else
			traceData.start = traceData.endpos + (door:GetUp() * length)
		end
	elseif (size.x < size.y) then
		length = size.x
		width = size.y
			
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetForward() * length)
		else
			traceData.start = traceData.endpos + (door:GetForward() * length)
		end
	elseif (size.y < size.x) then
		length = size.y
		
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetRight() * length)
		else
		
			traceData.start = traceData.endpos + (door:GetRight() * length)
		end
	end

	local trace = util.TraceLine(traceData)
	local angles = trace.HitNormal:Angle()
	
	if (trace.HitWorld and !reversed) then
		return CAKE.CalculateDoorTextPosition(door, true)
	end
		
	angles:RotateAroundAxis(angles:Forward(), 90)
	angles:RotateAroundAxis(angles:Right(), 90)
	
	local position = trace.HitPos - ( ( (traceData.endpos - trace.HitPos):Length() * 2) + 2 ) * trace.HitNormal
	local anglesBack = trace.HitNormal:Angle()
	local positionBack = trace.HitPos + (trace.HitNormal * 2)
		
	anglesBack:RotateAroundAxis(anglesBack:Forward(), 90)
	anglesBack:RotateAroundAxis(anglesBack:Right(), -90)
	
	return {
		positionBack = positionBack,
		anglesBack = anglesBack,
		position = position,
		HitWorld = trace.HitWorld,
		angles = angles,
	}
end