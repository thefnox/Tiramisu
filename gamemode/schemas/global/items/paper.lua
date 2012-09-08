ITEM.Name = "Paper"
ITEM.Class = "paper"
ITEM.Description = "You can write notes on this. "
ITEM.Model = "models/props_junk/garbage_newspaper001a.mdl"
ITEM.Purchaseable = true
ITEM.Price = 50
ITEM.ItemGroup = 1
ITEM.Stack = true
ITEM.Unusable = true
ITEM.RightClick = {
	["Write"] = "Write"
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)
	myid = self:GetNWString("id")
	if !TIRA.GetUData(myid, "uses") then
		TIRA.SetUData(myid, "uses", 50)
		TIRA.SetUData(myid, "name", "Paper " .. 50)
	end
	self:Remove()
end

function ITEM:Write(ply)
	myid = self:GetNWString("id")
	if !TIRA.GetUData(myid, "uses") then
		TIRA.SetUData(myid, "uses", 50)
		TIRA.SetUData(myid, "name", "Paper " .. 50)
	end
	TIRA.StartWrite( ply, myid )
end

function ITEM:UseItem(ply)
end