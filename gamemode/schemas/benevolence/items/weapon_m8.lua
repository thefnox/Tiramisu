ITEM.Name = "M8";
ITEM.Class = "weapon_real_m8";
ITEM.Description = "Fully automatic, light weight, marksman rifle. Cancelled in 2005 and brought back in 2017, with remodelled mechanics.";
ITEM.Model = "models/benevolence/weapons/w_M8.mdl";
ITEM.Purchaseable = false;
ITEM.Price = -1;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();
	
end
