ITEM.Name = "Combine Standard Marksman Rifle( CSMR )";
ITEM.Class = "weapon_ep2sniper";
ITEM.Description = "A more sofisticated, pulse based sniper rifle";
ITEM.Model = "models/weapons/w_combinesniper_e2.mdl"
ITEM.Purchaseable = true;
ITEM.Price = 2050;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( -5,-3,2 )
ITEM.OffsetAngle = Angle( 45,0,0 )
ITEM.Bone = "chest"
ITEM.WeaponType = "big"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:Give("weapon_ep2sniper");
	self:Remove();

end
