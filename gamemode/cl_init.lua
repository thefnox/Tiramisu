-- Set up the gamemode
TIRA = {  } //As of Tiramisu 3, we're setting the namespace for all our globals to TIRA.
CAKE = TIRA //Luckily, we can just make the TIRA table point to TIRA, so there's no need to change anything in your code.
DeriveGamemode( "sandbox" )
require( "datastream" )
include( "von.lua" )
require("glon")

function TIRA.Serialize(tbl)
	return von.serialize(tbl)
end

function TIRA.Deserialize(str)
	return von.deserialize(string.gsub(str, "\\", ""))
end

--Load up the configuration file
include( "configuration.lua" )

--Initializing global variables. Don't touch this
TIRA.ItemData = {}
TIRA.Running = false
TIRA.Loaded = false
TIRA.Skin = "Tiramisu"
TIRA.CharCreate = function() end
TIRA.Clothing = "none"
TIRA.Helmet = "none"
TIRA.Gear = {}
TIRA.ClothingTbl = {}
TIRA.MyGroup = {}
readysent = false
TIRA.MenuTabs = {}
TIRA.ActiveTab = nil
TIRA.MenuOpen = false
TIRA.DisplayMenu = false
TIRA.ViewRagdoll = false
TIRA.FreeScroll = false
TIRA.ForceFreeScroll = false
TIRA.Notifications = {}
TIRA.ActiveNotifications = {}
TIRA.NearbyPlayers = {}

--Schema configuration options

TIRA.Thirdperson = CreateClientConVar( "rp_thirdperson", 1, true, true ) -- Set this to 1 to have thirdperson enabled by default.
TIRA.ThirdpersonDistance = CreateClientConVar( "rp_thirdpersondistance", 50, true, true ) --Maximum thirdperson distance
TIRA.CameraSmoothFactor = CreateClientConVar( "rp_camerasmooth", 12, true, true ) --Camera smoothing factor, affects speed.
TIRA.FirstpersonBody = CreateClientConVar( "rp_firstpersonbody", 1, true, true ) --The return of first person legs!
TIRA.FirstpersonForward = CreateClientConVar( "rp_firstpersonforward", 6, true, true ) --How much forward should the firstperson camera be
TIRA.FirstpersonUp = CreateClientConVar( "rp_firstpersonup", 1, true, true ) --How much higher should the firstperson camera be
TIRA.StayCrouched = CreateClientConVar( "rp_crouchtoggle", 1, true, true ) -- Enables crouch toggle.
TIRA.TitleDrawDistance = CreateClientConVar( "rp_titledrawdistance", TIRA.ConVars[ "TitleDrawDistance"], true, true ) --Maximum distance a player can be to have his or her title drawn
TIRA.FadeNames = CreateClientConVar( "rp_fadenames", TIRA.ConVars[ "FadeNames"], true, true ) --Will character names fade over time?
TIRA.FadeTitles = CreateClientConVar( "rp_fadetitles", TIRA.ConVars[ "FadeTitles"], true, true ) --Will character titles fade over time?
TIRA.TitlesFadeTime = CreateClientConVar( "rp_titlefadetime", TIRA.ConVars[ "TitleFadeTime"], true, true ) --Amount of time in seconds it takes for titles to fade.
TIRA.MinimalHUD = CreateClientConVar( "rp_minimalhud", 1, true, true ) --Disables HUD elements for a more clear view.
TIRA.Headbob = CreateClientConVar( "rp_headbob", 1, true, true ) --Set this to 0 to have headbob disabled by default.
TIRA.AlwaysIntro = CreateClientConVar( "rp_alwaysintro", 0, true, true ) -- Set this to 1 to have the intro always display

