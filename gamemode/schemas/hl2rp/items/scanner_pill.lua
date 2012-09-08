ITEM.Name = "Scanner Pill"
ITEM.Class = "scanner_pill"
ITEM.Description = "Use this to become a scanner"
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
	ply:SetSpecialModel( "models/Combine_Scanner.mdl" )
	ply:SetMoveType( MOVETYPE_FLY )
	self:Remove()

end
