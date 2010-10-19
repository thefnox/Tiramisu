ITEM.Name = "ORI-422 Power Suit";
ITEM.Class = "clothing_powersuit";
ITEM.Description = "An extremely well shielded armor with an uncomparable intimidation factor.";
ITEM.Model = "models/benevolence/us/powertrooper01.mdl";
ITEM.Purchaseable = false;
ITEM.Price = -1;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;500",
	"shieldratio;0.7",
	"bulletarmor;0.8",
	"explosivearmor;1.5",
	"kineticarmor;0.6",
	"rigweight;superheavy"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
