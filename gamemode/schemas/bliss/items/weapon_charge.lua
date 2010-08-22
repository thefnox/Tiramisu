ITEM.Name = "Explosive Satchel";
ITEM.Class = "weapon_mad_charge";
ITEM.Description = "Powerful enough to take down doors, but not much else";
ITEM.Model = "models/Weapons/w_slam.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 600;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( 6,0,4 )
ITEM.OffsetAngle = Angle( 0,90,0 )
ITEM.Bone = "left thigh"
ITEM.WeaponType = "small3"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
