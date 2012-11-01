TIRA.ItemData = {  }
TIRA.UData = {  }

util.AddNetworkString("Tiramisu.ReceiveUData")

function TIRA.LoadItem( schema, filename )

	local path = "schemas/" .. schema .. "/items/" .. filename
	AddResource("lua", path)
	
	ITEM = {  }
	
	include( path )
	
	TIRA.ItemData[ ITEM.Class ] = ITEM
	
end

function TIRA.SaveUData( id )
	local savetable = TIRA.Serialize(TIRA.UData[id])
	TIRA.Query("UPDATE tiramisu_items SET udata='" .. TIRA.StrEscape(savetable) .. "' WHERE id = '" .. id .. "'" )
end

function TIRA.LoadUData( id )
	local query = TIRA.Query("SELECT udata FROM tiramisu_items WHERE id = '".. id .. "'" )
	local tbl = TIRA.Deserialize( string.sub(query[1]["udata"],2,-2))
	if query then TIRA.UData[id] = tbl or {} else TIRA.UData[id] = {} end
end

function TIRA.SetUData( id, key, value )
	if !id then return nil end

	if !TIRA.UData[id] then
		TIRA.UData[id] = {}
	end
	TIRA.UData[id][key] = value
	TIRA.SaveUData(id)
end

function TIRA.GetUData(id, key)
	if !id or id == "none" then return nil end

	if !TIRA.UData[id] then
		TIRA.LoadUData( id )
	end
	
	if !TIRA.UData[id] or !TIRA.UData[id][key] then return nil end
	return TIRA.UData[id][key]
end

local lastostime = 0
local genned = {}
function TIRA.CreateItemID()
	local id = TIRA.GetTableNextID("tiramisu_items")
	TIRA.Query("INSERT INTO tiramisu_items (id,udata) VALUES (" .. id .. ",'" .. TIRA.Serialize({}) .. "')")
	return id

end

function TIRA.SendUData( ply, uid )
	if TIRA.UData[uid] then
		tbl = {
			["uid"] = uid,
			["wearable"] = TIRA.GetUData( uid, "wearable"),
			["container"] = TIRA.GetUData( uid, "container"),
			["name"] = TIRA.GetUData( uid, "name"),
			["model"] = TIRA.GetUData( uid, "model")
		}
		net.Start( "Tiramisu.ReceiveUData" )
			net.WriteTable(tbl)
		net.Send(ply)
	end
end

function TIRA.CreateItem( class, pos, ang, id )

	if !id then id = TIRA.CreateItemID() end
	
	if( TIRA.ItemData[ class ] == nil ) then return end
	
	local itemtable = TIRA.ItemData[ class ]
	
	local item = ents.Create( "item_prop" )
	item.uiid = id
	
	if string.match( class, "clothing" ) or string.match( class, "helmet" ) then
		item:SetModel( "models/props_c17/suitcase_passenger_physics.mdl" )
	else
		item:SetModel( TIRA.GetUData(id, "model") or itemtable.Model )
	end

	for k, v in pairs( itemtable ) do
		item[ k ] = v
	end

	item:SetAngles( ang )
	item:SetPos( pos )
	
	item:SetNWString("Name", TIRA.GetUData(id, "name") or itemtable.Name)
	item:SetNWString("Description", TIRA.GetUData(id, "description") or itemtable.Description)
	item:SetNWString("Class", itemtable.Class)
	item:SetNWString("id", id)
	
	item:Spawn( )
	item:Activate( )
	return item
	
end

function ccDropItem( ply, cmd, args )
	
	if !args[ 1 ] then return end

	if ply:HasItemID( args[ 1 ] ) then
		local class = ply:TakeItemID( args[ 1 ] )
		TIRA.CreateItem( class, ply:CalcDrop( ), Angle( 0,0,0 ), args[ 1 ] )
	end

end
concommand.Add( "rp_dropitem", ccDropItem )

