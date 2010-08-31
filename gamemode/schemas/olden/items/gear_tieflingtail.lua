ITEM.Name = "Tiefling Tail";
ITEM.Class = "gear_tieflingtail";
ITEM.Description = "It's what drives Krug crazy.";
ITEM.Model = "models/Olden/tiefling_tail.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,0,-40 )
ITEM.OffsetAngle = Angle( 0,90,0 )
ITEM.Bone = "pelvis"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
