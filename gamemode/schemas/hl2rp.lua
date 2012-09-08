SCHEMA.Name = "Half Life 2 RP"
SCHEMA.Author = "FNox"
SCHEMA.Description = "Pretend you have a life!"
SCHEMA.Base = "global"

TIRA.ConVars["RationMoney"] = 15 -- How much money you get out of a ration
TIRA.MaxRations = 60 -- The maximum amount of rations available
TIRA.RationTimer = 10 --In minutes. The time it takes for rations to be resupplied

SetGlobalInt( "rations", TIRA.MaxRations )


function SCHEMA.SetUp( )
	--CCA
	TIRA.CreateFaction( "Combine Civil Authority", "cca", [[
	Part of the Combine Overwatch,[1] CPs are ordinary human volunteers who have "willingly" joined the Combine,[5] either for more privileges, such as additional food, better living conditions, an increase in authority and status over others, or out of genuine sympathy and identification with the Combine's aims. As such, they are not bio-mechanically modified in any way, unlike the two other Overwatch units.]] )
	--Recruit
	TIRA.AddFactionRank( "cca", "Civil Protection Recruit", "rct", "The starter, non commisoned rank in the CCA",
	0, {"weapon_zipties", "weapon_stunstick"}, {"clothing_police"} )
	--CP-1
	TIRA.AddFactionRank( "cca", "Civil Protection Officer Rank 1", "cp1", "Non commisioned officer, first rank in the CP forces",
	1, {"weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1"}, {"clothing_police", "helmet_police"} )
	--CP-2
	TIRA.AddFactionRank( "cca", "Civil Protection Officer Rank 2", "cp2", "Non commisioned officer, second rank in the CP forces",
	2, {"weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1"}, {"clothing_police", "helmet_police"} )
	--CP-3
	TIRA.AddFactionRank( "cca", "Civil Protection Officer Rank 3", "cp3", "Non commisioned officer, third rank in the CP forces",
	3, {"weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1"}, {"clothing_police", "helmet_police"} )
	--TL
	TIRA.AddFactionRank( "cca", "Civil Protection Team Leader", "tl", "Commisioned officer, leader of a squad of CPs",
	4, {"weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1", "weapon_shotgun"}, {"clothing_police", "helmet_police"},
	{ ["canpromote"] = true } )
	--Medic
	TIRA.AddFactionRank( "cca", "Civil Protection Medic", "medic", "Equivalent to a CP-3 in rank, dedicated combat medic of the CCA",
	3, {"weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1"}, {"clothing_police", "helmet_police","firstaidkit", "small_medikit"} )
	--Engineer
	TIRA.AddFactionRank( "cca", "Civil Protection Engineer", "en", "Equivalent to a CP-3 in rank, dedicated to the maintenance and upkeeping of CCA equipment",
	3, {"weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1"}, {"clothing_police", "helmet_police"} )
	--Division Leader
	TIRA.AddFactionRank( "cca", "Civil Protection Division Leader", "dl", "Commisioned officer, in charge of the CP forces of the city",
	5, {"weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1", "weapon_shotgun"}, {"clothing_police", "helmet_police"},
	{ ["canpromote"] = true, ["caninvite"] = true, ["cankick"] = true } )

	--Overwatch
	TIRA.CreateFaction( "Combine Overwatch", "ow", [[
	The Forces of the Overwatch consist mainly of Combine Soldiers supported by Synths and divided into distinct "sectors" designated around an urban center. They are overseen by the Overwatch Voice as their immediate commander which issues orders and instructions to fulfill its objectives on behalf of the Combine government.]] )
	--OW
	TIRA.AddFactionRank( "ow", "Overwatch Soldier", "ow", "The standard footsoldier of the Combine Overwatch",
	0, {"weapon_zipties", "weapon_stunstick","weapon_smg1", "weapon_shotgun"}, {"clothing_soldier", "helmet_soldier"} )
	--Airwatch
	TIRA.AddFactionRank( "ow", "Airwatch Soldier", "aw", "Member of the aerial urban tactics group of the Combine",
	0, {"weapon_zipties", "weapon_stunstick","weapon_smg1", "weapon_shotgun"}, {"clothing_soldier", "helmet_soldier"} )
	--Commander
	TIRA.AddFactionRank( "ow", "Overwatch Squad Commander", "cw", "Leader of a squad sized force of Combine Soldiers",
	2, {"weapon_zipties", "weapon_stunstick","weapon_smg1", "weapon_shotgun", "weapon_ar2"}, {"clothing_soldier", "helmet_soldier"},
	{["canpromote"] = true, ["caninvite"] = true, ["cankick"] = true} )
	--Elite
	TIRA.AddFactionRank( "ow", "Overwatch Elite Soldier", "ew", "Elite trooper of the highest ranks of the Overwatch",
	1, {"weapon_zipties", "weapon_stunstick","weapon_smg1", "weapon_shotgun", "weapon_ar2"}, {"clothing_elite", "helmet_elite"},
	{["canpromote"] = true, ["caninvite"] = true, ["cankick"] = true} )


	--Lambda Rebels
	TIRA.CreateFaction( "Lambda Resistance", "r", [[
	The Resistance is a loose, covert network of humans and Vortigaunts with the shared goal of defeating the Combine and restoring their freedom.]] )
	--Recruit
	TIRA.AddFactionRank( "r", "Resistance Rookie", "rookie", "A militant of the Resistance",
	0, {}, {"clothing_combat"} )
	--Regular members
	TIRA.AddFactionRank( "r", "Resistance Member", "rebel", "A footsoldier of the Resistance",
	1, {"weapon_smg1"}, {"clothing_combat", "helmet_balaclava"} )
	--Medics
	TIRA.AddFactionRank( "r", "Resistance Medic", "medic", "A combat medic of the Resistance",
	1, {"weapon_smg1"}, {"clothing_medic", "helmet_balaclava"} )
	--Leader
	TIRA.AddFactionRank( "r", "Resistance Leader", "leader", "Leader of the Resistance",
	2, {"weapon_smg1","weapon_357"}, {"clothing_combat", "helmet_balaclava"},
	{["canpromote"] = true, ["caninvite"] = true, ["cankick"] = true} )

end
