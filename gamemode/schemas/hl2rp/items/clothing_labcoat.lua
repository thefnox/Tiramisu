ITEM.Name = "Laboratory Coat"
ITEM.Class = "clothing_labcoat"
ITEM.Description = "Lab coat for those smarter gentlemen"
ITEM.Model = "models/Kleiner.mdl"
ITEM.Unusable = true
ITEM.Purchaseable = true
ITEM.Price = 100
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
	self:Remove()
end
