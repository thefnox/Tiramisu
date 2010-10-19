ITEM.Name = "S7 Standard Infantry Set";
ITEM.Class = "clothing_infantry";
ITEM.Description = "A simple standard-issue set of armor. Provides enough protection to get you through the field.";
ITEM.Model = "models/benevolence/us/infantry01.mdl";
ITEM.Purchaseable = false;
ITEM.Price = -1;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;125",
	"shieldratio;0.4",
	"bulletarmor;0.4",
	"explosivearmor;0.9",
	"kineticarmor;0.4",
	"rigweight;medium"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
