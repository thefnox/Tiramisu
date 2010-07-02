ITEM.Name = "RAV55 HAZMAT Suit";
ITEM.Class = "clothing_biosuit";
ITEM.Description = "Primarily works as a HAZMAT suit, provides little protection";
ITEM.Model = "models/bio_suit/slow_bio_suit.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 500;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;70",
	"shieldratio;0.9",
	"explosivearmor;2.5",
	"bulletarmor;2.0",
	"hazmat",
	"rigweight;light"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
