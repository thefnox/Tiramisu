function write( ply, handler, id, encoded, decoded )
	book = CAKE.CreateItem("note", ply:CalcDrop(), Angle(0, 0, 0))
	CAKE.SetUData( book:GetNWString("id"), "name", decoded["title"] )
	CAKE.SetUData( book:GetNWString("id"), "text", decoded["text"] )
end
datastream.Hook( "NoteStream", write );