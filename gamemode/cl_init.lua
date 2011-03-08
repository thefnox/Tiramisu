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

CAKE.MenuTabs = {}
CAKE.ActiveTab = nil
CAKE.MenuOpen = false
CAKE.DisplayMenu = false

require( "datastream" )
-- Client Includes
include( "shared.lua" );
include( "player_shared.lua" );
include( "cl_hud.lua" );
include( "cl_binds.lua" );
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

function GM:StartChat()
        return true -- That's what the chatbox is there for.
end

function GM:EndChat()
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
	InitHUDMenu()
	
end );

usermessage.Hook( "charactercreation", function()
	
	CAKE.CharCreate()

end)

usermessage.Hook( "senderror", function( um )
	
	local text = um:ReadString()
	CAKE.Message( text, "Message", "OK" )

end)

function CAKE.RegisterMenuTab( name, func, closefunc ) --The third argument is the function used for closing your panel.
	print( "Registering Menu Tab " .. name )
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


--Taken from derma_utils, meant to be used with the cute little frames
/*
        Display a simple message box.
        
        CAKE.Message( "Hey Some Text Here!!!", "Message Title (Optional)", "Button Text (Optional)" )
        
*/
function CAKE.Message( strText, strTitle, strButtonText, color )
 
        local Window = vgui.Create( "DFrameTransparent" )
                Window:SetTitle( strTitle or "Message" )
                Window:SetDraggable( false )
                Window:ShowCloseButton( false )
                if color then
                    Window:SetColor( color )
                else
                    Window:SetColor( CAKE.BaseColor )
                end
                
        local InnerPanel = vgui.Create( "DPanel", Window )
        
        local Text = vgui.Create( "DLabel", InnerPanel )
                Text:SetText( strText or "Message Text" )
                Text:SizeToContents()
                Text:SetContentAlignment( 5 )
                Text:SetTextColor( color_white )
                
        local ButtonPanel = vgui.Create( "DPanel", Window )
        ButtonPanel:SetTall( 30 )
                
        local Button = vgui.Create( "DButton", ButtonPanel )
                Button:SetText( strButtonText or "OK" )
                Button:SizeToContents()
                Button:SetTall( 20 )
                Button:SetWide( Button:GetWide() + 20 )
                Button:SetPos( 5, 5 )
                Button.DoClick = function() Window:Close() end
                
        ButtonPanel:SetWide( Button:GetWide() + 10 )
        
        local w, h = Text:GetSize()
        
        Window:SetSize( w + 50, h + 25 + 45 + 10 )
        Window:Center()
        
        InnerPanel:StretchToParent( 5, 25, 5, 45 )
        
        Text:StretchToParent( 5, 5, 5, 5 )      
        
        ButtonPanel:CenterHorizontal()
        ButtonPanel:AlignBottom( 8 )
        
        Window:MakePopup()
 
end


/*
        Ask a question with multiple answers..
        
        CAKE.Query( "Would you like me to punch you right in the face?", "Question!",
                                                "Yesss",        function() MsgN( "Pressed YES!") end, 
                                                "Nope!",        function() MsgN( "Pressed Nope!") end, 
                                                "Cancel",       function() MsgN( "Cancelled!") end )
                
*/
function CAKE.Query( strText, strTitle, ... )
 
        local Window = vgui.Create( "DFrameTransparent" )
                Window:SetTitle( strTitle or "Message Title (First Parameter)" )
                Window:SetDraggable( false )
                Window:ShowCloseButton( false )
                Window:SetColor( Color( 140, 100, 100) )
                
        local InnerPanel = vgui.Create( "DPanel", Window )
        
        local Text = vgui.Create( "DLabel", InnerPanel )
                Text:SetText( strText or "Message Text (Second Parameter)" )
                Text:SizeToContents()
                Text:SetContentAlignment( 5 )
                Text:SetTextColor( color_white )
 
        local ButtonPanel = vgui.Create( "DPanel", Window )
        ButtonPanel:SetTall( 30 )
 
        // Loop through all the options and create buttons for them.
        local NumOptions = 0
        local x = 5
        for k=1, 8, 2 do
                
                if ( arg[k] == nil ) then break end
                
                local Text = arg[k]
                local Func = arg[k+1] or function() end
        
                local Button = vgui.Create( "DButton", ButtonPanel )
                        Button:SetText( Text )
                        Button:SizeToContents()
                        Button:SetTall( 20 )
                        Button:SetWide( Button:GetWide() + 20 )
                        Button.DoClick = function() Window:Close(); Func() end
                        Button:SetPos( x, 5 )
                        
                x = x + Button:GetWide() + 5
                        
                ButtonPanel:SetWide( x ) 
                NumOptions = NumOptions + 1
        
        end
 
        
        local w, h = Text:GetSize()
        
        w = math.max( w, ButtonPanel:GetWide() )
        
        Window:SetSize( w + 50, h + 25 + 45 + 10 )
        Window:Center()
        
        InnerPanel:StretchToParent( 5, 25, 5, 45 )
        
        Text:StretchToParent( 5, 5, 5, 5 )      
        
        ButtonPanel:CenterHorizontal()
        ButtonPanel:AlignBottom( 8 )
        
        Window:MakePopup()
        
        if ( NumOptions == 0 ) then
        
                Window:Close()
                Error( "CAKE.Query: Created Query with no Options!?" )
        
        end
 
