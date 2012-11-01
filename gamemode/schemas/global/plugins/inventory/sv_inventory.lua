local meta = FindMetaTable("Player")
util.AddNetworkString("Tiramisu.SendInventory")

hook.Add( "TiramisuPostPlayerLoaded", "TiramisuLoadGroups", function( ply, firsttime )
	local SteamID = TIRA.FormatText(ply:SteamID())
	if !firsttime then
		for uid, char in pairs( TIRA.GetPlayerField( ply, "characters" ) ) do
			local invent = TIRA.GetCharField(ply, "inventory", char)
			if invent and (type(invent) == "table" or invent == "none") then
				invent = TIRA.CreatePlayerInventory( ply, char )
			elseif invent and type(invent) == "string" then
				if !TIRA.ContainerExists(invent) then
					TIRA.SetCharField( ply, "inventory", TIRA.CreatePlayerInventory( ply, char ))
				else
					TIRA.LoadContainer( invent )
					local container = TIRA.GetContainer(invent)
					if TIRA.ConVars[ "PlayerInventoryRows" ] < 1 and !container:GetInfinite() then
						container:SetInfinite( true )
					else
						if container.Height > TIRA.ConVars[ "PlayerInventoryRows" ] then
							for i=TIRA.ConVars[ "PlayerInventoryRows" ]+1, container.Height do
								container.Items[i] = nil
							end
							container.Height = TIRA.ConVars[ "PlayerInventoryRows" ]
						elseif container.Height < TIRA.ConVars[ "PlayerInventoryRows" ] then
							for i=container.Height+1, TIRA.ConVars[ "PlayerInventoryRows" ] do
								container.Items[i] = {}
								for j=1, container.Width do
									container.Items[i][j] = {}
								end
							end
							container.Height = TIRA.ConVars[ "PlayerInventoryRows" ]
						end
					end
					container:SetNonRecursive(!TIRA.ConVars[ "StaticInventory" ])
				end
			end
		end
	end
end)

function TIRA.CreatePlayerInventory( ply, uid )
	uid = uid or ply:GetNWString("uid")
	local container = TIRA.CreateContainerObject()
	if TIRA.ConVars[ "PlayerInventoryRows" ] < 1 then
		container:SetSize(10,4)
		container:SetInfinite( true )
	else
		container:SetSize(10,TIRA.ConVars[ "PlayerInventoryRows" ])
	end
	container:SetNonRecursive(!TIRA.ConVars[ "StaticInventory" ])
	container.Char = TIRA.FormatText(ply:SteamID()) .. ";" .. uid
	container:Save()
	return container.UniqueID
end

function meta:GetInventory()
	if self:IsCharLoaded() then
		local inventory = TIRA.GetCharField( self, "inventory" )
		if type(inventory) == "table" or inventory == "none" or !inventory then
			inventory = TIRA.CreatePlayerInventory( self )
			TIRA.SetCharField( self, "inventory", inventory)
		end
		return TIRA.GetContainer( inventory )
	end
end

function meta:RefreshInventory( )

	local newtbl = {}
	local inventory = TIRA.GetCharField( self, "inventory" )

	if type(inventory) == "table" or inventory == "none" then
		inventory = TIRA.CreatePlayerInventory( self )
	end

	local container
	if !inventory then
		container = TIRA.CreateContainerObject()
		inventory = container.UniqueID
	else
		container = TIRA.GetContainer( inventory )
	end

	local udata = {}

	if !self.TrackingContainers then
		self.TrackingContainers = {}
	end

	if !table.HasValue(self.TrackingContainers, container.UniqueID) then
		table.insert(self.TrackingContainers, container.UniqueID)
	end

	for i=1, container.Height do
		for j=1, container.Width do
			if !container:IsSlotEmpty( j, i ) then
				if !TIRA.ItemData[ container.Items[i][j].class ] then
					container:ClearSlot( j, i )
				else
					if container.Items[i][j] and container.Items[i][j].itemid then
						local tbl = {}
						tbl.Name = TIRA.GetUData( container.Items[i][j].itemid, "name" )
						tbl.Model = TIRA.GetUData( container.Items[i][j].itemid, "model" )
						tbl.Wearable = TIRA.ItemData[ container.Items[i][j].class ].Wearable or TIRA.GetUData( container.Items[i][j].itemid, "wearable" )
						tbl.Container = TIRA.GetUData( container.Items[i][j].itemid, "container" )
						udata[container.Items[i][j].itemid] = tbl
					end
				end
			end
		end
	end

	net.Start( "Tiramisu.SendInventory")
		net.WriteTable({
			["items"] = container.Items,
			["uid"] = container.UniqueID,
			["width"] = container.Width,
			["height"] = container.Height,
			["udata"] = udata
		})
	net.Send(self)

	TIRA.SetCharField( self, "inventory", inventory)

end

function PLUGIN.Init()
	TIRA.AddDataField( 2, "inventory", "none" )
end