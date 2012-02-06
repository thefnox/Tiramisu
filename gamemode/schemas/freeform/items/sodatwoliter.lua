ITEM.Name = "Two-Liter Soda"
ITEM.Class = "sodatwoliter"
ITEM.Description = "Lots of soda."
ITEM.Model = "models/props_junk/garbage_plasticbottle003a.mdl"
ITEM.Purchaseable = true
ITEM.Price = 5
ITEM.ItemGroup = 1

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	self:Remove()

end
