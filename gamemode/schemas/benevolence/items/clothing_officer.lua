ITEM.Name = "MK-57 High-Class Infantry Set";
ITEM.Class = "clothing_officer";
ITEM.Description = "Simplified as an infantry set, with extra armor mounted on. For high-class troops only!";
ITEM.Model = "models/benevolence/us/officer01.mdl";
ITEM.Purchaseable = false;
ITEM.Price = -1;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;170",
	"shieldratio;0.5",
	"bulletarmor;0.4",
	"explosivearmor;1.0",
	"kineticarmor;0.5",
	"rigweight;medium"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
