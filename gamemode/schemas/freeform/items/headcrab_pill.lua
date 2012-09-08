ITEM.Name = "Headcrab Pill"
ITEM.Class = "headcrab_pill"
ITEM.Description = "Use this to become a headcrab"
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

	TIRA.RemoveClothing( ply )
	TIRA.RemoveAllGear( ply )
	ply:SetSpecialModel( "models/headcrabclassic.mdl" )
	self:Remove()

end
