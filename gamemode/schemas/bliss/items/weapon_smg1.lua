ITEM.Name = "MP-7";
ITEM.Class = "weapon_mad_mp7";
ITEM.Description = "Rapid-fire submachine gun.";
ITEM.Model = "models/weapons/w_smg1.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 350;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:Give("weapon_mad_mp7");
	self:Remove();

end
