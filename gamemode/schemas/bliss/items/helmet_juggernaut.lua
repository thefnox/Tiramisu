ITEM.Name = "'Juggernaut' Exosuit Helmet";
ITEM.Class = "helmet_juggernaut";
ITEM.Description = "Versatile helmet with all sorts of technology on it";
ITEM.Model = "models/mw2guy/riot/juggernaut.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 200;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
