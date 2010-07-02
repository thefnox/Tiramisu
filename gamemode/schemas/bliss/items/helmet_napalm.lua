ITEM.Name = "NAPALM.32 Helmet";
ITEM.Class = "helmet_napalm";
ITEM.Description = "";
ITEM.Model = "models/napalm_atc/slow.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 300;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
