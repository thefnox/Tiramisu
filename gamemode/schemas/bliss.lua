SCHEMA.Name = "Half-Life 2 RP";
SCHEMA.Author = "LuaBanana";
SCHEMA.Description = "Live in the HL2 world.";
SCHEMA.Base = "global";

function SCHEMA.SetUp( )
	
	local team = CAKE.BlissDefoTeam();
	
	-- Citizens
	CAKE.AddTeam( CAKE.BlissDefoTeam() ); -- Citizen

	
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
