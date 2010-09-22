ITEM.Name = "Vice Helmet";
ITEM.Class = "helmet_vice";
ITEM.Description = "Head protection. Vice Squad Standard.";
ITEM.Model = "models/Javelin_Unit.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 100;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"overlay;1",
	"headprotection;0.8"
}

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
