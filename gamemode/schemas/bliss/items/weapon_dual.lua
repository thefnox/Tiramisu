ITEM.Name = "Dual Beretta Elites";
ITEM.Class = "weapon_mad_dual";
ITEM.Description = "Power multiplied by two.";
ITEM.Model = "models/weapons/w_eq_eholster_elite.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 950;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( 8,0,-3 )
ITEM.OffsetAngle = Angle( 0,-90,90 )
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
