ITEM.Name = "Action Clothes (7)";
ITEM.Class = "clothing_customf7";
ITEM.Description = "Cool clothes from this century";
ITEM.Model = "models/Jessica.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 100;
ITEM.ItemGroup = 1;
ITEM.Flags = {
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
	self:Remove();
end
