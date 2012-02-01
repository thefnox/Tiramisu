CAKE.SelectedChar = false
ExistingChars = {  }

local x,y 
local charpanel

function OpenCharacterMenu( hideclosebutton )
	
	CAKE.EnableBlackScreen( true )

	if !CharacterMenu then
		CharacterMenu = vgui.Create( "DFrame" )
		CharacterMenu:SetSize( ScrW(), ScrH() )
		CharacterMenu:Center()
		CharacterMenu:SetDraggable( false )
		CharacterMenu:ShowCloseButton( true )
		CharacterMenu:SetTitle( "" )
		CharacterMenu.Paint = function()

			CAKE.DrawBlurScreen()

		end
		CharacterMenu:MakePopup()

		local titlelabel = vgui.Create( "DLabel", CharacterMenu )
		titlelabel:SetText( CAKE.ConVars[ "IntroText" ] )
		titlelabel:SetFont( "Tiramisu64Font" )
		titlelabel:SizeToContents()
		titlelabel:SetPos( 20, 20 )

		local subtitlelabel = vgui.Create( "DLabel", CharacterMenu )
		subtitlelabel:SetText( CAKE.ConVars[ "IntroSubtitle" ] )
		subtitlelabel:SetFont( "Tiramisu32Font" )
		subtitlelabel:SizeToContents()
		subtitlelabel:SetPos( 20, 30 + titlelabel:GetTall() )

		PlayerModel = vgui.Create( "PlayerPanel", CharacterMenu )
		PlayerModel:SetSize( ScrH(), ScrH())
		PlayerModel:SetPos( ScrW() - ScrH() , 0 )
		PlayerModel.PaintOver = function()
			if PlayerModel.SlideOut then
				x, y = PlayerModel:GetPos()
				PlayerModel:SetPos( Lerp( RealFrameTime() * 3, x, ScrH() ), 0 )
			else
				x, y = PlayerModel:GetPos()
				PlayerModel:SetPos( Lerp( RealFrameTime() * 3, x,  ScrW() - ScrH() ), 0)
			end
		end
	else
		if PlayerModel then
			PlayerModel.SlideOut = false
		end
	end

	RunConsoleCommand( "rp_receivechars" )
	CreateMenuButtons( !hideclosebutton )

end

function CreateCharList( )

	if CharacterMenu then
		if charpanel then
			charpanel:Remove()
			charpanel = nil
		end

		charpanel = vgui.Create( "DPanelList", CharacterMenu )
		charpanel:SetSize( ScrW() - ScrH() - 100, ScrH() - 270 )
		charpanel:SetPos( 100, 170 )
		charpanel:SetSpacing( 5 )
		charpanel:SetAutoSize( false )
		charpanel:EnableVerticalScrollbar( true )
		charpanel.Paint = function()
		end

		for k, v in pairs(ExistingChars) do

			local charbutton = vgui.Create( "DButton" )
			charbutton:SetTall( 50 )
			charbutton.DoClick = function()
				RunConsoleCommand("rp_selectchar", tostring( k ))
				CAKE.SelectedChar = k
			end
			charbutton:SetText("")
			charbutton.Paint = function()
				surface.SetDrawColor(Color(30, 30, 30, 250 ))
				surface.DrawRect( 0, 0, charbutton:GetSize())
			end

			local namelabel = vgui.Create( "DLabel", charbutton )
			namelabel:SetSize( ScrW() - ScrH() - 140, 33 )
			namelabel:SetPos( 10, 10 )
			namelabel:SetText( v['name'] )
			namelabel:SetFont("Tiramisu32Font")

			local deletebutton = vgui.Create( "DButton", charbutton )
			deletebutton:SetSize( 32, 32 )
			deletebutton:SetPos( ScrW() - ScrH() - 136, 4 )
			deletebutton:SetText("")
			deletebutton.Paint = function()
				surface.SetDrawColor(Color(0, 0, 0, 250 ))
				surface.SetTexture()
				surface.DrawTexturedRectRotated( 15, 22, 20, 8, 45 )
				surface.DrawTexturedRectRotated( 15, 22, 20, 8, 135 )
			end

			deletebutton.DoClick = function()
				RunConsoleCommand("rp_confirmremoval", tostring( k ))
			end

			charpanel:AddItem(charbutton)

		end
	end
end

