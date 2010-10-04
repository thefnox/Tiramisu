ITEM.Name = "Ration";
ITEM.Class = "ration";
ITEM.Description = "Combine-Issue Citizen Ration";
ITEM.Model = "models/weapons/w_package.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 0;

function ITEM:Drop(ply)



end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say /me opens up his rations");
	CAKE.ChangeMoney(ply, CAKE.ConVars["RationMoney"]);
	self:Remove();

end
