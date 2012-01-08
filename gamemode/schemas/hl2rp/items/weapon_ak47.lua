ITEM.Name = "AK-47"
ITEM.Class = "weapon_ak47"
ITEM.Description = "Somehow still in wide circulation. 7.62mm."
ITEM.Model = "models/weapons/w_rif_ak47.mdl"
ITEM.Unusable = true
ITEM.Purchaseable = true
ITEM.Price = 450
ITEM.ItemGroup = 2
ITEM.Offset = Vector( -5,-4,5 )
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
