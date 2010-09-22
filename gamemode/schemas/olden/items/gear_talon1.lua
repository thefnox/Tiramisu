ITEM.Name = "A Talon (1)";
ITEM.Class = "gear_talon1";
ITEM.Description = "Hooray for violence";
ITEM.Model = "models/soulcalibur4/1talonthin1.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,0,0 )
ITEM.OffsetAngle = Angle(0,0,0 )
ITEM.Bone = "right hand"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
