ITEM.Name = "Female Combat Clothes";
ITEM.Class = "clothing_combatf";
ITEM.Description = "Combat suit, tailored for ladies";
ITEM.Model = "models/Humans/Group03/Female_01.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 300;
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
