ITEM.Name = "Katana";
ITEM.Class = "gear_katana";
ITEM.Description = "Contrary to popular belief, Katanas are NOT better.";
ITEM.Model = "models/props_tes/akaviri_longsword_sword.mdl";
ITEM.Purchaseable = false;	
ITEM.Price = 0;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end


function ITEM:UseItem(ply)

end
