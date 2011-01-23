ITEM.Name = "Standard Overwatch Armor";
ITEM.Class = "clothing_soldier";
ITEM.Description = "Overwatch edition";
ITEM.Model = "models/Combine_Soldier.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 750;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;120",
	"shieldratio;0.6",
	"bulletarmor;0.6",
	"explosivearmor;1.3",
	"kineticarmor;0.6",
	"rigweight;medium"
}
ITEM.Content = {
	"materials/models/combine_soldier/combinesoldiersheet.vmt",
	"materials/models/combine_soldier/combinesoldiersheet_shotgun.vmt",
	"models/Combine_Soldier.mdl"
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
