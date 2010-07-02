ITEM.Name = "UMP-45";
ITEM.Class = "weapon_mad_ump";
ITEM.Description = "A more sofisticated, .45 caliber SMG";
ITEM.Model = "models/weapons/w_smg_ump45.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 450;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:Give("weapon_mad_ump");
	self:Remove();

end
