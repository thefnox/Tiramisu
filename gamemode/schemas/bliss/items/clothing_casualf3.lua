ITEM.Name = "Casual Female Clothes (3)";
ITEM.Class = "clothing_casualf3";
ITEM.Description = "Rather rebellious attire";
ITEM.Model = "models/alyx.mdl";
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
