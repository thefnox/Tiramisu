ITEM.Name = "T51B Powered Exosuit";
ITEM.Class = "clothing_t51b";
ITEM.Description = "The latest in powered exosuit technology, amplifies user's strength";
ITEM.Model = "models/t51b/slow.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 2500;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;270",
	"shieldratio;0.3",
	"bulletarmor;0.5",
	"explosivearmor;1.5",
	"kineticarmor;1.2",
	"rigweight;superheavy"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
