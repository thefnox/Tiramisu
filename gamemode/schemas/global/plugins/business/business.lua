CAKE.Business = {}
print("BITCH IS LOADED ND READY TO FIRE")
function CAKE.BuildItemGroups()
	for k,v in pairs(CAKE.Items) do
		if !CAKE.Business[v.ItemGroup] then CAKE.Business[v.ItemGroup] = {} end
		table.insert(CAKE.Business[v.ItemGroup], v.Class)
	end
end

function CAKE.BuyItem( ply, class )
	group = CAKE.GetCharField(ply, "group")
	rank = CAKE.GetCharField(ply, "grouprank")
	
	if !CAKE.Items[class] or !CAKE.Items[class].Purchaseable then return "Item not purchaseable!" end
	if group == "none" or group == "None" then return "Not a member of a group!" end
	if !CAKE.GetRankField(group, rank, "canbuy") then return "You're not allowed to buy that!" end
	if !table.HasValue(CAKE.GetRankField(group, rank, "buygroups"), CAKE.Items[class].ItemGroup) then
		return "You're not allowed to buy that!" 
	end
	if !(CAKE.GetCharField(ply, "money") > CAKE.Items[class].Price) then return "Not enough money!" end
	
	CAKE.ChangeMoney( ply, -CAKE.Items[class].Price)
	ply:GiveItem(class)
	return true
end

function ccBuyItem(ply, class)
	bought = CAKE.BuyItem(ply, class)
	if !(bought == true) then
		CAKE.SendError(ply, bought)
	end
end
concommand.Add( "rp_buyitem", ccBuyItem)	

local meta = FindMetaTable( "Player" );

function meta:ClearBusiness(ply)
	--STUB BRO STUB
end

function meta:RefreshBusiness(ply)
	group = CAKE.GetCharField(ply, "group")
	rank = CAKE.GetCharField(ply, "grouprank")
	for k,v in pairs(CAKE.GetRankField(group, rank, "buygroups") or {})
		table.add
end

function PLUGIN.Init()
	CAKE.BuildItemGroups()
end