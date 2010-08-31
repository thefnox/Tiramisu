ITEM.Name = "Casual Clothes (1)";
ITEM.Class = "clothing_customf1";
ITEM.Description = "Cool clothes from this century";
ITEM.Model = "models/laracroft_classic.mdl";
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
