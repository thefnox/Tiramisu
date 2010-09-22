ITEM.Name = "Formal Clothes (Female)";
ITEM.Class = "clothing_formalf";
ITEM.Description = "For the refined ladies";
ITEM.Model = "models/humans/group17/female_02.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 500;
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
