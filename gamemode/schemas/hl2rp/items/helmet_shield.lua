ITEM.Name = "Shield Helmet";
ITEM.Class = "helmet_shield";
ITEM.Description = "Head protection. Shield Squad Standard.";
ITEM.Model = "models/eliteghostcp.mdl";
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
