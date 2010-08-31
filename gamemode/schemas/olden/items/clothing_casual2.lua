ITEM.Name = "Casual Clothes (2)";
ITEM.Class = "clothing_casual2";
ITEM.Description = "Casual clothes for modern men";
ITEM.Model = "models/Characters/Hostage_02.mdl";
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
