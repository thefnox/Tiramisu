ITEM.Name = "Vortigaunt Pill"
ITEM.Class = "vortigaunt_pill"
ITEM.Description = "Use this to become a vortigaunt"
ITEM.Model = "models/props_lab/jar01b.mdl"
ITEM.Purchaseable = false
ITEM.Price = 3
ITEM.ItemGroup = 1

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	CAKE.RemoveClothing( ply )
	CAKE.RemoveAllGear( ply )
	ply:SetSpecialModel( "models/vortigaunt.mdl" )
	self:Remove()

end
