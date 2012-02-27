ITEM.Name = "Overwatch Helmet"
ITEM.Class = "helmet_soldier"
ITEM.Description = "Full head protection. Features an in helmet comm and targeting aid."
ITEM.Model = "models/Combine_Soldier.mdl"
ITEM.Purchaseable = false
ITEM.Unusable = true
ITEM.Price = 200
ITEM.ItemGroup = 2
ITEM.IsCombine = true
ITEM.Flags = {
	"overlay1",
	"headprotection0.8"
}
ITEM.Content = {
	"models/Combine_Soldier.mdl",
	"materials/models/combine_soldier/combinesoldiersheet",
	"materials/models/combine_soldier/combinesoldiersheet_shotgun"
}


function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

end
