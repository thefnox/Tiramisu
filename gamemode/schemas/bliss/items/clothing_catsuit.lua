ITEM.Name = "Tactical CAT-5 Exosuit";
ITEM.Class = "clothing_medium_catsuit";
ITEM.Description = "Lightweight, yet durable. Perfect for assasins. Made for the ladies.";
ITEM.Model = "models/smashbros/samlyx.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;90",
	"shieldratio;0.9",
	"fallprotection;1",
	"explosivearmor;3.2",
	"bulletarmor;1.25"
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
