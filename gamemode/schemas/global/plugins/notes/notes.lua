function write( ply, handler, id, encoded, decoded )
	paper = ply:HasItem("paper")
	if paper and CAKE.GetUData(paper, "uses") > 0 then
		uses = CAKE.GetUData(paper, "uses") - 1
		if uses < 1 then
			ply:TakeItemID(paper)
		else 
			CAKE.SetUData(paper, "uses", uses)
			CAKE.SetUData(paper, "name", "Paper " ..uses)
			ply:RefreshInventory()
		end
		note = CAKE.CreateItem("note", ply:CalcDrop(), Angle(0, 0, 0))
		CAKE.SetUData( note:GetNWString("id"), "name", decoded["title"] )
		CAKE.SetUData( note:GetNWString("id"), "text", decoded["text"] )
	end
end
datastream.Hook( "NoteStream", write );