surface.CreateFont(TIRA.ConVars[ "MenuFont2" ], 64, 500, true, false, "Tiramisu64Font", false, true) -- Biggest font used only once on the intro.
surface.CreateFont(TIRA.ConVars[ "MenuFont2" ], 48, 500, true, false, "Tiramisu48Font", false, true) -- Biggest font used.
surface.CreateFont(TIRA.ConVars[ "MenuFont2" ], 32, 500, true, false, "Tiramisu32Font", false, true) -- Second biggest font used. Used in 3D titles and main character title.
surface.CreateFont(TIRA.ConVars[ "MenuFont2" ], 24, 500, true, false, "Tiramisu24Font", false, true) -- Third biggest font used. Used in 3D titles and main character title.
surface.CreateFont(TIRA.ConVars[ "MenuFont" ], 18, 500, true, false, "Tiramisu18Font", true, false ) -- Big font used for button labels.
surface.CreateFont(TIRA.ConVars[ "MenuFont" ], 18, 500, true, false, "Tiramisu16Font", true, false ) -- Mid size button used for category headers.
surface.CreateFont(TIRA.ConVars[ "MenuFont" ], 14, 500, true, false, "Tiramisu14Font", false, true) -- A moderate size font used for the main title's subtitle
surface.CreateFont(TIRA.ConVars[ "MenuFont" ], 14, 300, true, false, "TiramisuDefaultFont") -- Replacement for "Default"
surface.CreateFont(TIRA.ConVars[ "MenuFont" ], 12, 400, true, false, "Tiramisu12Font", true ) -- Smallest, used in tabs and the quick menu
surface.CreateFont(TIRA.ConVars[ "WhisperFont" ], 12, 500, true, false, "TiramisuWhisperFont") -- Used only for whispering
surface.CreateFont(TIRA.ConVars[ "WhisperFont" ], 12, 500, true, false, "TiramisuWhisperFontOutline", false, false)
surface.CreateFont(TIRA.ConVars[ "YellFont" ], 24, 700, true, false, "TiramisuYellFont") -- Used only for yelling
surface.CreateFont(TIRA.ConVars[ "YellFont" ], 24, 700, true, false, "TiramisuYellFontOutline", false, false)
surface.CreateFont(TIRA.ConVars[ "ChatFont" ], 16, 500, true, false, "TiramisuChatFont")
surface.CreateFont(TIRA.ConVars[ "ChatFont" ], 16, 500, true, false, "TiramisuChatFontOutline", false, false)
surface.CreateFont(TIRA.ConVars[ "EmoteFont" ], 16,500, true, false, "TiramisuEmoteFont")
surface.CreateFont(TIRA.ConVars[ "EmoteFont" ], 16,500, true, false, "TiramisuEmoteFontOutline", false, false)
surface.CreateFont(TIRA.ConVars[ "OOCFont" ], 16, 500, true, false, "TiramisuOOCFont")
surface.CreateFont(TIRA.ConVars[ "OOCFont" ], 16, 500, true, false, "TiramisuOOCFontOutline", false, false)
surface.CreateFont(TIRA.ConVars[ "NoteFont" ], 18, 500, true, false, "TiramisuNoteFont" )
surface.CreateFont(TIRA.ConVars[ "NamesFont"], 20, 400, true, false, "TiramisuNamesFont" ) --Font used for names
surface.CreateFont(TIRA.ConVars[ "TitlesFont"], 14, 400, true, false, "TiramisuTitlesFont" ) --Font used for titles

-- Client Includes
include( "sh_animations.lua" )
include( "sh_anim_tables.lua" )
include( "shared.lua" )
include( "cl_binds.lua" )
include( "cl_skin.lua" )

for _,mdl in pairs(TIRA.ConVars[ "DefaultModels" ].Male) do
	util.PrecacheModel( mdl )
end

for _,mdl in pairs(TIRA.ConVars[ "DefaultModels" ].Female) do
	util.PrecacheModel( mdl )
end


TIRA.Loaded = true

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

	TIRA.Running = true

	self.BaseClass:Initialize()

end

function GM:InitPostEntity()

	self.BaseClass:InitPostEntity()

	RunConsoleCommand( "rp_ready" )
	if TIRA.ConVars[ "ForceJigglebones" ] then
		RunConsoleCommand( "cl_jiggle_bone_framerate_cutoff", "1" )
	end
	TIRA.EnableBlackScreen( TIRA.ConVars[ "SpawnWithBlackScreen" ], TIRA.ConVars[ "SpawnWithBlackScreen" ] )
	
end

function GM:ForceDermaSkin()

	return TIRA.Skin
	
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

Schemas = {}

usermessage.Hook("Tiramisu.AddSchema", function(data)
	local schema = data:ReadString()
	TIRA.AddRightClicks(schema)
	TIRA.AddClientsidePlugins(schema)
	TIRA.AddItems(schema)
end )

