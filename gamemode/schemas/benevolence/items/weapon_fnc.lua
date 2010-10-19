ITEM.Name = "FNC";
ITEM.Class = "weapon_real_fnc";
ITEM.Description = "Fully automatic, light weight, misc combat rifle.";
ITEM.Model = "models/benevolence/weapons/w_FNC.mdl";
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
