ITEM.Name = "'Korin' Combat Exosuit";
ITEM.Class = "clothing_medium_korin";
ITEM.Description = "Versatile medium armor, made for ladies";
ITEM.Model = "models/Humans/Group03/Korin_Blk.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 850;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;120",
	"shieldratio;0.7",
	"explosivearmor;1.2",
	"bulletarmor;0.7",
	"rigweight;medium"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
