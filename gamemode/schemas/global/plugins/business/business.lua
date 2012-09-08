TIRA.Business = {}

local function Admin_AddBusinessLevels( ply, cmd, args )
	local target = TIRA.FindPlayer(args[1])
	if target then
		table.remove( args, 1 )
		local buygroups = {}
		for _, v in pairs( args ) do
			table.insert( buygroups, tonumber( v ))
		end
		TIRA.SetCharField( target, "business", buygroups )
		if #buygroups < 1 then
			buygroups[1] = "none"
		end
		TIRA.SendConsole( ply, target:Nick() .. " buy groups set to: " .. table.concat( buygroups, ", ") .. ".")
		TIRA.SendConsole( target, "You buy groups have been set to to: " .. table.concat( buygroups, ", ") .. ".")
	else
		TIRA.SendConsole( ply, "Target not found!")
	end

end

--Copies all buyable items on the TIRA.Business table.
function TIRA.BuildItemGroups()
	local tbl = {}
	for k,v in pairs(TIRA.ItemData) do
		if !TIRA.Business[v.ItemGroup] then TIRA.Business[v.ItemGroup] = {} end
		if v.Purchaseable then
			table.insert(TIRA.Business[v.ItemGroup], v.Class)
		end
	end
end

--Buys an item.
function TIRA.BuyItem( ply, class )

	local buygroups = TIRA.GetCharField(ply, "business")
	
	if !TIRA.ItemData[class] or !TIRA.ItemData[class].Purchaseable then return "Item not purchaseable!" end
	if !table.HasValue(buygroups, TIRA.ItemData[class].ItemGroup) then return "You're not allowed to buy that!" end
	if !(TIRA.GetCharField(ply, "money") > TIRA.ItemData[class].Price) then return "Not enough money!" end

	TIRA.ChangeMoney( ply, - TIRA.ItemData[class].Price)
	ply:GiveItem(class)

	return true
end

--Concommand for buying an item. Arguments: item_class
function ccBuyItem(ply, cmd, args)

	local class = args[1]
	local bought = TIRA.BuyItem(ply, class)
	if !bought then
		TIRA.SendError(ply, bought)
	end

end
concommand.Add( "rp_buyitem", ccBuyItem)	

local meta = FindMetaTable( "Player" )

--Sends a player's business data through Datastream.
function meta:RefreshBusiness()

	local buygroups = TIRA.GetCharField(self, "business") or {}

	if table.Count(buygroups) > 0 then
		local tbl = {}
		for k,v in pairs(buygroups) do
			if TIRA.Business[v] then
				tbl[v] = TIRA.Business[v]
			end
		end
		datastream.StreamToClients( self, "refreshbusiness", tbl )
	else
		datastream.StreamToClients( self, "refreshbusiness", false )
	end

end

hook.Add( "InitPostEntity", "TiramisuBuildItemGroups", function() 
	TIRA.BuildItemGroups()
end)

concommand.Add( "rp_openbusinessmenu", function(ply, cmd, args)
	ply:RefreshBusiness()
end)

function PLUGIN.Init()
	TIRA.AddDataField( 2, "business", {} ) 
	TIRA.AdminCommand( "addbusiness", Admin_AddBusinessLevels, "Give someone access to a certain buygroup", true, true, 2 )
end