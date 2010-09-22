ITEM.Name = "Elite Helmet";
ITEM.Class = "helmet_elite";
ITEM.Description = "Advanced protection. In visor display and all";
ITEM.Model = "models/Combine_Super_Soldier.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 350;
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
