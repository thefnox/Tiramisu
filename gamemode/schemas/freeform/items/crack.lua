ITEM.Name = "Jar o' Crack Rocks"
ITEM.Class = "crack"
ITEM.Description = "Head asplode!"
ITEM.Model = "models/props_lab/jar01a.mdl"
ITEM.Purchaseable = true
ITEM.Price = 50
ITEM.ItemGroup = 2

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	TIRA.DrugPlayer(ply, 1)
	self:Remove()

end
