ITEM.Name = "Black Cloak";
ITEM.Class = "gear_cloakblack";
ITEM.Description = "Oooh, shady.";
ITEM.Model = "models/Olden/cloak_male.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,0,0 )
ITEM.OffsetAngle = Angle( 0,0,0 )
ITEM.Bone = "neck"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
