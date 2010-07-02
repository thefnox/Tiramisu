ITEM.Name = "X-HDS 'Standard' Power Suit";
ITEM.Class = "clothing_powersuit";
ITEM.Description = "The latest in powered exosuit technology, provides a full exoskeleton for the user";
ITEM.Model = "models/power_armor/slow.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1500;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;210",
	"shieldratio;0.8",
	"bulletarmor;0.5",
	"explosivearmor;1.5",
	"kineticarmor;0.8",
	"rigweight;heavy"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
