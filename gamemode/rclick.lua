function CAKE.LoadRClick( schema, filename )

	local path = "schemas/" .. schema .. "/rclick/" .. filename;
	print( path )
	AddResource("lua", path)
	
end
