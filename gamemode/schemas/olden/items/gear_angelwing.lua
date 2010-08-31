ITEM.Name = "Angel Wings";
ITEM.Class = "gear_angelwing";
ITEM.Description = "Angelic stuff for flying";
ITEM.Model = "models/Olden/angel_wings.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,0,0 )
ITEM.OffsetAngle = Angle( 0,0,0 )
ITEM.Bone = "chest"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
