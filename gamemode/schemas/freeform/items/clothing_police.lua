ITEM.Name = "Standard Police Armor"
ITEM.Class = "clothing_police"
ITEM.Description = "The standard for metrocops."
ITEM.Model = "models/Police.mdl"
ITEM.Purchaseable = false
ITEM.Price = 500
ITEM.ItemGroup = 2
ITEM.Unusable = true

ITEM.Flags = {
	"armor70",
	"shieldratio0.7",
	"explosivearmor1.5",
	"kineticarmor0.6",
	"bulletarmor0.7"
}

ITEM.Content = {
	"materials/models/police/metrocop_sheet.vmt",
	"models/Police.mdl"
}

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

end