function ccDropItemUnspecific( ply, cmd, args )

	if !args[ 1 ] then return end
	
	local inv =	ply:GetInventory()

	if inv:HasItem( args[ 1 ] ) then
		for _, tbl in pairs( inv.Items ) do
			for k, v in pairs(tbl) do
				TIRA.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ), v.itemid )
				ply:TakeItem( args[ 1 ] )
				return
			end
		end
	end

end
concommand.Add( "rp_dropitemunspecific", ccDropItemUnspecific )

function ccDropAllItem( ply, cmd, args )
	
	local inv =	ply:GetInventory()

	for _, tbl in pairs( inv.Items ) do
		for k, v in pairs(tbl) do
			if v.class == args[1]then
				TIRA.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ), v.itemid )
				ply:TakeItem( args[ 1 ] )
			end
		end
	end

end
concommand.Add( "rp_dropallitem", ccDropAllItem )

function ccPickupItem( ply, cmd, args )

	local item = ents.GetByIndex( tonumber( args[ 1 ] ) )
	local inv = ply:GetInventory()
	
	if inv:IsFull() then
		TIRA.SendError( ply, "Your inventory is full!" )
		return
	end

	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" and item:GetPos( ):Distance( ply:GetShootPos( ) ) <= 200 ) then
		item:Pickup( ply )
		ply:GiveItem( item.Class, item:GetNWString("id") )
	end

end
concommand.Add( "rp_pickup", ccPickupItem )

function ccUseItem( ply, cmd, args )
	
	local item = ents.GetByIndex(tonumber( args[ 1 ] ))
	local funcrun = args [ 2 ]
	
	if item and ValidEntity(item) and item:GetClass( ) == "item_prop" and item:GetPos():Distance(ply:GetShootPos()) <= 200 then
		local class = item:GetNWString("Class", "")
		if class != "" then
			if funcrun and TIRA.ItemData[ class ][funcrun] then
				funcrun = TIRA.ItemData[ class ][funcrun]
				funcrun(item, ply )
			else
				item:UseItem( ply )
			end
		end
	end

end
concommand.Add( "rp_useitem", ccUseItem )

function ccUseOnInventoryID( ply, cmd, args )
	local id = args [ 1 ]
	local class = ply:HasItemID(id) 
	local funcrun = args [ 2 ]
	
	if class then
		local item = TIRA.CreateItem( class, ply:CalcDrop( ), Angle( 0,0,0 ), id )
		if ValidEntity(item) and item:GetClass( ) == "item_prop" then
			if funcrun and TIRA.ItemData[ class ][funcrun] then
				funcrun = TIRA.ItemData[ class ][funcrun]
				funcrun(item, ply )
			else
				item:UseItem( ply )
			end
			if item then
				item:Remove()
			end
			if !TIRA.ItemData[class].Unusable then
				ply:TakeItemID( id )
			end
		end
	end

end
concommand.Add( "rp_useinventoryid", ccUseOnInventoryID)

local meta = FindMetaTable( "Player" )

function meta:GiveItem( class, id )

	if !id then id = TIRA.CreateItemID() end
	TIRA.DayLog( "economy.txt", "Adding item '" .. class .. "' to " .. TIRA.FormatCharString( self ) .. " inventory" )
	local inv = self:GetInventory()

	if inv:IsFull() then
		return
	end

	inv:AddItem(class, id)
	
	if string.match( class, "weapon" ) then
		if !self:HasWeapon(TIRA.GetUData(id, "weaponclass") or class) then
			self:Give( TIRA.GetUData(id, "weaponclass") or class )
		end
	end
	TIRA.SendUData( self, id )

	inv:Save()

end

