ITEM.Name = "AL-SJX7 Prototype Combat Exosuit";
ITEM.Class = "clothing_heavy_juggernaut";
ITEM.Description = "Prototype Heavy Combat Suit, Alliance Augmentations Needed.";
ITEM.Model = "models/mw2guy/riot/juggernaut.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 2000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;310",
	"shieldratio;0.2",
	"bulletarmor;0.3",
	"explosivearmor;.1",
	"kineticarmor;0.6",
	"rigweight;superheavy"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
