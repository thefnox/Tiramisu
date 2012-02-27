ITEM.Name = "Glock 18 Pistol"
ITEM.Class = "weapon_glock"
ITEM.Description = "Semi auto, polymer built, 9mm. Highly reliable."
ITEM.Model = "models/weapons/w_pist_glock18.mdl"
ITEM.Unusable = true
ITEM.Purchaseable = true
ITEM.Price = 350
ITEM.ItemGroup = 2
ITEM.Offset = Vector( 10,-2,-3 )
ITEM.OffsetAngle = Angle( 0,180,-90 )
ITEM.Bone = "right thigh"
ITEM.WeaponType = "small1"
ITEM.Wearable = true


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	self:Remove()
	
end
