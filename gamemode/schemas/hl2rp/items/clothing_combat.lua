ITEM.Name = "Combat Clothes"
ITEM.Class = "clothing_combat"
ITEM.Description = "Combat suit used by the rebellion"
ITEM.Model = "models/Humans/Group03/male_06.mdl"
ITEM.FemaleModel = "models/Humans/Group03/Female_01.mdl"
ITEM.Purchaseable = true
ITEM.Unusable = true
ITEM.Price = 300
ITEM.ItemGroup = 2
ITEM.Flags = {
	"explosivearmor0.5",
	"kineticarmor0.6",
	"bulletarmor0.8"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

end
