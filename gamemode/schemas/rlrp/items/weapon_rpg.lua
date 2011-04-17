ITEM.Name = "RPG-7";
ITEM.Class = "weapon_rpg";
ITEM.Description = "Aim away from face.";
ITEM.Model = "models/weapons/w_rocket_launcher.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 800;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( -15,-2,10 )
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
