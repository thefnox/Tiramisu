ITEM.Name = "Formal Clothes (2)"
ITEM.Class = "clothing_formal2"
ITEM.Description = "For the refined gentlemen"
ITEM.FemaleModel = "models/mossman.mdl"--This is the female model equivalent of this clothing item, this is optional
ITEM.Model = "models/breen.mdl"
ITEM.Unusable = true
ITEM.Purchaseable = true
ITEM.Price = 500
ITEM.ItemGroup = 1
ITEM.Flags = {
	"nogloves"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

end
