local meta = FindMetaTable("Player")
util.AddNetworkString("Tiramisu.SendInventory")
util.AddNetworkString("Tiramisu.ReceiveUData")

hook.Add( "TiramisuPostPlayerLoaded", "TiramisuLoadGroups", function( ply, firsttime )
	local SteamID = CAKE.FormatText(ply:SteamID())
	if !firsttime then
		for uid, char in pairs( CAKE.GetPlayerField( ply, "characters" ) ) do
			local invent = CAKE.GetCharField(ply, "inventory", char)
			if invent and (type(invent) == "table" or invent == "none") then
				invent = CAKE.CreatePlayerInventory( ply, uid )
			elseif invent and type(invent) == "string" then
				if !CAKE.ContainerExists(invent) then
					CAKE.SetCharField( ply, "inventory", CAKE.CreatePlayerInventory( ply, uid ))
				else
					CAKE.LoadContainer( invent )
					local container = CAKE.GetContainer(invent)
					if CAKE.ConVars[ "PlayerInventoryRows" ] < 1 and !container:GetInfinite() then
						container:SetInfinite( true )
					else
						if container.Height > CAKE.ConVars[ "PlayerInventoryRows" ] then
							for i=CAKE.ConVars[ "PlayerInventoryRows" ]+1, container.Height do
								container.Items[i] = nil
							end
							container.Height = CAKE.ConVars[ "PlayerInventoryRows" ]
						elseif container.Height < CAKE.ConVars[ "PlayerInventoryRows" ] then
							for i=container.Height+1, CAKE.ConVars[ "PlayerInventoryRows" ] do
								container.Items[i] = {}
								for j=1, container.Width do
									container.Items[i][j] = {}
								end
							end
							container.Height = CAKE.ConVars[ "PlayerInventoryRows" ]
						end
					end
					container:SetNonRecursive(!CAKE.ConVars[ "StaticInventory" ])
				end
			end
		end
	end
end)

function CAKE.CreatePlayerInventory( ply, uid )
	uid = uid or ply:GetNWString("uid")
	local container = CAKE.CreateContainerObject()
	if CAKE.ConVars[ "PlayerInventoryRows" ] < 1 then
		container:SetSize(10,4)
		container:SetInfinite( true )
	else
		container:SetSize(10,CAKE.ConVars[ "PlayerInventoryRows" ])
	end
	container:SetNonRecursive(!CAKE.ConVars[ "StaticInventory" ])
	container.Char = CAKE.FormatText(ply:SteamID()) .. ";" .. uid
	container:Save()
	return container.UniqueID
end

function meta:GetInventory()
	if self:IsCharLoaded() then
		local inventory = CAKE.GetCharField( self, "inventory" )
		if type(inventory) == "table" or inventory == "none" or !inventory then
			inventory = CAKE.CreatePlayerInventory( self )
			CAKE.SetCharField( self, "inventory", inventory)
		end
		return CAKE.GetContainer( inventory )
	end
end

function meta:RefreshInventory( )

	MsgN("\nRefreshing inventory for ",self:SteamID())

	local newtbl = {}
	local inventory = CAKE.GetCharField( self, "inventory" )

	if type(inventory) == "table" or inventory == "none" then
		inventory = CAKE.CreatePlayerInventory( self )
	end

	local container
	if !inventory then
		container = CAKE.CreateContainerObject()
		inventory = container.UniqueID
	else
		container = CAKE.GetContainer( inventory )
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
				if !CAKE.ItemData[ container.Items[i][j].class ] then
					container:ClearSlot( j, i )
				else
					if container.Items[i][j] and container.Items[i][j].itemid then
						local tbl = {}
						tbl.Name = CAKE.GetUData( container.Items[i][j].itemid, "name" )
						tbl.Model = CAKE.GetUData( container.Items[i][j].itemid, "model" )
						tbl.Wearable = CAKE.ItemData[ container.Items[i][j].class ].Wearable or CAKE.GetUData( container.Items[i][j].itemid, "wearable" )
						tbl.Container = CAKE.GetUData( container.Items[i][j].itemid, "container" )
					end
				end
			end
		end
	end

	net.Start( "Tiramisu.SendInventory")
		MsgN("Sending inventory ID ", container.UniqueID)
		net.WriteTable({
			["items"] = container.Items,
			["uid"] = container.UniqueID,
			["width"] = container.Width,
			["height"] = container.Height,
		})
	net.Send(self)
	timer.Simple(1, function()
	for i=1, container.Height do
		for j=1, container.Width do
			if !container:IsSlotEmpty( j, i ) then
				if !CAKE.ItemData[ container.Items[i][j].class ] then
					container:ClearSlot( j, i )
				else
					if container.Items[i][j] and container.Items[i][j].itemid then
						CAKE.SendUData( self, container.Items[i][j].itemid )
					end
				end
			end
		end
	end
	end)

	CAKE.SetCharField( self, "inventory", inventory)

end

function PLUGIN.Init()
	CAKE.AddDataField( 2, "inventory", "none" )
end