ITEM.Name = "Colt .357";
ITEM.Class = "weapon_mad_357";
ITEM.Description = "Old and reliable, even for these times.";
ITEM.Model = "models/weapons/w_357.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 400;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( 10,-2,-3 )
ITEM.OffsetAngle = Angle( 0,180,-90 )
ITEM.Bone = "right thigh"
ITEM.WeaponType = "small1"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
