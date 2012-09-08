PLUGIN.Name = "Core Plugin" -- What is the plugin name
PLUGIN.Author = "LuaBanana" -- Author of the plugin
PLUGIN.Description = "Configures the gamemode on a deeper level." -- The description or purpose of the plugin

-- !!!! WARNING !!!! --
-- DO NOT REMOVE ANYTHING IN THIS FILE OR YOUR SERVER WILL CEASE TO FUNCTION.
-- !!!! WARNING !!!! --
TIRA.AddDataField( 1, "steamid", "", "VARCHAR(50)" )
TIRA.AddDataField( 1, "characters", { } )
TIRA.AddDataField( 1, "adrank", "Player" )

-- These fields are what would be the default value, and it also allows the field to actually EXIST.
-- If there is a field in the data and it isn't added, it will automatically be removed.

-- Character Fields
TIRA.AddDataField( 2, "name", "Set Your Name" ) 
TIRA.AddDataField( 2, "model", "models/humans/group01/male_07.mdl" ) -- Your base model
TIRA.AddDataField( 2, "personality", "default" ) --Don't be making a cult over it.
TIRA.AddDataField( 2, "title", TIRA.ConVars[ "DefaultTitle" ] ) -- What is their default title.
TIRA.AddDataField( 2, "money", TIRA.ConVars[ "DefaultMoney" ], "INT" ) -- How much money do players start out with.
TIRA.AddDataField( 2, "flags", TIRA.ConVars[ "DefaultFlags" ] ) -- What flags do they start with.
TIRA.AddDataField( 2, "gender", "Male" ) -- MAN POWER
TIRA.AddDataField( 2, "age", 30, "INT" ) --Can't think of any puns.
TIRA.AddDataField( 2, "gear", {} )