ITEM.Name = "UMP-45";
ITEM.Class = "weapon_mad_ump";
ITEM.Description = "A more sofisticated, .45 caliber SMG";
ITEM.Model = "models/weapons/w_smg_ump45.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 450;
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

	ply:Give("weapon_mad_ump");
	self:Remove();

end
