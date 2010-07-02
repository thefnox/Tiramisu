ITEM.Name = "Mechanic Clothes";
ITEM.Class = "clothing_mech";
ITEM.Description = "A work suit. Made for the technology adept";
ITEM.Model = "models/player/t_leet.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 200;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
