ITEM.Name = "Container"
ITEM.Class = "container_base"
ITEM.Description = ""
ITEM.Model = "models/error.mdl"
ITEM.Purchaseable = false
ITEM.Price = 0
ITEM.ItemGroup = 1
ITEM.Stack = false
ITEM.Unusable = true
ITEM.RightClick = {
	["Open"] = "UseItem",
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)

	local id = self:GetNWString("id")
	if CAKE.GetUData(id, "container") then
		CAKE.OpenContainer( ply, CAKE.GetUData(id, "container") )
	end

end