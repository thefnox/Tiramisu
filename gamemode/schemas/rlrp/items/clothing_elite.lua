ITEM.Name = "Elite Armor";
ITEM.Class = "clothing_elite";
ITEM.Description = "Heavy armor designed for the very elite.";
ITEM.Model = "models/Combine_Super_Soldier.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 1000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;180",
	"shieldratio;0.8",
	"bulletarmor;0.5",
	"explosivearmor;1.2",
	"kineticarmor;0.6",
	"rigweight;heavy"
}
ITEM.Content = {
	"materials/models/combine_soldier/combine_elite.vmt",
	"models/Combine_Super_Soldier.mdl"
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
