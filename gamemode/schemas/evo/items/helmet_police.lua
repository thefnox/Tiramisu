ITEM.Name = "Police Helmet";
ITEM.Class = "helmet_police";
ITEM.Description = "Head protection. Possesses an embedded breather.";
ITEM.Model = "models/Police.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 100;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"overlay;1",
	"headprotection;0.8"
}
ITEM.Content = {
	"materials/models/police/metrocop_sheet.vmt",
	"models/Police.mdl"
}


function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
