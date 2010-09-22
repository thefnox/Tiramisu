ITEM.Name = "A Polearm";
ITEM.Class = "gear_polearm2";
ITEM.Description = "Longer, harder, better, stronger";
ITEM.Model = "models/soulcalibur4/1polearm1.mdl";
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
