ITEM.Name = "RAW-17 Heavy Exosuit";
ITEM.Class = "clothing_nailgunner";
ITEM.Description = "An extremely well shielded armor with an uncomparable intimidation factor";
ITEM.Model = "models/nailgunner/slow.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 4000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;300",
	"shieldratio;0.7",
	"bulletarmor;0.5",
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
