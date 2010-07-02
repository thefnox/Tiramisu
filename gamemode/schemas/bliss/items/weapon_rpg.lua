ITEM.Name = "RPG-7";
ITEM.Class = "weapon_mad_rpg";
ITEM.Description = "Aim away from face.";
ITEM.Model = "models/weapons/w_rocket_launcher.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 800;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:Give("weapon_mad_rpg");
	self:Remove();

end
