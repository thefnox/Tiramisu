PLUGIN.Name = "Core Plugin"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "Configures the gamemode on a deeper level."; -- The description or purpose of the plugin

-- !!!! WARNING !!!! --
-- DO NOT REMOVE ANYTHING IN THIS FILE OR YOUR SERVER WILL CEASE TO FUNCTION.
-- !!!! WARNING !!!! --

CAKE.AddDataField( 1, "characters", { } );
CAKE.AddDataField( 1, "adrank", "Player" )

-- These fields are what would be the default value, and it also allows the field to actually EXIST.
-- If there is a field in the data and it isn't added, it will automatically be removed.

-- Character Fields
CAKE.AddDataField( 2, "name", "Set Your Name" ); -- Let's hope this never gets used.
CAKE.AddDataField( 2, "model", "models/humans/group01/male_07.mdl" );
CAKE.AddDataField( 2, "title", CAKE.ConVars[ "Default_Title" ] ); -- What is their default title.
CAKE.AddDataField( 2, "money", CAKE.ConVars[ "Default_Money" ] ); -- How much money do players start out with.
CAKE.AddDataField( 2, "flags", CAKE.ConVars[ "Default_Flags" ] ); -- What flags do they start with.
CAKE.AddDataField( 2, "inventory", CAKE.ConVars[ "Default_Inventory" ] ); -- What inventory do they start with
CAKE.AddDataField( 2, "gender", "Male" ) -- MAN POWER
CAKE.AddDataField( 2, "age", 30 ) --Can't think of any puns.
CAKE.AddDataField( 2, "group", "None" )
CAKE.AddDataField( 2, "grouprank", "None" )