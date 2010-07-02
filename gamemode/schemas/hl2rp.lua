SCHEMA.Name = "Half-Life 2 RP";
SCHEMA.Author = "LuaBanana";
SCHEMA.Description = "Live in the HL2 world.";
SCHEMA.Base = "global";

function SCHEMA.SetUp( )
	
	local team = CAKE.HL2Team();

	-- name, color, model_path, default_model, partial_model, weapons, flag_key, door_groups, radio_groups, sound_groups, item_groups, salary, public, business, broadcast
	
	-- Item Groups
	-- Groceries: 1
	-- Black Market: 2
	-- Medical: 3
	-- Rebel Market: 4
	-- Combine Market: 5
	-- Monk Market: 6
	
	-- Humans: 1
	-- Combine: 2
	-- Vortigaunt: 3
	
	-- Door Groups
	-- Combine: 1
	
	-- Radio Groups
	-- Combine: 1
	-- Rebel: 2
	
	
	
	
	-- Citizens
	CAKE.AddTeam( CAKE.HL2Team( ) ); -- Citizen
	CAKE.AddTeam( CAKE.HL2Team( "Grocery Store Owner", nil, nil, nil, nil, nil, "grocery", nil, nil, nil, { 1 }, nil, true, true, nil) ); -- Grocery Store Owner
	CAKE.AddTeam( CAKE.HL2Team( "Black Market Dealer", nil, nil, nil, nil, nil, "bm", nil, nil, nil, { 2 }, nil, false, true, false) ); -- Black Market
	CAKE.AddTeam( CAKE.HL2Team( "Medical Specialist", nil, nil, nil, nil, nil, "doctor", nil, nil, nil, { 3 }, nil, true, true, nil) ); -- Doctor
	CAKE.AddTeam( CAKE.HL2Team( "Monk", Color( 255, 0, 0, 255 ), "models/monk.mdl", true, false, nil, "monk", nil, nil, nil, nil, nil, true, true, false, nil) );
	
	-- Rebellion
	CAKE.AddTeam( CAKE.HL2Team( "Refugee", Color(255, 166, 0, 255), "models/humans/group02/", true, true, nil, "refugee", nil, { 2 }, nil, { 4 }, nil, true, true, nil) ); -- Refugee
	CAKE.AddTeam( CAKE.HL2Team( "Railroad Rebel", Color(255, 166, 0, 255), "models/alyx.mdl", true, false, nil, "railroad", nil, { 2 }, nil, { 4 }, nil, false, true, nil) ); -- Railroad Rebel
	CAKE.AddTeam( CAKE.HL2Team( "Resistance", Color(255, 166, 0, 255), "models/humans/group03/", true, true, nil, "rebel", nil, { 2 }, nil, { 4 }, nil, false, true, nil) ); -- Rebel
	CAKE.AddTeam( CAKE.HL2Team( "Resistance Station Leader", Color(255, 166, 0, 255), "models/odessa.mdl", true, false, nil, "rsl", nil, { 2 }, nil, { 4 }, nil, false, true, nil) ); -- Rebel Station Leader (Odessa)
	CAKE.AddTeam( CAKE.HL2Team( "Resistance Medic", Color(255, 166, 0, 255), "models/humans/group03m/", true, true, nil, "rebelmedic", nil, { 2 }, nil, { 4 }, nil, false, true, nil) ); -- Rebel Medic
	CAKE.AddTeam( CAKE.HL2Team( "Resistance Vortigaunt", Color(255, 166, 0, 255), "models/vortigaunt.mdl", true, false, nil, "vortigaunt", nil, { 2 }, {3}, { 4 }, nil, false, true, nil) ); -- Rebel Vortigaunt
	CAKE.AddTeam( CAKE.HL2Team( "Resistance Scientist", Color(255, 166, 0, 255), "models/kleiner.mdl", true, false, nil, "rebelscientist", nil, { 2 }, nil, { 4 }, nil, false, true, nil) ); -- Rebel Scientist
	CAKE.AddTeam( CAKE.HL2Team( "Resistance Leader", Color(255, 166, 0, 255), "models/eli.mdl", true, false, nil, "rebelleader", nil, { 2 }, nil, { 4 }, nil, false, true, nil) ); -- Rebel Leader (Eli)
	
	-- Combine
	CAKE.AddTeam( CAKE.HL2Team( "Stalker", Color(0, 0, 200, 255), "models/stalker.mdl", true, false, {}, "stalker", {1}, {1}, nil, {5}, 0, false, true, false) ); -- Stalker
	CAKE.AddTeam( CAKE.HL2Team( "Civil Protection Trainee", Color(0, 0, 200, 255), "models/barney.mdl", true, false, {"weapon_stunstick"}, "cpt", {1}, {1}, {2}, {5}, 30, false, true, false) ); -- Civil Protection Trainee
	CAKE.AddTeam( CAKE.HL2Team( "Civil Protection", Color(0, 0, 200, 255), "models/police.mdl", true, false, {"weapon_stunstick", "weapon_pistol"}, "cp", {1}, {1}, {2}, {5}, 50, false, true, true) ); -- Civil Protection
	CAKE.AddTeam( CAKE.HL2Team( "Nova Prospekt Soldier", Color(0, 0, 200, 255), "models/combine_soldier_prisonguard.mdl", true, false, {"weapon_ar2"}, "nps", {1}, {1}, {2}, {5}, 100, false, true, true) ); -- Nova Prospekt Soldier
	CAKE.AddTeam( CAKE.HL2Team( "Overwatch Soldier", Color(0, 0, 200, 255), "models/combine_soldier.mdl", true, false, {"weapon_ar2"}, "ow", {1}, {1}, {2}, {5}, 100, false, true, true) ); -- Overwatch Soldier
	CAKE.AddTeam( CAKE.HL2Team( "Overwatch Super Soldier", Color(0, 0, 200, 255), "models/combine_super_soldier.mdl", true, false, {"weapon_ar2", "weapon_grenade", "weapon_rpg"}, "ows", {1}, {1}, {2}, {5}, 50, false, true, true) ); -- Overwatch Super Soldier
	CAKE.AddTeam( CAKE.HL2Team( "City Administrator", Color(0, 0, 200, 255), "models/breen.mdl", true, false, {"weapon_357"}, "ca", {1}, {1}, {2}, {5}, 200, false, true, true) ); -- City Administrator
	

	
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
