ITEM.Name = "A shield";
ITEM.Class = "gear_shield1";
ITEM.Description = "Best offense is a good defence";
ITEM.Model = "models/soulcalibur4/1shield1.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,0,0 )
ITEM.OffsetAngle = Angle(0,0,0 )
ITEM.Bone = "left hand"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
