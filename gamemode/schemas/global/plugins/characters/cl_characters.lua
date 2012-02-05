CAKE.SelectedChar = false
CAKE.CurrentChar = false
ExistingChars = {  }

function OpenCharacterMenu( hideclosebutton )
	derma.SkinHook( "Layout", "CharacterSelection", hideclosebutton )
end

function CloseCharacterMenu()
	derma.SkinHook( "Close", "CharacterSelection")
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
	derma.SkinHook( "Layout", "CharacterList")
end)

usermessage.Hook( "Tiramisu.InitialSpawn",  function( um )

	local useintro = um:ReadBool()

	if !useintro and !CAKE.AlwaysIntro:GetBool() then
		derma.SkinHook( "Layout", "CharacterSelection", true )
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

usermessage.Hook( "SelectThisCharacter", function( data )
	CAKE.SelectedChar = data:ReadLong( )
	if CharacterMenu and ExistingChars[CAKE.SelectedChar] then
		if !CharTitleLabel then
			CharTitleLabel = Label( ExistingChars[CAKE.SelectedChar]["name"] or "Loading...", CharacterMenu)
			CharTitleLabel:SetFont( "Tiramisu24Font")
			CharTitleLabel:SizeToContents()
			CharTitleLabel:SetPos( ScrW() - ScrH() / 2 - CharTitleLabel:GetWide() / 2, ScrH() - 130 )
			CharacterMenu.AddChild( CharTitleLabel )
		else
			CharTitleLabel:SetText( ExistingChars[CAKE.SelectedChar]["name"] or "Loading..." )
			CharTitleLabel:SizeToContents()
			CharTitleLabel:SetPos( ScrW() - ScrH() / 2 - CharTitleLabel:GetWide() / 2, ScrH() - 130 )
			CharTitleLabel.OriginalPosX, CharTitleLabel.OriginalPosY = CharTitleLabel:GetPos()
		end
	end
end)

usermessage.Hook( "ReceiveChar", function( data )
	local n = data:ReadLong( )
	ExistingChars[ n ] = {  }
	ExistingChars[ n ][ 'name' ] = data:ReadString( )
end)