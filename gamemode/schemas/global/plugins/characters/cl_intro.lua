function CAKE.InitIntro()
	local titlelabel
	local subtitlelabel
	CharacterMenu = vgui.Create( "DFrame" )
	CharacterMenu:SetSize( ScrW(), ScrH() )
	CharacterMenu:SetPos( 0, 0 )
	CharacterMenu:SetDraggable( false )
	CharacterMenu:ShowCloseButton( false )
	CharacterMenu:SetTitle( "" )
	CharacterMenu.PaintOver = function()
		--Derma_DrawBackgroundBlur( CharacterMenu, 0 )
		if !CharacterMenu.Alpha then
			CharacterMenu.Alpha = 255
		end
		if CharacterMenu.FadeOut then
			CharacterMenu.Alpha = Lerp( 0.1, CharacterMenu.Alpha, 0 )
			if CharacterMenu.Alpha < 5 then
				CharacterMenu.Alpha = 0
				CharacterMenu.FadeOut = false
				--Not the best place to put this, but it works.
				RunConsoleCommand( "rp_receivechars" )
				PlayerModel = vgui.Create( "PlayerPanel", CharacterMenu )
				PlayerModel:SetSize( 500, 500 )
				PlayerModel:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 300 )
				PlayerModel.PaintOver = function()
					if PlayerModel.SlideOut then
						x, y = PlayerModel:GetPos()
						PlayerModel:SetPos( Lerp( 0.1, x, ScrW() / 2 - 400 ), ScrH() / 2 - 300 )
					else
						x, y = PlayerModel:GetPos()
						PlayerModel:SetPos( Lerp( 0.1, x, ScrW() / 2 - 100 ), ScrH() / 2 - 300 )
					end
				end
				timer.Simple( 0.2, function()
					CreateMenuButtons()
				end)
			end
		end
		surface.SetDrawColor( 0, 0, 0, CharacterMenu.Alpha) --Red
		surface.DrawRect(0, 0, ScrW(), ScrH() )
	end
	CharacterMenu:MakePopup()

	titlelabel = vgui.Create( "DLabel", CharacterMenu )
	titlelabel:SetText( CAKE.ConVars[ "IntroText" ] )
	titlelabel:SetFont( "Tiramisu32Font" )
	titlelabel:SizeToContents()
	titlelabel:SetPos( ScrW() / 2 - titlelabel:GetWide() / 2, -100 )

	subtitlelabel = vgui.Create( "DLabel", CharacterMenu )
	subtitlelabel:SetText( CAKE.ConVars[ "IntroSubtitle" ] )
	subtitlelabel:SetFont( "Tiramisu14Font" )
	subtitlelabel:SizeToContents()
	subtitlelabel:SetPos( ScrW() / 2 - subtitlelabel:GetWide() / 2 + 46, -68 )

	titlelabel:SetPos( ScrW() / 2 - titlelabel:GetWide() / 2, -100 )
	timer.Simple( 1, function()
		local x, y
		titlelabel.PaintOver = function()
			x,y = titlelabel:GetPos()
			if titlelabel.FadeOut then
				titlelabel:SetPos( x, Lerp( 0.03, y, 70 ))
			else
				titlelabel:SetPos( x, math.Clamp( y + 4, -100, ScrH() / 2 - 13 ))
			end
		end

		subtitlelabel.PaintOver = function()
			x,y = subtitlelabel:GetPos()
			if subtitlelabel.FadeOut then
				x,y = subtitlelabel:GetPos()
				subtitlelabel:SetPos( x, Lerp( 0.03, y, 103 ))
			else
				subtitlelabel:SetPos( x, math.Clamp( y + 4, -100, ScrH() / 2 + 20 ))
			end
		end
	end)
	
	timer.Simple( 4, function()
		titlelabel.FadeOut = true
		subtitlelabel.FadeOut = true
		CharacterMenu.FadeOut = true
	end)

end