ITEM.Name = "Vice Squad Armor";
ITEM.Class = "clothing_vice";
ITEM.Description = "Vice Standard.";
ITEM.Model = "models/Javelin_Unit.mdl";
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
