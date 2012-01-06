CAKE.SelectedChar = false
ExistingChars = {  }

local x,y 
local charpanel

function OpenCharacterMenu( hideclosebutton )

	RunConsoleCommand( "rp_thirdperson", 1 )

	if !CharacterMenu then
		CharacterMenu = vgui.Create( "DFrame" )
		CharacterMenu:SetSize( ScrW(), ScrH() )
		CharacterMenu:Center()
		CharacterMenu:SetDraggable( false )
		CharacterMenu:ShowCloseButton( false )
		CharacterMenu:SetTitle( "" )
		CharacterMenu.Paint = function()

			CAKE.DrawBlurScreen()

		end
		CharacterMenu:MakePopup()

		local titlelabel = vgui.Create( "DLabel", CharacterMenu )
		titlelabel:SetText( CAKE.IntroText )
		titlelabel:SetFont( "Tiramisu32Font" )
		titlelabel:SizeToContents()
		titlelabel:SetPos( ScrW() / 2 - titlelabel:GetWide() / 2, 0 )
		local x, y
		titlelabel.PaintOver = function()
			x,y = titlelabel:GetPos()
			titlelabel:SetPos( x, Lerp( RealFrameTime() * 12, y, 70 ))
		end

		local subtitlelabel = vgui.Create( "DLabel", CharacterMenu )
		subtitlelabel:SetText( CAKE.IntroSubtitle )
		subtitlelabel:SetFont( "Tiramisu14Font" )
		subtitlelabel:SizeToContents()
		subtitlelabel:SetPos( ScrW() / 2 - subtitlelabel:GetWide() / 2 + 46, 0 )
		subtitlelabel.PaintOver = function()
			x,y = subtitlelabel:GetPos()
			subtitlelabel:SetPos( x, Lerp( RealFrameTime() * 12, y, 103 ))
		end


		PlayerModel = vgui.Create( "PlayerPanel", CharacterMenu )
		PlayerModel:SetSize( 500, 500 )
		PlayerModel:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 300 )
		PlayerModel.PaintOver = function()
			if PlayerModel.SlideOut then
				x, y = PlayerModel:GetPos()
				PlayerModel:SetPos( Lerp( RealFrameTime() * 10, x, ScrW() / 2 - 400 ), ScrH() / 2 - 300 )
			else
				x, y = PlayerModel:GetPos()
				PlayerModel:SetPos( Lerp( RealFrameTime() * 10, x, ScrW() / 2 - 100 ), ScrH() / 2 - 300 )
			end
		end
	else
		if PlayerModel then
			PlayerModel.SlideOut = false
		end
	end

	CreateCharList( )
	CreateMenuButtons( !hideclosebutton )

end

function CreateCharList( )

		if CharacterMenu then
			if charpanel then
				charpanel:Remove()
				charpanel = nil
			end

			charpanel = vgui.Create( "DPanelList", CharacterMenu )
			charpanel:SetSize( 210, 500 )
			charpanel:SetPos( -500, ScrH() / 2 - 500 )
			charpanel:SetAutoSize( false )
			charpanel:EnableVerticalScrollbar( true )
			charpanel.Paint = function()
			end
			charpanel.Think = function()
				x,y = charpanel:GetPos()
				if !charpanel.SlideOut then
					charpanel:SetPos( Lerp( RealFrameTime() * 10, x, ScrW() / 2 - 330 ),ScrH() / 2 - 270 )
				else
					charpanel:SetPos( Lerp( RealFrameTime() * 10, x, -500 ),ScrH() / 2 - 270 )
					if x < 0 then
						charpanel:Remove()
						charpanel = nil		
					end
				end
			end


			for k, v in pairs(ExistingChars) do

				local plist = vgui.Create("DPanelList")
				plist:SetAutoSize( false )
				plist:SetSize( 185, 85 )

				local ccategory = vgui.Create("DCollapsibleCategory")
				ccategory:SetExpanded( 1 )
				ccategory:SetLabel( v['name'] )

				local spawnicon = vgui.Create( "SpawnIcon")
				spawnicon:SetModel( v['model'] )
				spawnicon:SetSize( 64, 64 )
				plist:AddItem(spawnicon)

				local plist2 = vgui.Create( "DPanelList" )
				plist2:EnableHorizontal( true )
				plist2:SetAutoSize( true )

				local title = vgui.Create("MarkupLabel")
				title:SetText(v['title'])
				title:SetMaxSize( 110, 58 )
				plist2:AddItem(title)

				local plist3 = vgui.Create( "DPanelList" )
				plist3:SetSpacing( 5 )
				plist3:SetPadding( 3 )
				plist3:EnableHorizontal( true )
				plist3:SetAutoSize( true )

				local selectchar = vgui.Create( "DButton" )
				selectchar:SetSize( 90, 20 )
				selectchar:SetText( "Select" )
				selectchar.DoClick = function()
					LocalPlayer():ConCommand("rp_selectchar " .. tostring( k ))
					CAKE.SelectedChar = k
				end
				plist3:AddItem( selectchar )

				local deletechar = vgui.Create( "DButton" )
				deletechar:SetSize( 90, 20 )
				deletechar:SetText( "Delete")
				deletechar.DoClick = function()
					LocalPlayer():ConCommand("rp_confirmremoval " .. tostring( k ))
				end
				plist3:AddItem( deletechar )

				local divider = vgui.Create("DHorizontalDivider")
				divider:SetLeft(spawnicon)
				divider:SetRight(plist2)
				divider:SetLeftWidth(64)
				divider:SetHeight(64)

				local vdivider = vgui.Create("DVerticalDivider")
				vdivider:SetTop(divider)
				vdivider:SetBottom(plist3)
				vdivider:SetTopHeight(68)

				plist:AddItem(spawnicon)
				plist:AddItem(plist3)
				plist:AddItem(plist2)
				plist:AddItem(divider)
				plist:AddItem(vdivider)

				ccategory:SetContents(plist)
				charpanel:AddItem(ccategory)

		end
	end
