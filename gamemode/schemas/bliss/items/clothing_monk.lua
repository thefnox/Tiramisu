ITEM.Name = "Monk Clothes";
ITEM.Class = "clothing_monk";
ITEM.Description = "It used to be stylish a couple of centuries back";
ITEM.Model = "models/monk.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 100;
ITEM.ItemGroup = 1;
ITEM.Flags = {
	"nogloves"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
