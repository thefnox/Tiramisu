usermessage.Hook( "Tiramisu.PlayerRagged", function(data)
		ply = data:ReadEntity()
		rag = data:ReadEntity()
		
		ply.rag = rag
		rag.ply = ply
end)