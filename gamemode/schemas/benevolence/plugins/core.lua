PLUGIN.Name = "Core Schema Plugin"; -- What is the plugin name
PLUGIN.Author = "F-Nox/Big Bang"; -- Author of the plugin
PLUGIN.Description = "Configures the schema"; -- The description or purpose of the plugin

function PLUGIN.Init()

	CAKE.MenuFont = "decipher"
	
	CAKE.AddDataField( 2, "title2", "" ); -- What is their default title.
	CAKE.AddDataField( 2, "birthplace", "Unknown" ) --So mysterious...
	CAKE.AddDataField( 2, "gender", "Male" ) -- MAN POWER
	CAKE.AddDataField( 2, "alignment", "True Neutral" ) --Like fucking Switzerland
	CAKE.AddDataField( 2, "description", "" ) --Even more mysterious...
	CAKE.AddDataField( 2, "age", 30 ) --Can't think of any puns.
	CAKE.AddDataField( 2, "height", 1 ) --Fun fact, 1 unit of height equals 170cm, or roughly 5'10".
	CAKE.AddDataField( 2, "race", "Infantry" ) --Race will be changed to class soon
	CAKE.AddDataField( 2, "alignment", "True Neutral" )
	CAKE.AddDataField( 2, "buygroups", { 0 } )
	CAKE.AddDataField( 2, "group", "None" )
	CAKE.AddDataField( 2, "grouprank", "None" )
	
end