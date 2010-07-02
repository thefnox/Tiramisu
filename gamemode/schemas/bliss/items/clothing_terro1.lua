ITEM.Name = "Guerilla Combatant Clothes";
ITEM.Class = "clothing_light_terro1";
ITEM.Description = "Combat suit, for the real rebellious kind.";
ITEM.Model = "models/player/t_arctic.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 500;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"explosivearmor;0.5",
	"kineticarmor;0.6",
	"bulletarmor;0.8"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
