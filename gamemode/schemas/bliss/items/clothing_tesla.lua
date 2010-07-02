ITEM.Name = "Prototype X-HDS 'Tesla' Suit";
ITEM.Class = "clothing_tesla";
ITEM.Description = "Uses Tesla coils to deviate damage from the user. Extremely powerful as any power suit.";
ITEM.Model = "models/tesla_power_armor/slow.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 3000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;250",
	"shieldratio;0.3",
	"bulletarmor;0.5",
	"explosivearmor;1.5",
	"kineticarmor;2",
	"rigweight;superheavy"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
