datastream.Hook( "Tiramisu.WriteNote", function( ply, handler, id, encoded, decoded )

	local paper = ply:HasItem("paper")
	if ply:HasItem("paper") and CAKE.GetUData(paper, "uses") and CAKE.GetUData(paper, "uses") > 0 then
		local uses = CAKE.GetUData(paper, "uses") - 1
		if uses < 1 then
			ply:TakeItemID(paper)
		else 
			CAKE.SetUData(paper, "uses", uses)
			CAKE.SetUData(paper, "name", "Paper (" .. uses .. " uses left)")
			ply:RefreshInventory()
		end
		local note = CAKE.CreateItem("note", ply:CalcDrop(), Angle(0, 0, 0))
		timer.Simple( 0, function()
			CAKE.SetUData( note:GetNWString("id"), "name", decoded["title"] )
			CAKE.SetUData( note:GetNWString("id"), "text", decoded["text"] )
		end)
	else
		CAKE.SendError( ply, "You don't have any paper!" )
	end

end )