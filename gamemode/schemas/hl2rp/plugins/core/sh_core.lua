CAKE.CityNumber = 17 --This provides a quick way of changing the name of the city employed on the whole script
--Since HL2RP servers seem to think that setting on a city number is a fundamental part of the community.

if SERVER then	
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

	--With this we disable character creation clothing.
	CAKE.ConVars[ "Default_Clothing" ][ "Male" ] = {}
	CAKE.ConVars[ "Default_Clothing" ][ "Female" ] = {}

	--Currency data.
	CURRENCY = {}
	CURRENCY.Name        = "Credits";
	CURRENCY.Slang       = "credit"
	CURRENCY.Abr         = "Credits"
	CAKE.RegisterCurrency( CURRENCY )

	CAKE.AddDataField( 2, "cid", "000000" ); 

else
	CAKE.IntroText = "Welcome to City " .. CAKE.CityNumber -- Character menu and intro text
	CAKE.IntroSubtitle = "IT'S SAFER HERE" -- Character menu and intro subtitle. If you want this gone just set it to ""
end