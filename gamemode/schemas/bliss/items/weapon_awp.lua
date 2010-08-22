ITEM.Name = "AI AWP Sniper Rifle";
ITEM.Class = "weapon_mad_awp";
ITEM.Description = "7.62mm sniper rifle with 8x scope. It doesn't get any deadlier than this";
ITEM.Model = "models/weapons/w_snip_awp.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1800;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( -7,-6,6 )
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
