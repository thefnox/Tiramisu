ITEM.Name = "Mercenary Suit (1)";
ITEM.Class = "clothing_medium_ct1";
ITEM.Description = "Looks great on mercenaries";
ITEM.Model = "models/player/ct_gsg9.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 750;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"explosivearmor;0.5",
	"kineticarmor;0.5",
	"bulletarmor;0.6"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
