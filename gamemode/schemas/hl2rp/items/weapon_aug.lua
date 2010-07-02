ITEM.Name = "Steyr AUG A1 Bullpup Rifle";
ITEM.Class = "weapon_mad_aug";
ITEM.Description = "Bullpup configuration, 5.56mm, scoped";
ITEM.Model = "models/weapons/w_rif_aug.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 800;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();
	
end
