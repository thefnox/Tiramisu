SCHEMA.Name = "Benevolence Science Fiction RP";
SCHEMA.Author = "FNox";
SCHEMA.Description = "Science Fiction RP.";
SCHEMA.Base = "global";

function SCHEMA.SetUp( )

	local team = CAKE.BenevolenceDefoTeam();
	
	
	CAKE.AddTeam( CAKE.BenevolenceDefoTeam() );

	-- Selectable models on character creation
	-- Bogus models were needed because the shitty derma doesn't wanna scroll unless it has a certain amount of models.
	CAKE.AddModels({
			  "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
			  "models/humans/group01/female_01.mdl",
              "models/humans/group01/female_02.mdl",
              "models/humans/group01/female_03.mdl",
              "models/humans/group01/female_04.mdl",
              "models/humans/group01/female_06.mdl",
              "models/humans/group01/female_07.mdl"
	});	


	CAKE.BenevolenceFaction( "U.S. Army",
	"United States of America",
	{ 	["Infantry"] = { [ "formalname" ] = "Infantry", [ "loadout" ] = { "clothing_infantry", "helmet_infantry", "weapon_mad_auga3", "weapon_mad_m8", "weapon_mad_mk23" }, [ "level" ] = 0 },
		["Officer"] = { [ "formalname" ] = "Officer", [ "loadout" ] = { "clothing_officer", "helmet_officer", "weapon_mad_auga3", "weapon_mad_m8", "weapon_mad_mk23" }, [ "level" ] = 5 },
		--Misc Classes
		["Heavy Infantry"] = { [ "formalname" ] = "Heavy Infantry", [ "loadout" ] = { "clothing_heavyinfantry", "helmet_heavyinfantry", "weapon_mad_mg36", "weapon_mad_fnc", "weapon_mad_charge", "weapon_mad_mk23" }, [ "level" ] = 4 },
		["Power Trooper"] = { [ "formalname" ] = "Power Trooper", [ "loadout" ] = { "clothing_powersuit", "helmet_powersuit", "weapon_mad_mg36", "weapon_mad_fnc", "weapon_mad_charge", "weapon_mad_mk23" }, [ "level" ] = 5 },
	},
	{ 	[ "canbuy" ] = true,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "Infantry"
	},
	1,
	2,
	"null.vtf",
	{ 	"soldier",
		"infantry",
		"standard",
		"default"
	})
		  
end
