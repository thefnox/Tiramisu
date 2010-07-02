ITEM.Name = "Dual Beretta Elites";
ITEM.Class = "weapon_mad_dual";
ITEM.Description = "Power multiplied by two.";
ITEM.Model = "models/weapons/w_pist_elite_dropped.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 950;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();
	
end
