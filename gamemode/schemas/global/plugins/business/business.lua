CAKE.Business = {}

local function Admin_AddBusinessLevels( ply, cmd, args )
	local target = CAKE.FindPlayer(args[1])
	if target then
		table.remove( args, 1 )
		local buygroups = {}
		for _, v in pairs( args ) do
			table.insert( buygroups, tonumber( v ))
		end
		CAKE.SetCharField( target, "business", buygroups )
		if #buygroups < 1 then
			buygroups[1] = "none"
		end
		CAKE.SendConsole( ply, target:Nick() .. " buy groups set to: " .. table.concat( buygroups, ", ") .. ".")
		CAKE.SendConsole( target, "You buy groups have been set to to: " .. table.concat( buygroups, ", ") .. ".")
	else
		CAKE.SendConsole( ply, "Target not found!")
	end

end

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

	local buygroups = CAKE.GetCharField(ply, "business")
	
	if !CAKE.ItemData[class] or !CAKE.ItemData[class].Purchaseable then return "Item not purchaseable!" end
	if !table.HasValue(buygroups, CAKE.ItemData[class].ItemGroup) then return "You're not allowed to buy that!" end
	if !(CAKE.GetCharField(ply, "money") > CAKE.ItemData[class].Price) then return "Not enough money!" end

	CAKE.ChangeMoney( ply, - CAKE.ItemData[class].Price)
	ply:GiveItem(class)

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

local meta = FindMetaTable( "Player" )

--Sends a player's business data through Datastream.
function meta:RefreshBusiness()

	local buygroups = CAKE.GetCharField(self, "business") or {}

	if table.Count(buygroups) > 0 then
		local tbl = {}
		for k,v in pairs(buygroups) do
			if CAKE.Business[v] then
				tbl[v] = CAKE.Business[v]
			end
		end
		datastream.StreamToClients( self, "refreshbusiness", tbl )
	else
		datastream.StreamToClients( self, "refreshbusiness", false )
	end

end

hook.Add( "InitPostEntity", "TiramisuBuildItemGroups", function() 
	CAKE.BuildItemGroups()
end)

concommand.Add( "rp_openbusinessmenu", function(ply, cmd, args)
	ply:RefreshBusiness()
end)

function PLUGIN.Init()
	CAKE.AddDataField( 2, "business", {} ) 
	CAKE.AdminCommand( "addbusiness", Admin_AddBusinessLevels, "Give someone access to a certain buygroup", true, true, 2 )
end