ITEM.Name = "SG552 Carbine";
ITEM.Class = "weapon_mad_sg552";
ITEM.Description = "Full auto, 5.56mm, deadly as none";
ITEM.Model = "models/weapons/w_rif_sg552.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 900;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();
	
end