usermessage.Hook( "Tiramisu.EnableBlackScreen", function( um)
	TIRA.EnableBlackScreen( um:ReadBool(), false )
end)

usermessage.Hook( "Tiramisu.SendError", function( um )
	
	local text = um:ReadString()
	TIRA.Message( text, "Message", "OK" )

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

function TIRA.AddRightClicks(schema)
	local list = file.FindInLua( TIRA.Name .. "/gamemode/schemas/" .. schema .. "/rclick/*.lua" )	
	for k,v in pairs( list ) do
		local path = TIRA.Name .. "/gamemode/schemas/" .. schema .. "/rclick/" .. v
		RCLICK = { }
		include( path )
		table.insert(RclickTable, RCLICK)
	end
end

TIRA.CLPlugin = {}

function TIRA.AddClientsidePlugins( schema, filename )

	local filename = filename or ""
	local path = TIRA.Name .. "/gamemode/schemas/" .. schema .. "/plugins/" .. filename
	local list = file.FindInLua( path .. "*" ) or {}


	for k, v in pairs( list ) do
		if v != "." and v != ".." then
			if string.GetExtensionFromFilename( v ) and string.GetExtensionFromFilename( v ) == "lua" then
				if v:sub( 1, 3 ) == "cl_" or v:sub( 1,3 ) == "sh_" then --Filters out serverside files that may have got sent
					PLUGIN = {} -- Support for shared plugins. 
					CLPLUGIN = {}
					include( path .. v )
					CLPLUGIN.Name = CLPLUGIN.Name or schema .. "/plugins/" .. filename .. v 
					TIRA.CLPlugin[CLPLUGIN.Name] = {}
					if CLPLUGIN and CLPLUGIN.Init then
						TIRA.CLPlugin[CLPLUGIN.Name].Init = CLPLUGIN.Init or function() end
					   	TIRA.CLPlugin[CLPLUGIN.Name].Init()
					end
				end
			else --It's a folder
				TIRA.AddClientsidePlugins( schema, filename .. v .. "/" )
			end
		end
	end

end

function TIRA.AddItems( schema )

	local filename = filename or ""
	local path = TIRA.Name .. "/gamemode/schemas/" .. schema .. "/items/"
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
				TIRA.ItemData[ ITEM.Class ] = ITEM
			end
		end
	end

end

function TIRA.RegisterMenuTab( name, func, closefunc ) --The third argument is the function used for closing your panel.
	TIRA.MenuTabs[ name ] = {}
	TIRA.MenuTabs[ name ][ "function" ] = func or function() end
	TIRA.MenuTabs[ name ][ "closefunc" ] = closefunc or function() end
end

function TIRA.CloseTabs()
	for k, v in pairs( TIRA.MenuTabs ) do
		v[ "closefunc" ]()
	end
	TIRA.ActiveTab = nil
end

function TIRA.SetActiveTab( name )
	--TIRA.MenuOpen = true
	TIRA.CloseTabs()
	if TIRA.MenuTabs and TIRA.MenuTabs[ name ] then
		TIRA.MenuTabs[ name ][ "function" ]()
	else
		timer.Simple( 1, function()
			if TIRA.MenuTabs and TIRA.MenuTabs[ name ] then
				TIRA.MenuTabs[ name ][ "function" ]()
			end
		end)
	end
	TIRA.ActiveTab = name
end

local blackscreenalpha = 0
hook.Add( "PostDrawHUD", "Tiramisu.DrawBlackScreen", function()
	if TIRA.DrawBlackScreen then
		if !TIRA.ForceBlackScreen then
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

function TIRA.EnableBlackScreen( bool, force )
	TIRA.DrawBlackScreen, TIRA.ForceBlackScreen = bool, force
end

function TIRA.DrawBlurScreen()
	derma.SkinHook( "Paint", "BlurScreen" )
end

--This function was made by Nori, not me, as many other parts of the gamemode. This one's special though, since it's from TIRAscript G3 lol.
function TIRA.CalculateDoorTextPosition(door, reversed)
	if !ValidEntity(door) then return false end
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
		return TIRA.CalculateDoorTextPosition(door, true)
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