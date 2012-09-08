ITEM.Name = "Old Shoe"
ITEM.Class = "shoe"
ITEM.Description = "An old boot to keep your foot warm"
ITEM.Model = "models/props_junk/shoe001a.mdl"
ITEM.Purchaseable = true
ITEM.Price = 10
ITEM.ItemGroup = 1
ITEM.Flags = {
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	TIRA.SendChat(ply, "It doesn't fit your feet..")

end
