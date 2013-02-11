ITEM.Name = "Weapon"
ITEM.Class = "weapon_base"
ITEM.Description = ""
ITEM.Model = "models/weapons/w_pistol.mdl"
ITEM.Purchaseable = false
ITEM.Price = 0
ITEM.ItemGroup = 1
ITEM.Stack = false
ITEM.Wearable = true
ITEM.Unusable = true
ITEM.WeaponType = "small1"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	self:Remove()

end