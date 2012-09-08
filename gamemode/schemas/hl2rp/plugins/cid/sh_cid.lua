if SERVER then

	function TIRA.SetCID( ply )
		if TIRA.GetCharField( ply, "cid" ) == "000000" then
			local cid = math.random( 0, 9) .. math.random( 0, 9) .. math.random( 0, 9) .. math.random( 0, 9) .. math.random( 0, 9) .. math.random( 1, 9)
			TIRA.SetCharField( ply, "cid", cid)
			ply:SetNWString( "cid", cid )
		end
	end

	concommand.Add( "rp_setcid", function( ply, cmd, args )
		TIRA.SetCID( ply )
	end)

	hook.Add( "PlayerSpawn", "HL2RPSendCID", function( ply )
		if ply:IsCharLoaded() then
			ply:SetNWString( "cid", TIRA.GetCharField( ply, "cid" ) )
		end
	end)

else

	local struc = {}
	struc.pos = { ScrW(), ScrH() - 20 } -- Pos x, y
	struc.color = Color(230,230,230,255 ) -- Red
	struc.font = "Tiramisu18Font" -- Font
	struc.xalign = TEXT_ALIGN_RIGHT -- Horizontal Alignment
	struc.yalign = TEXT_ALIGN_LEFT -- Vertical Alignment

	hook.Add( "HUDPaint", "HL2RPDrawCID", function()
		if TIRA.MenuOpen then
			struc.text = "CID: " .. LocalPlayer():GetNWString( "cid", "000000" )
			draw.Text( struc )
		end
	end)

end