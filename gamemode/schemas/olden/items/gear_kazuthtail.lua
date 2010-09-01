ITEM.Name = "Kazuth Tail";
ITEM.Class = "gear_kazuthtail";
ITEM.Description = "Furry tail for furry people.";
ITEM.Model = "models/Olden/jiggle_tail.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,-6,10 )
ITEM.OffsetAngle = Angle( -135,-90,0 )
ITEM.Bone = "pelvis"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
