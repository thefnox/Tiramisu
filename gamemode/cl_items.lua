function CAKE.AddItems( schema, global )

	local filename = filename or ""
	local path = CAKE.Name .. "/gamemode/schemas/" .. schema .. "/items/"
	if global then
		path = CAKE.Name .. "/gamemode/items/"
	end
	local files, folders = file.Find( path .. "*", "LUA" )

	for k, v in pairs( files ) do
		ITEM = {  }
		include( path .. v )
		for k,v in pairs(ITEM) do
			if type(v) == "function" then
				ITEM[k] = nil
			end
		end
		CAKE.ItemData[ ITEM.Class ] = ITEM
	end

end

hook.Add("OnEntityCreated", "Tiramisu.SetItemPropertiesClientside", function( item )

	if item:GetClass()=="item_prop" then
		local itemtable = CAKE.ItemData[ item:GetNWString("Class") ]
		if itemtable then
			for k, v in pairs( itemtable ) do
				item[ k ] = v
			end
		end
	end

end)