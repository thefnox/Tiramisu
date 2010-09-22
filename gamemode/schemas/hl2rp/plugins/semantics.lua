PLUGIN.Name = "Semantics"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles word and grammar detection"; -- The description or purpose of the plugin

function CAKE.AddSemanticsCall( type, string, func, ... )


end

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "doorgroup", 1 ); --What you're wearing on your hands
	
end