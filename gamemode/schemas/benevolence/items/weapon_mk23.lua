ITEM.Name = "MK23";
ITEM.Class = "weapon_real_mk23";
ITEM.Description = "A standard single shot pistol, having pretty good accuracy and damage.";
ITEM.Model = "models/benevolence/weapons/w_MK23.mdl";
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
