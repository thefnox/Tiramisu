TIRA.Business = {}

--Buys an item.
function TIRA.BuyItem( ply, class )

	local buygroups = TIRA.GetCharField(ply, "business")
	
	if !TIRA.ItemData[class] or !TIRA.ItemData[class].Purchaseable then return "Item not purchaseable!" end
	if !table.HasValue(buygroups, TIRA.ItemData[class].ItemGroup) then return "You're not allowed to buy that!" end

	ply:GiveItem(class)

	return true
end