function CreateMenuButtons( canclose )
	local closelabel
	local spawnlabel = vgui.Create( "DButton", CharacterMenu )
	spawnlabel:SetSize( 80, 26 )
	spawnlabel:SetText( "" )
	spawnlabel:SetPos(  260, ScrH() - 85 )
	spawnlabel.Paint = function() end
	spawnlabel.PaintOver = function()
		surface.SetFont("Tiramisu24Font")
		surface.SetDrawColor(Color(30, 30, 30, 150 ))
		surface.DrawRect( 0, 0, surface.GetTextSize(" Spawn "))
		draw.SimpleText( " Spawn ", "Tiramisu24Font", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
	end
	spawnlabel.DoClick = function()
		if CAKE.SelectedChar then
			RunConsoleCommand( "rp_spawnchar", tostring( CAKE.SelectedChar ))
			CloseCharacterMenu()
		else
			CAKE.Message( "You need to select a character first!", "Warning", "OK", Color( 140, 100, 100) )
		end
	end

	local disconnectlabel = vgui.Create( "DButton", CharacterMenu )
	disconnectlabel:SetSize( 80, 26 )
	disconnectlabel:SetText( "" )
	disconnectlabel:SetPos( 160, ScrH() - 85 )
	disconnectlabel.Paint = function() end
	disconnectlabel.PaintOver = function()
		surface.SetFont("Tiramisu24Font")
		surface.SetDrawColor(Color(30, 30, 30, 150 ))
		surface.DrawRect( 0, 0, surface.GetTextSize(" Disconnect "))
		draw.SimpleText( " Disconnect ", "Tiramisu24Font", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
	end
	disconnectlabel.DoClick = function()
		RunConsoleCommand( "disconnect" )
	end

	local createcharacter = vgui.Create( "DButton", CharacterMenu )
	createcharacter:SetText( "" )
	createcharacter:SetSize( 200, 26 )
	createcharacter:SetColor(Color( 200, 255, 200 ))
	createcharacter:SetPos( 340, ScrH() - 85 )
	createcharacter.Paint = function() end
	createcharacter.PaintOver = function()
		surface.SetFont("Tiramisu24Font")
		surface.SetDrawColor(Color(30, 30, 30, 150 ))
		surface.DrawRect( 0, 0, surface.GetTextSize(" Create New Character "))
		draw.SimpleText( " Create New Character ", "Tiramisu24Font", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
	end
	createcharacter.DoClick = function()
		PlayerModel.SlideOut = true
		if closelabel then
			closelabel.SlideOut = true
		end
		RunConsoleCommand( "rp_begincreate" )
	end 

	local x, y 
	introlabel = vgui.Create( "DButton", CharacterMenu )
	introlabel:SetSize( 80, 26 )
	introlabel:SetText( "" )
	introlabel:SetPos( ScrW() - 80, ScrH() - 30 )
	introlabel.Paint = function() end
	introlabel.PaintOver = function()
		surface.SetFont("Tiramisu24Font")
		surface.SetDrawColor(Color(30, 30, 30, 150 ))
		surface.DrawRect( 0, 0, surface.GetTextSize(" Play Intro "))
		draw.SimpleText( " Play Intro ", "Tiramisu24Font", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
	end
	introlabel.DoClick = function()
		CAKE.EnableBlackScreen( true, true )
		CAKE.StartIntro( canclose )
		if CharacterMenu then
			PlayerModel:Close()
			CharacterMenu:Remove()
			CharacterMenu = nil
		end
	end

	if canclose then
		local x, y 
		closelabel = vgui.Create( "DButton", CharacterMenu )
		closelabel:SetSize( 80, 26 )
		closelabel:SetText( "" )
		closelabel:SetPos( (ScrW() / 2 )- 40, ScrH() - 85  )
		closelabel.Paint = function() end
		closelabel.PaintOver = function()
			surface.SetFont("Tiramisu24Font")
			surface.SetDrawColor(Color(30, 30, 30, 150 ))
			surface.DrawRect( 0, 0, surface.GetTextSize(" Close Menu "))
			draw.SimpleText( " Close Menu ", "Tiramisu24Font", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
		end
		closelabel.DoClick = function()
			CloseCharacterMenu()
		end
	end

end

function CloseCharacterMenu()
	CAKE.EnableBlackScreen( false )
	if CharacterMenu then
		PlayerModel:Close()
		CharacterMenu:Remove()
		CharacterMenu = nil
	end
end
CAKE.RegisterMenuTab( "Characters", OpenCharacterMenu, CloseCharacterMenu )

usermessage.Hook( "ConfirmCharRemoval", function( um )

	local namestr = um:ReadString()
	local id = um:ReadLong()

	CAKE.Query( "Are you sure you want to delete " .. namestr .. "? (Cannot be undone)", "Confirm Character Removal",
		"Confirm", function()
			LocalPlayer():ConCommand("rp_removechar " .. tostring( id ))
			table.remove( ExistingChars, id )
		end,  
		"Cancel", function()
		 end )
end)

usermessage.Hook( "DisplayCharacterList", function( um )
	CreateCharList( )
end)

usermessage.Hook( "Tiramisu.InitialSpawn",  function( um )

	local useintro = um:ReadBool()

	if !useintro and !CAKE.AlwaysIntro:GetBool() then
		OpenCharacterMenu( true )
	else
		if CAKE.ConVars[ "UseIntro" ] then
			CAKE.StartIntro( false )
		else
			CAKE.EndIntro()
		end
	end
	
end )

usermessage.Hook( "StartCharacterCreation", function()
	
	derma.SkinHook( "Layout", "CharacterCreation" )

end)

usermessage.Hook( "ClearReceivedChars", function()
	ExistingChars = {}
end)

usermessage.Hook( "ReceiveChar", function( data )
	local n = data:ReadLong( )
	ExistingChars[ n ] = {  }
	ExistingChars[ n ][ 'name' ] = data:ReadString( )
	ExistingChars[ n ][ 'model' ] = data:ReadString( )
	ExistingChars[ n ][ 'title' ] = data:ReadString( )
end)