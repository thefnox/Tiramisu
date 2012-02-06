CAKE.Business = {}

--Buys an item.
function CAKE.BuyItem( ply, class )

	local buygroups = CAKE.GetCharField(ply, "business")
	
	if !CAKE.ItemData[class] or !CAKE.ItemData[class].Purchaseable then return "Item not purchaseable!" end
	if !table.HasValue(buygroups, CAKE.ItemData[class].ItemGroup) then return "You're not allowed to buy that!" end

	ply:GiveItem(class)

	return true
end