function meta:TakeItem( class )
	local inv = self:GetInventory()

	if string.match( class, "weapon" ) and class != "weapon_base" then
		self:StripWeapon( class )
	end

	for i=1, inv.Height do
		for j=1, inv.Width do
			if !inv:IsSlotEmpty(j,i) and inv.Items[i][j].class == class then 
				umsg.Start("c_Take", TIRA.GetPlyTrackingContainer( inv.UniqueID ))
					umsg.String(inv.UniqueID)
					umsg.String(inv.Items[i][j].itemid)
				umsg.End()
				inv:Save()
				inv:ClearSlot( j, i )
				if TIRA.GetUData( inv.Items[i][j].itemid, "weaponclass" ) then
					for _, tbl in pairs( inv.Items ) do
						for k, v in pairs(tbl) do
							if TIRA.GetUData( inv.Items[i][j].itemid, "weaponclass" ) == TIRA.GetUData(v.itemid, "weaponclass") then
								count = true
								break
							end
						end
						if count then
							break
						end
					end

					if !count then
						self:StripWeapon(TIRA.GetUData(id, "weaponclass") or "nothing")
					end
				elseif string.match(class, "weapon_") and class != "weapon_base" then
					for _, tbl in pairs( inv.Items ) do
						for k, v in pairs(tbl) do
							if v.class == class then
								count = true
								break
							end
						end
						if count then
							break
						end
					end

					if !count then
						self:StripWeapon(class)
					end
				end
				inv:Save()
				return
			end
		end
	end

end

function meta:TakeItemID( id )
	local inv = self:GetInventory()
	TIRA.RemoveClothingID( self, id )
	TIRA.RemoveGearItemID( self, id )

	local class = inv:TakeItemID( id )
	TIRA.DayLog( "economy.txt", "Removing item '" .. id .. "' from " .. TIRA.FormatCharString( self ) .. " inventory" )

	local count = false

	if TIRA.GetUData( id, "weaponclass" ) then
		for _, tbl in pairs( self:GetInventory().Items ) do
			for k, v in pairs(tbl) do
				if TIRA.GetUData( v.itemid, "weaponclass" ) == TIRA.GetUData(id, "weaponclass") then
					count = true
					break
				end
			end
			if count then
				break
			end
		end

		if !count then
			self:StripWeapon(TIRA.GetUData(id, "weaponclass") or "nothing")
		end
	elseif string.match(class, "weapon_") and class != "weapon_base" then
		for _, tbl in pairs( self:GetInventory().Items ) do
			for k, v in pairs(tbl) do
				if v.class == class then
					count = true
					break
				end
			end
			if count then
				break
			end
		end

		if !count then
			self:StripWeapon(class)
		end
	end

	TIRA.SendClothingToClient( self )
	TIRA.SaveGear( self )
	TIRA.SendGearToClient( self )

	inv:Save()
	return class
	
end

function meta:ItemHasFlag( item, flag )
	
	if !TIRA.ItemData[ item ] then
		return false
	end

	if !TIRA.ItemData[ item ].Flags then
		TIRA.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( TIRA.ItemData[ item ].Flags ) do
		if type( v ) == "table" then
			for k2, v2 in pairs( v ) do
				if string.match( v2, flag ) then
					return true
				end
			end
		end
		if string.match( v, flag ) then
			return true
		end
	end
	
	return false

end

function meta:GetFlagValue( item, flag )

	if !TIRA.ItemData[ item ].Flags then
		TIRA.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( TIRA.ItemData[ item ].Flags ) do
		if type( v ) == "table" then
			for k2, v2 in pairs( v ) do
				if string.match( v2, flag ) then
					local exp = string.Explode( "", v2 )
					return exp[2] or true
				end
			end
		end
		if string.match( v, flag ) then
			local exp = string.Explode( "", v )
			return exp[2] or true
		end
	end
	
	return false

end

function meta:HasItem( class )
	local inv = self:GetInventory()
	return inv:HasItem( class )
end

function meta:HasItemID( ID )
	if !ID or ID == "none" then return false end
	local inv = self:GetInventory()
	return inv:HasItemID( ID )
end

function meta:SetUData( item, key, value )
	id = item:GetNWString("id")
	TIRA.SetUData( id, key, value )
end

function meta:GetUData( item, key )
	id = item:GetNWString("id")
	return TIRA.GetUData( id, key )
end