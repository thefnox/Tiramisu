ITEM.Name = "Steyr AUG A3";
ITEM.Class = "weapon_real_auga3";
ITEM.Description = "Fully automatic, light weight, Bullpup AR.";
ITEM.Model = "models/benevolence/weapons/w_AUGA3.mdl";
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
