ITEM.Name = "B-52 Female Power Suit";
ITEM.Class = "clothing_kanaf";
ITEM.Description = "A limited edition power suit for ladies. Uses a remarkably odd design.";
ITEM.Model = "models/kana/slow.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 3000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;230",
	"shieldratio;0.7",
	"bulletarmor;0.5",
	"kineticarmor;0.6",
	"explosivearmor;0.8",
	"rigweight;heavy"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
