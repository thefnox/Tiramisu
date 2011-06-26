ITEM.Name = "Book";
ITEM.Class = "book";
ITEM.Description = "Write stuff in it.";
ITEM.Model = "models/props_lab/binderblue.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 3;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	myid = self:GetNWString("id")
	CAKE.SendChat(ply, CAKE.GetUData(myid, "text"))
	ply:GiveItem("book", myid)
	self:Remove();

end
