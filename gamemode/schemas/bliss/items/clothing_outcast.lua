ITEM.Name = "X-HDS 'Black' Power Suit";
ITEM.Class = "clothing_outcast";
ITEM.Description = "A limited edition of the X-HDS power suit, provides a fair degree of protection. Now with HAZMAT protection!";
ITEM.Model = "models/power_armor_outcast/slow.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 3000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;210",
	"shieldratio;0.6",
	"bulletarmor;0.4",
	"explosivearmor;1.1",
	"hazmat",
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
