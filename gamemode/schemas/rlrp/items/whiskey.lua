ITEM.Name = "Whiskey";
ITEM.Class = "whiskey";
ITEM.Description = "Drink till she's pretty again.";
ITEM.Model = "models/props_junk/glassjug01.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 15;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	CAKE.DrugPlayer(ply, 2);
	ply:ConCommand("say /me drinks some whiskey");
	self:Remove();

end
