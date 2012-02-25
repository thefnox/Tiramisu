ITEM.Name = "Medikit"
ITEM.Class = "small_medikit"
ITEM.Description = "Small container of repairing nanites"
ITEM.Model = "models/healthvial.mdl"
ITEM.Purchaseable = true
ITEM.Price = 3
ITEM.ItemGroup = 3

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	ply:SetHealth(math.Clamp(ply:Health() + 15, 0, ply:MaxHealth()))
	ply:TakeItem("small_medikit")
	self:Remove()

end
