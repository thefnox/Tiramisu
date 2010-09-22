ITEM.Name = "Knife";
ITEM.Class = "weapon_mad_knife";
ITEM.Description = "Good for knifin'. Get several and throw them about";
ITEM.Model = "models/weapons/w_knife_ct.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 200;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( 5,-3,3 )
ITEM.OffsetAngle = Angle( 0,60,90 )
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