end
 
 
/*
        Request a string from the user
        
        CAKE.StringRequest( "Question", 
                                        "What Is Your Favourite Color?", 
                                        "Type your answer here!", 
                                        function( strTextOut ) CAKE.Message( "Your Favourite Color Is: " .. strTextOut ) end,
                                        function( strTextOut ) CAKE.Message( "You pressed Cancel!" ) end,
                                        "Okey Dokey", 
                                        "Cancel" )
        
*/
function CAKE.StringRequest( strTitle, strText, strDefaultText, fnEnter, fnCancel, strButtonText, strButtonCancelText, color )
 
        local Window = vgui.Create( "DFrameTransparent" )
                Window:SetTitle( strTitle or "Message Title (First Parameter)" )
                Window:SetDraggable( false )
                Window:ShowCloseButton( false )
                if color then
                    Window:SetColor( color )
                else
                    Window:SetColor( CAKE.BaseColor )
                end
                
        local InnerPanel = vgui.Create( "DPanel", Window )
        
        local Text = vgui.Create( "DLabel", InnerPanel )
                Text:SetText( strText or "Message Text (Second Parameter)" )
                Text:SizeToContents()
                Text:SetContentAlignment( 5 )
                Text:SetTextColor( color_white )
                
        local TextEntry = vgui.Create( "DTextEntry", InnerPanel )
                TextEntry:SetText( strDefaultText or "" )
                TextEntry.OnEnter = function() Window:Close() fnEnter( TextEntry:GetValue() ) end
                
        local ButtonPanel = vgui.Create( "DPanel", Window )
        ButtonPanel:SetTall( 30 )
                
        local Button = vgui.Create( "DButton", ButtonPanel )
                Button:SetText( strButtonText or "OK" )
                Button:SizeToContents()
                Button:SetTall( 20 )
                Button:SetWide( Button:GetWide() + 20 )
                Button:SetPos( 5, 5 )
                Button.DoClick = function() Window:Close() fnEnter( TextEntry:GetValue() ) end
                
        local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
                ButtonCancel:SetText( strButtonCancelText or "Cancel" )
                ButtonCancel:SizeToContents()
                ButtonCancel:SetTall( 20 )
                ButtonCancel:SetWide( Button:GetWide() + 20 )
                ButtonCancel:SetPos( 5, 5 )
                ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( TextEntry:GetValue() ) end end
                ButtonCancel:MoveRightOf( Button, 5 )
                
        ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
        
        local w, h = Text:GetSize()
        w = math.max( w, 400 ) 
        
        Window:SetSize( w + 50, h + 25 + 75 + 10 )
        Window:Center()
        
        InnerPanel:StretchToParent( 5, 25, 5, 45 )
        
        Text:StretchToParent( 5, 5, 5, 35 )     
        
        TextEntry:StretchToParent( 5, nil, 5, nil )
        TextEntry:AlignBottom( 5 )
        
        TextEntry:RequestFocus()
        TextEntry:SelectAllText( true )
        
        ButtonPanel:CenterHorizontal()
        ButtonPanel:AlignBottom( 8 )
        
        Window:MakePopup()
 
end

function CAKE.ChoiceRequest( strTitle, strText, tbl, fnEnter, fnCancel, strButtonText, strButtonCancelText, color )
        
        local choice

        local Window = vgui.Create( "DFrameTransparent" )
                Window:SetTitle( strTitle or "Message Title (First Parameter)" )
                Window:SetDraggable( false )
                Window:ShowCloseButton( false )
                if color then
                    Window:SetColor( color )
                else
                    Window:SetColor( CAKE.BaseColor )
                end
                
        local InnerPanel = vgui.Create( "DPanel", Window )
        
        local Text = vgui.Create( "DLabel", InnerPanel )
                Text:SetText( strText or "Message Text (Second Parameter)" )
                Text:SizeToContents()
                Text:SetContentAlignment( 5 )
                Text:SetTextColor( color_white )
                
        local MultiChoice = vgui.Create( "DMultiChoice", InnerPanel )
                choice = tbl[1]
                for k, v in pairs( tbl ) do
                    MultiChoice:AddChoice( v )
                end
                MultiChoice.OnSelect = function(panel,index,value) choice = value end
                MultiChoice:SizeToContents()
                
        local ButtonPanel = vgui.Create( "DPanel", Window )
        ButtonPanel:SetTall( 30 )
                
        local Button = vgui.Create( "DButton", ButtonPanel )
                Button:SetText( strButtonText or "OK" )
                Button:SizeToContents()
                Button:SetTall( 20 )
                Button:SetWide( Button:GetWide() + 20 )
                Button:SetPos( 5, 5 )
                Button.DoClick = function() Window:Close() fnEnter( MultiChoice:GetValue() ) end
                
        local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
                ButtonCancel:SetText( strButtonCancelText or "Cancel" )
                ButtonCancel:SizeToContents()
                ButtonCancel:SetTall( 20 )
                ButtonCancel:SetWide( Button:GetWide() + 20 )
                ButtonCancel:SetPos( 5, 5 )
                ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( choice ) end end
                ButtonCancel:MoveRightOf( Button, 5 )
                
        ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
        
        local w, h = Text:GetSize()
        w = math.max( w, 400 ) 
        
        Window:SetSize( w + 50, h + 25 + 75 + 10 )
        Window:Center()
        
        InnerPanel:StretchToParent( 5, 25, 5, 45 )
        
        Text:StretchToParent( 5, 5, 5, 35 )     
        
        MultiChoice:StretchToParent( 5, nil, 5, nil )
        MultiChoice:AlignBottom( 5 )
        
        ButtonPanel:CenterHorizontal()
        ButtonPanel:AlignBottom( 8 )
        
        Window:MakePopup()
 
end
