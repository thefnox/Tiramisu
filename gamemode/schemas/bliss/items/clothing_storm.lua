ITEM.Name = "7-E9 'Storm' Exosuit";
ITEM.Class = "clothing_storm";
ITEM.Description = "Very widespread medium armor, a bang for your buck";
ITEM.Model = "models/stormtrooper/slow_stormtrooper.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;120",
	"shieldratio;0.7",
	"explosivearmor;0.5",
	"kineticarmor;0.6",
	"bulletarmor;0.8",
	"rigweight;medium"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
