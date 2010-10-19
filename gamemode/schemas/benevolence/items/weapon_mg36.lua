ITEM.Name = "MG36";
ITEM.Class = "weapon_real_mg36";
ITEM.Description = "Fully automatic, fairly heavy, semi-good accuracy LMG.";
ITEM.Model = "models/benevolence/weapons/w_MG36.mdl";
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
