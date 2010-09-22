ITEM.Name = "Kazuth Ear";
ITEM.Class = "gear_kazuthear";
ITEM.Description = "Furry ear for furry people.";
ITEM.Model = "models/Olden/kazuth_ear.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( -4,1,0 )
ITEM.OffsetAngle = Angle( 90,-90,0 )
ITEM.Bone = "head"
ITEM.Weight = 0


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
