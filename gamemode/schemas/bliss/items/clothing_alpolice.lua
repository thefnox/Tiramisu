ITEM.Name = "AL-CDU3 Cadet Uniform";
ITEM.Class = "clothing_police";
ITEM.Description = "Alliance Cadet Uniform, allows simple protection.";
ITEM.Model = "models/Police.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 500;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;95",
	"shieldratio;0.7",
	"explosivearmor;0.9",
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
