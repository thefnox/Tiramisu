ITEM.Name = "Elite Armor"
ITEM.Class = "clothing_elite"
ITEM.Description = "Heavy armor designed for the very elite."
ITEM.Model = "models/Combine_Super_Soldier.mdl"
ITEM.Purchaseable = false
ITEM.Price = 1000
ITEM.Unusable = true
ITEM.ItemGroup = 2
ITEM.Unusable = true

ITEM.Flags = {
	"armor180",
	"shieldratio0.8",
	"bulletarmor0.5",
	"explosivearmor1.2",
	"kineticarmor0.6",
	"rigweightheavy"
}

ITEM.Content = {
	"materials/models/combine_soldier/combine_elite.vmt",
	"models/Combine_Super_Soldier.mdl"
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

end
