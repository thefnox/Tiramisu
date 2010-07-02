ITEM.Name = "EV-7e Exosuit Helmet";
ITEM.Class = "helmet_soldier";
ITEM.Description = "Full head protection. Features an in helmet comm and targeting aid.";
ITEM.Model = "models/Combine_Soldier.mdl";
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
