ITEM.Name = "AR-2 Rifle";
ITEM.Class = "weapon_ar2";
ITEM.Description = "Pulse Rifle Technology";
ITEM.Model = "models/weapons/w_irifle.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 850;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( -5,-5,2 )
ITEM.OffsetAngle = Angle( 45,0,0 )
ITEM.Bone = "chest"
ITEM.WeaponType = "big"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
