ITEM.Name = "Casual Clothes (1)";
ITEM.Class = "clothing_casual1";
ITEM.Description = "Cool clothes from this century";
ITEM.Model = "models/Humans/Group02/male_02.mdl";
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
	self:Remove();
end
