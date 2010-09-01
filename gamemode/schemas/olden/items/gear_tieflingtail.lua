ITEM.Name = "Tiefling Tail";
ITEM.Class = "gear_tieflingtail";
ITEM.Description = "It's what drives Krug crazy.";
ITEM.Model = "models/Olden/tiefling_jiggle.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,-4,-20 )
ITEM.OffsetAngle = Angle( -135,-90,0 )
ITEM.Bone = "pelvis"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
