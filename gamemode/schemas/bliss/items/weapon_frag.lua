ITEM.Name = "Fragmentation Grenade";
ITEM.Class = "weapon_mad_grenade";
ITEM.Description = "Produces a good deal of damage on a wide radius";
ITEM.Model = "models/weapons/w_eq_fraggrenade.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 600;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( 6,-2,4 )
ITEM.OffsetAngle = Angle( 0,0,-90 )
ITEM.Bone = "pelvis"
ITEM.WeaponType = "small4"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
