ITEM.Name = "Demon Wing (Down)";
ITEM.Class = "gear_demonwing_down";
ITEM.Description = "Demonic stuff";
ITEM.Model = "models/Olden/demon_wings_down.mdl";
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
