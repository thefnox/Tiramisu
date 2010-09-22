ITEM.Name = "Cape";
ITEM.Class = "gear_cape";
ITEM.Description = "Now with more heroism!";
ITEM.Model = "models/Olden/cape_jiggle.mdl";
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
