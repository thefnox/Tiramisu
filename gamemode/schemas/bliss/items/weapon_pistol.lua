ITEM.Name = "USP Match";
ITEM.Class = "weapon_mad_usp_match";
ITEM.Description = "A civilized weapon for civilized times.";
ITEM.Model = "models/weapons/w_pistol.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 200;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:Give("weapon_mad_usp_match");
	self:Remove();

end
