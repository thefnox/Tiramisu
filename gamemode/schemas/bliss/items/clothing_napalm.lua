ITEM.Name = "NAPALM.32 Exosuit";
ITEM.Class = "clothing_napalm";
ITEM.Description = "A rather sturdy, space adapted, exosuit";
ITEM.Model = "models/napalm_atc/slow.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1100;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;100",
	"shieldratio;0.6",
	"bulletarmor;0.8",
	"explosivearmor;0.2",
	"hazmat",
	"rigweight;medium"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
