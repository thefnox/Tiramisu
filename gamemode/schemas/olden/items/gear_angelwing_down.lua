ITEM.Name = "Angel Wing (Down)";
ITEM.Class = "gear_angelwing_down";
ITEM.Description = "Angelic stuff";
ITEM.Model = "models/Olden/angel_wings_down.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( -5,2,0 )
ITEM.OffsetAngle = Angle( 0,90,90 )
ITEM.Bone = "chest"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
