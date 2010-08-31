ITEM.Name = "Casual Female Clothes (2)";
ITEM.Class = "clothing_casualf2";
ITEM.Description = "A rather stylish pants and turtleneck sweater";
ITEM.Model = "models/mossman.mdl";
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
