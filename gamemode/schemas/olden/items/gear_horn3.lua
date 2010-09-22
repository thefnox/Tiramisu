ITEM.Name = "Demon Horn 3";
ITEM.Class = "gear_horn3";
ITEM.Description = "Demons gonna demonize";
ITEM.Model = "models/Olden/tiefling_horn3.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,0,0 )
ITEM.OffsetAngle = Angle( 0,0,0 )
ITEM.Bone = "head"
ITEM.Weight = 0


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
