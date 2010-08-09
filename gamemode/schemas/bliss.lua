SCHEMA.Name = "Half-Life 2 RP";
SCHEMA.Author = "LuaBanana";
SCHEMA.Description = "Live in the HL2 world.";
SCHEMA.Base = "global";

function SCHEMA.SetUp( )
	
	local team = CAKE.BlissDefoTeam();
	
	
	CAKE.AddTeam( CAKE.BlissDefoTeam() );
	--["canbuy"] = true, ["buygroups"] = { 1, 2, 3 }
	CAKE.BlissFaction( "The Alliance",
	"Alliance High Command",
	{ 	["recruit"] = { [ "formalname" ] = "Recruit", [ "loadout" ] = { "weapon_mad_knife" }, [ "level" ] = 0 },
		["cadetprivate"] = { [ "formalname" ] = "Cadet Private", [ "loadout" ] = { "weapon_mad_knife", "clothing_alpolice" }, [ "level" ] = 1 },
		["cadetunit"] = { [ "formalname" ] = "Cadet Lance Corporal", [ "loadout" ] = { "weapon_mad_knife", "clothing_alpolice", "weapon_mad_alyxgun" }, [ "level" ] = 1 },
		["cadetcpl"] = { [ "formalname" ] = "Cadet Corporal", [ "loadout" ] = { "weapon_mad_knife", "clothing_alpolice", "weapon_mad_alyxgun" }, [ "level" ] = 2 },
		["cadetsgt"] = { [ "formalname" ] = "Cadet Sergeant", [ "loadout" ] = { "weapon_mad_knife", "clothing_alpolice", "helmet_police", "weapon_mad_alyxgun" }, [ "level" ] = 3 },
		["cadetmastersgt"] = { [ "formalname" ] = "Cadet Master Sergeant", [ "loadout" ] = { "weapon_mad_knife", "clothing_alpolice", "helmet_police", "weapon_mad_alyxgun", "weapon_mad_ump" }, [ "level" ] = 4 },
		["lieutenant"] = { [ "formalname" ] = "Officer Lieutenant", [ "loadout" ] = { "weapon_mad_knife", "clothing_medium_riot", "helmet_police", "weapon_mad_alyxgun", "weapon_mad_ump" }, [ "level" ] = 5 },
		["seniorlieutenant"] = { [ "formalname" ] = "Officer Senior Lieutenant", [ "loadout" ] = { "weapon_mad_knife", "clothing_medium_riot", "helmet_police", "weapon_mad_alyxgun", "weapon_mad_ar2" }, [ "level" ] = 6, ["caninvite"] = true },
		["captain"] = { [ "formalname" ] = "Officer Captain", [ "loadout" ] = { "weapon_mad_knife", "clothing_medium_riot", "helmet_police", "weapon_mad_alyxgun", "weapon_mad_ar2" }, [ "level" ] = 6, ["canpromote"] = true, ["caninvite"] = true },
		["colonel"] = { [ "formalname" ] = "Officer Colonel", [ "loadout" ] = { "weapon_mad_knife", "clothing_heavy_juggernaut", "helmet_juggernaut", "weapon_mad_alyxgun", "weapon_mad_ar2" }, [ "level" ] = 7, ["canpromote"] = true, ["caninvite"] = true, ["canbuy"] = true, ["buygroups"] = { 1, 2, 3 } },
	},
	{ 	[ "canbuy" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "recruit"
	},
	1,
	2,
	"null.vtf",
	{ 	"alliance",
		"faction",
		"police",
		"public"
	})
	
	CAKE.BlissFaction( "L.E.O.S Group",
	"Apollo Ayndar",
	{ 	
		["worker"] = { [ "formalname" ] = "LEOS Group Worker", [ "loadout" ] = { }, [ "level" ] = 1 },
		["scientist"] = { [ "formalname" ] = "LEOS Group Worker", [ "loadout" ] = { "clothing_biosuit", "helmet_biosuit", "clothing_labcoat" }, [ "level" ] = 2 },
		["salesperson"] = { [ "formalname" ] = "LEOS Group Salesperson", [ "loadout" ] = { "clothing_casual1", "clothing_casualf1" }, [ "level" ] = 2,["canbuy"] = true, ["buygroups"] = { 1 } },
		["guard"] = { [ "formalname" ] = "LEOS Group Enforcer", [ "loadout" ] = { "weapon_mad_knife", "weapon_mad_sg552", "helmet_splinter", "clothing_medium_splinter" }, [ "level" ] = 2 },
		["secretary"] = { [ "formalname" ] = "LEOS Group Secretary", [ "loadout" ] = { "clothing_casualf5" }, [ "level" ] = 2 },
		["maleoffice"] = { [ "formalname" ] = "LEOS Group Junior Executive", [ "loadout" ] = { "clothing_formal1" }, [ "level" ] = 3 },
		["femaleoffice"] = { [ "formalname" ] = "LEOS Group Junior Executive", [ "loadout" ] = { "clothing_formalf" }, [ "level" ] = 3 },
		["executive"] = { [ "formalname" ] = "LEOS Group Executive", [ "loadout" ] = { "clothing_formal1" }, [ "level" ] = 4, ["canpromote"] = true, ["caninvite"] = true, ["canbuy"] = true, ["buygroups"] = { 1, 2, 3 } },
		["ceo"] = { [ "formalname" ] = "LEOS Group Chief Executive", [ "loadout" ] = { "weapon_mad_357", "clothing_formal2"}, [ "level" ] = 5, ["canpromote"] = true, ["caninvite"] = true, ["canbuy"] = true, ["buygroups"] = { 1, 2, 3 } },
	},
	{ 	[ "canbuy" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "worker"
	},
	2,
	1,
	"null.vtf",
	{ 	"leos",
		"group",
		"corporate",
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
