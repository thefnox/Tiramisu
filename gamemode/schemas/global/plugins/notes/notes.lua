datastream.Hook( "Tiramisu.WriteNote", function( ply, handler, id, encoded, decoded )

	local note = TIRA.CreateItem("note", ply:CalcDrop(), Angle(0, 0, 0))
	timer.Simple( 0, function()
		TIRA.SetUData( note:GetNWString("id"), "name", decoded["title"] )
		TIRA.SetUData( note:GetNWString("id"), "text", decoded["text"] )
	end)

end )

function TIRA.StartWrite( ply, paper )
	if TIRA.GetUData(paper, "uses") and TIRA.GetUData(paper, "uses") > 0 then
		local uses = TIRA.GetUData(paper, "uses") - 1
		TIRA.SetUData(paper, "uses", uses)
		TIRA.SetUData(paper, "name", "Paper (" .. uses .. " uses left)")
		if ply:HasItemID(paper) then
			if uses < 1 then
				ply:TakeItemID(paper)
			else
				TIRA.SendUData( ply, paper )
			end
		end
		umsg.Start("Tiramisu.StartWrite", ply)
		umsg.End()
	else
		TIRA.SendError( ply, "You can use this paper no longer!" )
	end
end