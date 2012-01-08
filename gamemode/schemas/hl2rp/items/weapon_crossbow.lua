ITEM.Name = "Crossbow"
ITEM.Class = "weapon_crossbow"
ITEM.Description = "High-velocity crossbow"
ITEM.Model = "models/weapons/w_crossbow.mdl"
ITEM.Unusable = true
ITEM.Purchaseable = true
ITEM.Price = 600
ITEM.ItemGroup = 2
ITEM.Offset = Vector( -5,-5,2 )
ITEM.OffsetAngle = Angle( 45,0,0 )
ITEM.Bone = "chest"
ITEM.WeaponType = "big"
ITEM.Wearable = true


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	self:Remove()

end
