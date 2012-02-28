ITEM.Name = "Note"
ITEM.Class = "note"
ITEM.Description = ""
ITEM.Model = "models/props_c17/paper01.mdl"
ITEM.Purchaseable = false
ITEM.Price = 0
ITEM.ItemGroup = 1
ITEM.Stack = false
ITEM.Unusable = true
ITEM.RightClick = {
	["Read"] = "UseItem",
	["Copy"] = "Copy"
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	local myid = self:GetNWString("id")
	datastream.StreamToClients( ply, "Tiramisu.ReadNote", {["title"] = CAKE.GetUData(myid, "name"), ["text"] = CAKE.GetUData(myid, "text")})

end

function ITEM:Copy(ply)
	local paper = ply:HasItem("paper")
	
	if paper then
		local uses = CAKE.GetUData(paper, "uses")
		if uses > 0 then
			uses = uses - 1
			if uses < 1 then
				ply:TakeItemID(paper)
			else 
				CAKE.SetUData(paper, "uses", uses)
				CAKE.SetUData(paper, "name", "Paper (" .. uses .. " uses left)")
				CAKE.SendUData( ply, paper )
			end
			local myid = self:GetNWString("id")
			local name = CAKE.GetUData(myid, "name")
			local text = CAKE.GetUData(myid, "text")
			local note = CAKE.CreateItem("note", ply:CalcDrop(), Angle(0, 0, 0))
			CAKE.SetUData( note:GetNWString("id"), "name", name )
			CAKE.SetUData( note:GetNWString("id"), "text", text )
			note:Remove()
			ply:GiveItem("note", myid)
		end
	else
		CAKE.SendChat(ply, "You don't have any paper to copy this to!")
	end
end