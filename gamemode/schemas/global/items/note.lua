ITEM.Name = "Note";
ITEM.Class = "note";
ITEM.Description = "";
ITEM.Model = "models/props_c17/paper01.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 3;
ITEM.ItemGroup = 3;
ITEM.Stack = false

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	myid = self:GetNWString("id")
	datastream.StreamToClients( {ply}, "ReadStream", {["title"] = CAKE.GetUData(myid, "name"), ["text"] = CAKE.GetUData(myid, "text")})
	ply:GiveItem("note", myid)
	self:Remove()

end
