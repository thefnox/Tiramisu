ITEM.Name = "Medic Clothes";
ITEM.Class = "clothing_medic";
ITEM.Description = "Combat Medic suit used by the rebellion";
ITEM.Model = "models/humans/Group03m/Male_01.mdl";
ITEM.FemaleModel = "models/humans/Group03m/Female_01.mdl";
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
