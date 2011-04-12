PLUGIN.Name = "Core Schema Plugin"; -- What is the plugin name
PLUGIN.Author = "F-Nox/Big Bang"; -- Author of the plugin
PLUGIN.Description = "Configures the schema"; -- The description or purpose of the plugin

function PLUGIN.Init()
	
	--Containers.
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

	--Allowed default male clothing
	CAKE.ConVars[ "Default_Clothing" ][ "Male" ] = {
		"clothing_formal",
		"clothing_formal2",
		"clothing_labcoat",
		"clothing_combat"
	}
	--Allowed default female clothing.
	CAKE.ConVars[ "Default_Clothing" ][ "Female" ] = {
		"clothing_formalf",
		"clothing_labcoat",
		"clothing_combatf"
	}

	--Currency data.
	CURRENCY = {}
	CURRENCY.Name        = "Dollars";
	CURRENCY.Slang       = "dollar"
	CURRENCY.Abr         = "$"
	CAKE.RegisterCurrency( CURRENCY )
	
end