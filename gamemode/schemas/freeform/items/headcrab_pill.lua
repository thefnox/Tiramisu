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

	ply:RemoveClothing()
	CAKE.RemoveAllGear( ply )
	ply:SetSpecialModel( "models/headcrabclassic.mdl" )
	ply:GiveItem( "headcrab_pill" )
	self:Remove()

end
