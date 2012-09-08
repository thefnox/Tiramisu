ITEM.Name = "Light Beer"
ITEM.Class = "lightbeer"
ITEM.Description = "Just for a buzz."
ITEM.Model = "models/props_junk/garbage_glassbottle003a.mdl"
ITEM.Purchaseable = true
ITEM.Price = 8
ITEM.ItemGroup = 1

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	TIRA.DrugPlayer(ply, 5)
	self:Remove()

end
