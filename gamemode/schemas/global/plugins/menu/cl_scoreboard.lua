local function OpenScoreboard()

	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 540, 400 )
	PlayerMenu:SetTitle( "Scoreboard" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()

	local title = Label( GetHostName(), PlayerMenu)
	title:SetFont( "Tiramisu48Font")
	title:SetPos( 10, 23 )
	title:SizeToContents()

	local subtitle = Label( "Your ping: " .. LocalPlayer():Ping(), PlayerMenu)
	subtitle:SetPos( 10, 66 )
	subtitle:SetFont( "Tiramisu24Font")
	subtitle:SizeToContents()
	subtitle.PaintOver = function()
		subtitle:SetText("Your ping: " .. LocalPlayer():Ping())
	end
	
	Scoreboard = vgui.Create( "DPanelList", PlayerMenu )
	Scoreboard:Dock(FILL)
	Scoreboard:DockMargin( 0, 70, 0, 0 )
	Scoreboard:SetPadding(5)
	Scoreboard:SetSpacing(2)
	Scoreboard:EnableVerticalScrollbar( true )
	-- Let's draw the SCOREBOARD.
	
	local players = {}
	local i = 0 
	for _, ply in pairs(player.GetAll()) do
		i = i + 1
		players[i] = vgui.Create("DPanel")
		players[i]:SetTall(72)
		players[i].Paint = function()
			surface.SetDrawColor(Color( 50, 50, 50, 230 ))
			surface.DrawRect( 0, 0, players[i]:GetWide(), players[i]:GetTall() )
			surface.SetDrawColor(Color( 0, 0, 0, 230 ))
			surface.DrawOutlinedRect( 0, 0, players[i]:GetWide(), players[i]:GetTall() )
		end

		local avatar = vgui.Create( "AvatarImage" )
		avatar:SetParent( players[i] )
		avatar:SetPlayer(ply, 64)
		avatar:Dock(LEFT)
		avatar:DockMargin( 2, 2, 2, 2 )
		avatar:SetTall(64)

		local TitlePanel = vgui.Create("DPanelList", players[i])
		TitlePanel:Dock( FILL )
		TitlePanel:DockMargin( 2, 2, 2, 2 )
		TitlePanel:SetTall(70)
		TitlePanel.Paint = function() end

		local namelabel = Label(ply:Nick() .. " (" .. ply:Name() .. ")")
		namelabel:SetFont("Tiramisu18Font")
		namelabel.PaintOver = function()
			namelabel:SetText(ply:Nick() .. " (" .. ply:Name() .. ")")
		end
		TitlePanel:AddItem(namelabel)

		local titlelabel = Label(ply:Title())
		titlelabel:SetFont("Tiramisu18Font")
		titlelabel.PaintOver = function()
			titlelabel:SetText(ply:Title())
		end
		TitlePanel:AddItem(titlelabel)

		local pinglabel = Label("Ping:" .. ply:Ping())
		pinglabel:SetFont("Tiramisu18Font")
		pinglabel.PaintOver = function()
			pinglabel:SetText("Ping:" .. ply:Ping())
		end
		TitlePanel:AddItem(pinglabel)


		Scoreboard:AddItem(players[i])
	end
	

end

local function CloseScoreboard()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Scoreboard", OpenScoreboard, CloseScoreboard )

usermessage.Hook( "showscoreboard", function( um )
	
	OpenScoreboard()
	
end)