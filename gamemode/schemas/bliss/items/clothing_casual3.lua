ITEM.Name = "Casual Clothes (3)";
ITEM.Class = "clothing_casual3";
ITEM.Description = "Casual clothes for modern men, in white";
ITEM.Model = "models/Characters/hostage_04.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 150;
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
