PLUGIN.Name = "WriteFile"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles writing to Lua files"; -- The description or purpose of the plugin

--Credits to Hexeh for his gm_rawio module.

function CAKE.WriteToFile( str, filepath, filename )
	if rawio then
		local filewrite = rawio.writefile( util.RelativePathToFull( filepath ) .. "/" .. filename, str )
		if !filewrite or filewrite == 0 then
			print( "File write failed!" )
			return false
		end
	else
		file.Write(  filepath .. "/" .. filename, str )
	end
	return true
	
end

function CAKE.ReadFile( filepath, filename )

	local fileread = rawio.readfile( util.RelativePathToFull( filepath ) .. filename )
	if !fileread or fileread == 0 then
		print( "File read operation failed!" )
		return false
	end
	return fileread
	
end

function CAKE.WriteItem( name, tbl )

	local tblstring = ""
	local functionstring = [[function ITEM:Drop(ply)

	end

	function ITEM:Pickup(ply)

		self:Remove();

	end
	
	function ITEM:UseItem(ply)

	end
	]]
	for k, v in pairs( tbl ) do
		if type( v ) == "table" then
			tblstring = tblstring .. "ITEM." .. table.ToString( v, tostring( k ), false ) .. "\n"
		elseif type( v ) == "string" then
			tblstring = tblstring .. "ITEM." .. tostring( k ) .. " = \"" .. tostring( v ) .. "\"\n"
		else
			tblstring = tblstring .. "ITEM." .. tostring( k ) .. " = " .. tostring( v ) .. "\n"
		end
	end
	print( tblstring .. functionstring )
	
	--CAKE.WriteToFile( tblstring .. functionstring, "gamemodes/tiramisu/gamemode/" .. CAKE.ConVars[ "Schema" ] .. "/items", name .. ".lua" )
	
end