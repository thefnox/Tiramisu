ITEM.Name = "Breens Reserve";
ITEM.Class = "breensreserve";
ITEM.Description = "Breens 'special' water";
ITEM.Model = "models/props_junk/popcan01a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 4;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say /me drinks some water");
	self:Remove();

end
