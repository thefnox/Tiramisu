ITEM.Name = "Milk Jug"
ITEM.Class = "milkjug"
ITEM.Description = "I doubt this is cow milk."
ITEM.Model = "models/props_junk/garbage_milkcarton001a.mdl"
ITEM.Purchaseable = true
ITEM.Price = 4
ITEM.ItemGroup = 1

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	ply:SetHealth(math.Clamp(ply:Health() + 10, 0, ply:GetMaxHealth()))
	self:Remove()

end
