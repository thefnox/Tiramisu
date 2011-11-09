ITEM.Name = "Crowbar";
ITEM.Class = "weapon_crowbar";
ITEM.Description = "Gordon Freeman Limited Edition Crowbar";
ITEM.Model = "models/weapons/w_crowbar.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 100;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( 10,3,4 )
ITEM.OffsetAngle = Angle( 0,22,45 )
ITEM.Bone = "left thigh"
ITEM.WeaponType = "small3"
ITEM.Scale = Vector( 0.8,0.8,0.8 )
ITEM.Wearable = true


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();

end
