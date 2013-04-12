ITEM.Name = "Watermelon"
ITEM.Class = "watermelon"
ITEM.Description = "fuck you."
ITEM.Model = "models/props_junk/watermelon01.mdl"
ITEM.Purchaseable = true
ITEM.Price = 10
ITEM.ItemGroup = 1

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	ply:SetHealth(math.Clamp(ply:Health() + 15, 0, ply:GetMaxHealth()))
	self:Remove()

end
