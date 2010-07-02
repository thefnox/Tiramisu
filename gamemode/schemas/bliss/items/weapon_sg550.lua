ITEM.Name = "SG550 Marksman Rifle";
ITEM.Class = "weapon_mad_sg550";
ITEM.Description = "Highly precise and semi automatic";
ITEM.Model = "models/weapons/w_snip_sg550.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1500;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();
	
end
