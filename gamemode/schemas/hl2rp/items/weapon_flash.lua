ITEM.Name = "Flash Grenade";
ITEM.Class = "weapon_mad_flash";
ITEM.Description = "Flash grenade. Made for disorienting.";
ITEM.Model = "models/weapons/w_eq_flashbang.mdl";
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
