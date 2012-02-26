ITEM.Name = "Elite Helmet"
ITEM.Class = "helmet_elite"
ITEM.Description = "Advanced protection. In visor display and all"
ITEM.Model = "models/Combine_Super_Soldier.mdl"
ITEM.Purchaseable = false
ITEM.Unusable = true
ITEM.Price = 350
ITEM.ItemGroup = 2
ITEM.IsCombine = true
ITEM.Flags = {
	"overlay1",
	"headprotection0.8"
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
