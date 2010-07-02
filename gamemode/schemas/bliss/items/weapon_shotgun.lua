ITEM.Name = "SPAS-12 Shotgun";
ITEM.Class = "weapon_mad_spas";
ITEM.Description = "Dual Action Shotgun";
ITEM.Model = "models/weapons/w_shotgun.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 600;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:Give("weapon_mad_spas");
	self:Remove();

end
