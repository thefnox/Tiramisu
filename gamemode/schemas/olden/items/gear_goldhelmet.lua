ITEM.Name = "Gold Helmet";
ITEM.Class = "gear_goldhelmet";
ITEM.Description = "Protect Ya Neck";
ITEM.Model = "models/props_tes/shiveringisleguards/gsaint_helmet_captain.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,0,0 )
ITEM.OffsetAngle = Angle(0,0,0 )
ITEM.Bone = "head"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
