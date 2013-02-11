-- datastream.Hook( "Tiramisu.WriteNote", function( ply, handler, id, encoded, decoded )

net.Receive( "Tiramisu.WriteNote", function( len, ply )
	local title, text = net.ReadString( ), net.ReadString( )
	local note = CAKE.CreateItem("note", ply:CalcDrop(), Angle(0, 0, 0))
	timer.Simple( 0, function()
		--CAKE.SetUData( note:GetNWString("id"), "name", decoded["title"] )
		--CAKE.SetUData( note:GetNWString("id"), "text", decoded["text"] )
		CAKE.SetUData( note:GetNWString("id"), "name", title )
		CAKE.SetUData( note:GetNWString("id"), "text", text )
	end)

end )

function CAKE.StartWrite( ply, paper )
	if CAKE.GetUData(paper, "uses") and CAKE.GetUData(paper, "uses") > 0 then
		local uses = CAKE.GetUData(paper, "uses") - 1
		CAKE.SetUData(paper, "uses", uses)
		CAKE.SetUData(paper, "name", "Paper (" .. uses .. " uses left)")
		if ply:HasItemID(paper) then
			if uses < 1 then
				ply:TakeItemID(paper)
			else
				CAKE.SendUData( ply, paper )
			end
		end
		umsg.Start("Tiramisu.StartWrite", ply)
		umsg.End()
	else
		CAKE.SendError( ply, "You can use this paper no longer!" )
	end
end