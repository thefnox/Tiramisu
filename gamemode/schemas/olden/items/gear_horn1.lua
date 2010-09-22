ITEM.Name = "Demon Horn 1";
ITEM.Class = "gear_horn1";
ITEM.Description = "Demons gonna demonize";
ITEM.Model = "models/Olden/tiefling_horn1.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 3,5,0 )
ITEM.OffsetAngle = Angle( 0,0,90 )
ITEM.Bone = "head"
ITEM.Weight = 0


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
