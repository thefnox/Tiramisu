ITEM.Name = "Demon Wings";
ITEM.Class = "gear_demonwing";
ITEM.Description = "Demonic stuff for flying";
ITEM.Model = "models/Olden/demon_wings.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( -5,5,0 )
ITEM.OffsetAngle = Angle( 0,90,90 )
ITEM.Bone = "chest"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
