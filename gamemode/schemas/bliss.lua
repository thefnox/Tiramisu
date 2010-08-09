SCHEMA.Name = "Half-Life 2 RP";
SCHEMA.Author = "LuaBanana";
SCHEMA.Description = "Live in the HL2 world.";
SCHEMA.Base = "global";

function SCHEMA.SetUp( )
	
	local team = CAKE.BlissDefoTeam();
	
	-- Citizens
	CAKE.AddTeam( CAKE.BlissDefoTeam() ); -- Citizen
	
	CAKE.BlissFaction( "The Alliance",
	"Alliance High Command",
	{ 	["recruit"] = { [ "formalname" ] = "Recruit", [ "loadout" ] = { "weapon_stunstick", "weapon_knife" }, [ "level" ] = 0 },
		["cadetprivate"] = { [ "formalname" ] = "Cadet Private", [ "loadout" ] = { "weapon_stunstick", "weapon_knife", "clothing_alpolice" }, [ "level" ] = 1 },
		["cadetunit"] = { [ "formalname" ] = "Cadet Lance Corporal", [ "loadout" ] = { "weapon_stunstick", "weapon_knife", "clothing_alpolice", "weapon_mad_alyxgun" }, [ "level" ] = 1 },
		["cadetcpl"] = { [ "formalname" ] = "Cadet Corporal", [ "loadout" ] = { "weapon_stunstick", "weapon_knife", "clothing_alpolice", "weapon_mad_alyxgun" }, [ "level" ] = 2 },
		["cadetsgt"] = { [ "formalname" ] = "Cadet Sergeant", [ "loadout" ] = { "weapon_stunstick", "weapon_knife", "clothing_alpolice", "helmet_police", "weapon_mad_alyxgun" }, [ "level" ] = 3 },
		["cadetmastersgt"] = { [ "formalname" ] = "Cadet Master Sergeant", [ "loadout" ] = { "weapon_stunstick", "weapon_knife", "clothing_alpolice", "helmet_police", "weapon_mad_alyxgun", "weapon_mad_ump" }, [ "level" ] = 4 },
		["lieutenant"] = { [ "formalname" ] = "Officer Lieutenant", [ "loadout" ] = { "weapon_stunstick", "weapon_knife", "clothing_medium_riot", "helmet_police", "weapon_mad_alyxgun", "weapon_mad_ump" }, [ "level" ] = 5 },
		["seniorlieutenant"] = { [ "formalname" ] = "Officer Senior Lieutenant", [ "loadout" ] = { "weapon_stunstick", "weapon_knife", "clothing_medium_riot", "helmet_police", "weapon_mad_alyxgun", "weapon_mad_ar2" }, [ "level" ] = 6 },
		["captain"] = { [ "formalname" ] = "Officer Captain", [ "loadout" ] = { "weapon_stunstick", "weapon_knife", "clothing_medium_riot", "helmet_police", "weapon_mad_alyxgun", "weapon_mad_ar2" }, [ "level" ] = 6, ["canpromote"] = true },
		["colonel"] = { [ "formalname" ] = "Officer Colonel", [ "loadout" ] = { "weapon_stunstick", "weapon_knife", "clothing_heavy_juggernaut", "helmet_juggernaut", "weapon_mad_alyxgun", "weapon_mad_ar2" }, [ "level" ] = 7, ["canpromote"] = true },
	},
	{ 	[ "canbuy" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "recruit"
	},
	2,
	2,
	"null.vtf",
	{ 	"alliance",
		"faction",
		"police",
		"public"
	})

	
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
end
