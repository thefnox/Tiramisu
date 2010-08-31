ITEM.Name = "Action Clothes (6)";
ITEM.Class = "clothing_customf6";
ITEM.Description = "Cool clothes from this century";
ITEM.Model = "models/elexis.mdl";
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