end

function CreateMenuButtons( canclose )
	local spawnlabel = vgui.Create( "DButton", CharacterMenu )
	spawnlabel:SetSize( 80, 26 )
	spawnlabel:SetText( "" )
	spawnlabel:SetPos( (ScrW() / 2 )- 60, ScrH() + 500  )
	spawnlabel.Paint = function() end
	spawnlabel.PaintOver = function()
		draw.SimpleText( "Spawn", "Tiramisu18Font", 40, 0, Color(255,255,255), TEXT_ALIGN_CENTER )
		x,y = spawnlabel:GetPos()
		if !spawnlabel.SlideOut then
			spawnlabel:SetPos( (ScrW() / 2 )- 60, Lerp( RealFrameTime() * 10, y, ScrH() / 2 + 200 ))
		else
			spawnlabel:SetPos( (ScrW() / 2 )- 60, Lerp( RealFrameTime() * 10, y, ScrH() + 500 ))
			if y > ScrH() then
				spawnlabel:Remove()
				spawnlabel = nil
			end
		end
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
	disconnectlabel:SetPos( (ScrW() / 2 )- 160, ScrH() + 500  )
	disconnectlabel.Paint = function() end
	disconnectlabel.PaintOver = function()
		draw.SimpleText( "Disconnect", "Tiramisu18Font", 40, 0, Color(255,255,255), TEXT_ALIGN_CENTER )
		x,y = disconnectlabel:GetPos()
		if !disconnectlabel.SlideOut then
			disconnectlabel:SetPos( (ScrW() / 2 )- 160, Lerp( RealFrameTime() * 10, y, ScrH() / 2 + 200 ))
		else
			disconnectlabel:SetPos( (ScrW() / 2 )- 160, Lerp( RealFrameTime() * 10, y, ScrH() + 500  ))
			if y > ScrH() then
				disconnectlabel:Remove()
				disconnectlabel = nil
			end
		end
	end
	disconnectlabel.DoClick = function()
		RunConsoleCommand( "disconnect" )
	end

	local createcharacter = vgui.Create( "DButton", CharacterMenu )
	createcharacter:SetText( "" )
	createcharacter:SetSize( 200, 26 )
	createcharacter:SetColor(Color( 200, 255, 200 ))
	createcharacter:SetPos( (ScrW() / 2 ) + 20, ScrH() + 500  )
	createcharacter.Paint = function() end
	createcharacter.PaintOver = function()
		draw.SimpleText( "Create New Character", "Tiramisu18Font", 100, 0, Color(255,255,255), TEXT_ALIGN_CENTER )
		x,y = createcharacter:GetPos()
		if !createcharacter.SlideOut then
			createcharacter:SetPos( (ScrW() / 2 ) + 20, Lerp( RealFrameTime() * 10, y, ScrH() / 2 + 200 ))
		else
			createcharacter:SetPos( (ScrW() / 2 ) + 20, Lerp( RealFrameTime() * 10, y, ScrH() + 500 ))
			if y > ScrH() then
				createcharacter:Remove()
				createcharacter = nil
			end
		end
	end
	createcharacter.DoClick = function()
		spawnlabel.SlideOut = true
		disconnectlabel.SlideOut = true
		createcharacter.SlideOut = true
		charpanel.SlideOut = true
		PlayerModel.SlideOut = true
		RunConsoleCommand( "rp_begincreate" )
	end 

	if canclose then
		local x, y 
		local closelabel = vgui.Create( "DButton", CharacterMenu )
		closelabel:SetSize( 80, 26 )
		closelabel:SetText( "" )
		closelabel:SetPos( (ScrW() / 2 )- 60, ScrH() + 500  )
		closelabel.Paint = function() end
		closelabel.PaintOver = function()
			draw.SimpleText( "Close Menu", "Tiramisu18Font", 40, 0, Color(255,255,255), TEXT_ALIGN_CENTER )
			x,y = closelabel:GetPos()
			if !createcharacter.SlideOut then
				closelabel:SetPos( (ScrW() / 2 )- 40, Lerp( RealFrameTime() * 10, y, ScrH() / 2 + 250 ))
			else
				closelabel:SetPos( (ScrW() / 2 )- 40, Lerp( RealFrameTime() * 10, y, ScrH() / 2 + 500 ))
				if y > ScrH() then
					closelabel:Remove()
					closelabel = nil
				end
			end
		end
		closelabel.DoClick = function()
			CloseCharacterMenu()
		end
	end

end

function CloseCharacterMenu()
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

usermessage.Hook( "characterselection",  function( um )

	local useintro = um:ReadBool()

	if !useintro then
		OpenCharacterMenu( true )
	else
		if CAKE.InitIntro then
			CAKE.InitIntro()
		else
			OpenCharacterMenu( true )
		end
	end
	
end )

usermessage.Hook( "charactercreation", function()
	
	CAKE.CharCreate()

end)


local function ReceiveChar( data )

	local n = data:ReadLong( )
	ExistingChars[ n ] = {  }
	ExistingChars[ n ][ 'name' ] = data:ReadString( )
	ExistingChars[ n ][ 'model' ] = data:ReadString( )
	ExistingChars[ n ][ 'title' ] = data:ReadString( )
	
end
usermessage.Hook( "ReceiveChar", ReceiveChar )