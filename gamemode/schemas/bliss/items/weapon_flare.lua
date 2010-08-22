ITEM.Name = "Flare Gun";
ITEM.Class = "weapon_mad_flare";
ITEM.Description = "Shoots a bright flare to attract attention";
ITEM.Model = "models/weapons/w_pistol.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 300;
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
