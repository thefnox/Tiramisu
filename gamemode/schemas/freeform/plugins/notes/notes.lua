datastream.Hook( "Tiramisu.WriteNote", function( ply, handler, id, encoded, decoded )

	local note = CAKE.CreateItem("note", ply:CalcDrop(), Angle(0, 0, 0))
	timer.Simple( 0, function()
		CAKE.SetUData( note:GetNWString("id"), "name", decoded["title"] )
		CAKE.SetUData( note:GetNWString("id"), "text", decoded["text"] )
	end)

end )