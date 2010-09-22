ITEM.Name = "Viktor Squad Armor";
ITEM.Class = "clothing_viktor";
ITEM.Description = "Viktor Standard.";
ITEM.Model = "models/C08Cop.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 500;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;70",
	"shieldratio;0.7",
	"explosivearmor;1.5",
	"kineticarmor;0.6",
	"bulletarmor;0.7"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
