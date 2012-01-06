ITEM.Name = "Standard Overwatch Armor"
ITEM.Class = "clothing_soldier"
ITEM.Description = "Overwatch edition"
ITEM.Model = "models/Combine_Soldier.mdl"
ITEM.Purchaseable = false
ITEM.Unusable = true
ITEM.Price = 750
ITEM.ItemGroup = 2
ITEM.Flags = {
	"armor120",
	"shieldratio0.6",
	"bulletarmor0.6",
	"explosivearmor1.3",
	"kineticarmor0.6",
	"rigweightmedium"
}
ITEM.Content = {
	"materials/models/combine_soldier/combinesoldiersheet.vmt",
	"materials/models/combine_soldier/combinesoldiersheet_shotgun.vmt",
	"models/Combine_Soldier.mdl"
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

end
