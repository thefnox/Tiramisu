ITEM.Name = "MP-7";
ITEM.Class = "weapon_smg1";
ITEM.Description = "Rapid-fire submachine gun.";
ITEM.Model = "models/weapons/w_smg1.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 350;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( 4,-4,-2 )
ITEM.OffsetAngle = Angle( 45,0,0 )
ITEM.Bone = "chest"
ITEM.WeaponType = "big"
ITEM.Wearable = true


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
