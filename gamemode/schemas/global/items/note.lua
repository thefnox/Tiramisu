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

	myid = self:GetNWString("id")
	datastream.StreamToClients( {ply}, "Tiramisu.ReadNote", {["title"] = CAKE.GetUData(myid, "name"), ["text"] = CAKE.GetUData(myid, "text")})
	ply:GiveItem("note", myid)
	self:Remove()

end

function ITEM:Copy(ply)
	paper = ply:HasItem("paper")
	
	if paper then
		uses = CAKE.GetUData(paper, "uses")
		if uses > 0 then
			uses = uses - 1
			if uses < 1 then
				ply:TakeItemID(paper)
			else 
				CAKE.SetUData(paper, "uses", uses)
				CAKE.SetUData(paper, "name", "Paper " ..uses)
				ply:RefreshInventory()
			end
			myid = self:GetNWString("id")
			name = CAKE.GetUData(myid, "name")
			text = CAKE.GetUData(myid, "text")
			note = CAKE.CreateItem("note", ply:CalcDrop(), Angle(0, 0, 0))
			CAKE.SetUData( note:GetNWString("id"), "name", name )
			CAKE.SetUData( note:GetNWString("id"), "text", text )
			ply:GiveItem("note", myid)
			self:Remove()
		end
	else
		ply:GiveItem("note", self:GetNWString("id"))
	end
end