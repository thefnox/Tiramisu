ITEM.Name = "FAMAS-F1 Assault Rifle";
ITEM.Class = "weapon_mad_famas";
ITEM.Description = "Burst fire, 5.56mm, very reliable";
ITEM.Model = "models/weapons/w_rif_famas.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 600;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();
	
end
