ITEM.Name = "Zipties";
ITEM.Class = "weapon_zipties";
ITEM.Description = "Good for boundin'.";
ITEM.Model = "models/Items/combine_rifle_ammo01.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 500;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( 1,-5,3 )
ITEM.OffsetAngle = Angle( 0,0,0 )
ITEM.Scale = Vector( 0, 0, 0 )
ITEM.Bone = "left thigh"
ITEM.WeaponType = "small3"
ITEM.Weight = 0

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
