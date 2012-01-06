ITEM.Name = "Stunstick"
ITEM.Class = "weapon_stunstick"
ITEM.Description = "Good for stunnin'."
ITEM.Model = "models/weapons/w_stunbaton.mdl"
ITEM.Purchaseable = false
ITEM.Price = 200
ITEM.ItemGroup = 2
ITEM.Offset = Vector( 1,-5,3 )
ITEM.OffsetAngle = Angle( 0,0,0 )
ITEM.Bone = "left thigh"
ITEM.WeaponType = "small3"
ITEM.Wearable = true


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	self:Remove()

end
