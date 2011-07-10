ITEM.Name = "SPAS-12 Shotgun";
ITEM.Class = "weapon_shotgun";
ITEM.Description = "Overwatch Edition";
ITEM.Model = "models/weapons/w_shotgun.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 600;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( 0,-3,0 )
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
