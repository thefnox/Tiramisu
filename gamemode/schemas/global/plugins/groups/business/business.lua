CAKE.Business = {}

--Copies all buyable items on the CAKE.Business table.
function CAKE.BuildItemGroups()
	local tbl = {}
	for k,v in pairs(CAKE.ItemData) do
		if !CAKE.Business[v.ItemGroup] then CAKE.Business[v.ItemGroup] = {} end
		if v.Purchaseable then
			tbl = {}
			tbl.Class = v.Class
			tbl.Model = v.Model
			tbl.Name = v.Name
			tbl.Description = v.Description .. "\nPrice: " .. v.Price
			tbl.Price = v.Price
			table.insert(CAKE.Business[v.ItemGroup], tbl)
		end
	end
end

--Buys an item.
function CAKE.BuyItem( ply, class )

	local group = CAKE.GetCharField(ply, "group")
	local rank = CAKE.GetCharField(ply, "grouprank")
	
	if !CAKE.ItemData[class] or !CAKE.ItemData[class].Purchaseable then return "Item not purchaseable!" end
	if !table.HasValue(CAKE.GetRankField(group, rank, "buygroups"), CAKE.ItemData[class].ItemGroup) then
		return "You're not allowed to buy that!" 
	end
	if !(CAKE.GetCharField(ply, "money") > CAKE.ItemData[class].Price) then return "Not enough money!" end
	CAKE.ChangeMoney( ply, - CAKE.ItemData[class].Price)
	ply:GiveItem(class)
	ply:RefreshInventory()
	return true
end

--Concommand for buying an item. Arguments: item_class
function ccBuyItem(ply, cmd, args)

	local class = args[1]
	local bought = CAKE.BuyItem(ply, class)
	if !bought then
		CAKE.SendError(ply, bought)
	end

end
concommand.Add( "rp_buyitem", ccBuyItem)	

local meta = FindMetaTable( "Player" );

--Sends a player's business data through Datastream.
function meta:RefreshBusiness()

	local group = CAKE.GetCharField(self, "group")
	local rank = CAKE.GetCharField(self, "grouprank")
	if CAKE.GetRankField(group, rank, "buygroups") then
		local tbl = {}
		for k,v in pairs(CAKE.GetRankField(group, rank, "buygroups") or {}) do
			if CAKE.Business[v] then
				tbl[v] = CAKE.Business[v]
			end
		end
		datastream.StreamToClients( self, "refreshbusiness", tbl )
	else
		datastream.StreamToClients( self, "refreshbusiness", false )
	end

end

hook.Add( "PlayerSpawn", "TiramisuRefreshBusiness", function( ply )
	if ply:IsCharLoaded() then
		ply:RefreshBusiness( )
	end
end)

function PLUGIN.Init()
	CAKE.BuildItemGroups()
end