ITEM.Name = "N7 PATRIOT Exosuit";
ITEM.Class = "clothing_shepard";
ITEM.Description = "Medium armor, ideal for bodyguards of diplomatic missions for it's elegancy";
ITEM.Model = "models/shepard/s-low.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1400;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;120",
	"shieldratio;0.7",
	"bulletarmor;0.6",
	"explosivearmor;1.2",
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
