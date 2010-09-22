PLUGIN.Name = "Core Schema Plugin"; -- What is the plugin name
PLUGIN.Author = "F-Nox/Big Bang"; -- Author of the plugin
PLUGIN.Description = "Configures the schema"; -- The description or purpose of the plugin

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "title2", "" ); -- What is their default title.
	CAKE.AddDataField( 2, "birthplace", "Unknown" ) --So mysterious...
	CAKE.AddDataField( 2, "gender", "Male" ) -- MAN POWER
	CAKE.AddDataField( 2, "alignment", "True Neutral" ) --Like fucking Switzerland
	CAKE.AddDataField( 2, "description", "" ) --Even more mysterious...
	CAKE.AddDataField( 2, "age", 30 ) --Can't think of any puns.
	CAKE.AddDataField( 2, "height", 1 ) --Fun fact, 1 unit of height equals 170cm, or roughly 5'10".
	CAKE.AddDataField( 2, "race", "Human" ) --Race as in species, not differences in skin color you fucking supremacist.
	CAKE.AddDataField( 2, "alignment", "True Neutral" )
	CAKE.AddDataField( 2, "buygroups", { 0 } )
	CAKE.AddDataField( 2, "group", "None" )
	CAKE.AddDataField( 2, "grouprank", "None" )
	
	CAKE.AddCType("models/props_junk/wood_crate001a_damagedmax.mdl", 16)
	CAKE.AddCType("models/props_junk/wood_crate001a_damaged.mdl", 16)
	CAKE.AddCType("models/props_junk/wood_crate001a.mdl", 8)
	CAKE.AddCType("models/props_junk/wood_crate002a.mdl", 8)
	CAKE.AddCType("models/props_junk/trashdumpster01a.mdl", 28)
	CAKE.AddCType("models/props_wasteland/controlroom_filecabinet002a.mdl", 6)
	CAKE.AddCType("models/props_wasteland/controlroom_storagecloset001a.mdl", 16)
	CAKE.AddCType("models/props_wasteland/controlroom_storagecloset001b.mdl", 20)
	CAKE.AddCType("models/props_wasteland/controlroom_filecabinet001a.mdl", 4)
	CAKE.AddCType("models/props_c17/suitcase_passenger_physics.mdl", 5)
	CAKE.AddCType("models/props_c17/suitcase001a.mdl", 8)
	CAKE.AddCType("models/props_c17/furnituredresser001a.mdl", 10)
	CAKE.AddCType("models/props_c17/furniturefridge001a.mdl", 16)
	CAKE.AddCType("models/props_c17/furnituredrawer003a.mdl", 6)
	CAKE.AddCType("models/props_c17/FurnitureDrawer001a.mdl", 6)
	CAKE.AddCType("models/items/ammocrate_rockets.mdl", 20)
	CAKE.AddCType("models/items/item_item_crate.mdl", 12)
	CAKE.AddCType("models/items/ammocrate_smg1.mdl", 20)
	CAKE.AddCType("models/items/ammocrate_ar2.mdl", 20)
	CAKE.AddCType("models/items/ammocrate_grenade.mdl", 10)
	CAKE.AddCType("models/weapons/w_suitcase_passenger.mdl", 5)
	
end