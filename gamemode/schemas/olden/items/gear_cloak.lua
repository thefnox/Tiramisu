ITEM.Name = "Cloak";
ITEM.Class = "gear_cloak";
ITEM.Description = "Oooh, shady.";
ITEM.Model = "models/Olden/cloak_jiggle.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,0,0 )
ITEM.OffsetAngle = Angle( 0,-90,-90 )
ITEM.Bone = "head"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
