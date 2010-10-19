ITEM.Name = "MK-82 Heavy Infantry Set";
ITEM.Class = "clothing_heavyinfantry";
ITEM.Description = "A very heavy, well shielded set of armor. The next best before the power suit.";
ITEM.Model = "models/benevolence/us/heavyinfantry01.mdl";
ITEM.Purchaseable = false;
ITEM.Price = -1;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;200",
	"shieldratio;0.5",
	"bulletarmor;0.4",
	"explosivearmor;1.0",
	"kineticarmor;0.5",
	"rigweight;heavy"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
