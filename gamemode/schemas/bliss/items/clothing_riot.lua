ITEM.Name = "'AL-SRU2 Body Armor";
ITEM.Class = "clothing_medium_riot";
ITEM.Description = "Versatile Alliance Labs medium armor, made for a soldiers needs today!";
ITEM.Model = "models/mw2guy/riot/riot_ru.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1250;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;150",
	"shieldratio;0.8",
	"bulletarmor;0.8",
	"kineticarmor;0.6",
	"explosivearmor;0.9",
	"rigweight;medium"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
