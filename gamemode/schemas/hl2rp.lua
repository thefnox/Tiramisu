SCHEMA.Name = "Half-Life 2 RP";
SCHEMA.Author = "LuaBanana";
SCHEMA.Description = "Live in the HL2 world.";
SCHEMA.Base = "global";

function SCHEMA.SetUp( )
	
	local team = CAKE.HL2DefoTeam()
	
	CAKE.AddTeam(CAKE.HL2DefoTeam());

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
	
	CAKE.HL2RPFaction( "CCA Vice Squadron",
	"CCA",
	{ 	["mp1"] = { [ "formalname" ] = "Metropolice Unit 1", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_vice", "weapon_mad_usp_match", "helmet_vice", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 1 },
		["mp2"] = { [ "formalname" ] = "Metropolice Unit 2", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_vice", "weapon_mad_usp_match", "helmet_vice", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 2 },
		["mp3"] = { [ "formalname" ] = "Metropolice Unit 3", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_vice", "weapon_mad_usp_match", "helmet_vice", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 3 },
		["mp4"] = { [ "formalname" ] = "Metropolice Unit 4", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_vice", "weapon_mad_usp_match", "helmet_vice", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 4 },
		["to"] = { [ "formalname" ] = "Team Officer", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_vice", "weapon_mad_usp_match", "helmet_vice", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 5, ["caninvite"] = true },
		["cmd"] = { [ "formalname" ] = "Commander", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_vice", "weapon_mad_usp_match", "helmet_vice", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 6, ["caninvite"] = true, ["canpromote"] = true  },
		["divl"] = { [ "formalname" ] = "Division Leader", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_vice", "weapon_mad_usp_match", "helmet_vice", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 7, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 2,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "mp1",
		[ "radiocolor" ] = Color( 100, 100, 100 ),
		[ "iscombine" ] = true,
		[ "radiogroup" ] = 1
	},
	1,
	2,
	"hl2rp/combinearmbandvice",
	{ 	"cca",
		"faction",
		"police",
		"combine"
	})
	
	CAKE.HL2RPFaction( "CCA Shield Squadron",
	"CCA",
	{ 	["mp1"] = { [ "formalname" ] = "Metropolice Unit 1", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_shield", "weapon_mad_usp_match", "helmet_shield", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 1 },
		["mp2"] = { [ "formalname" ] = "Metropolice Unit 2", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_shield", "weapon_mad_usp_match", "helmet_shield", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 2 },
		["mp3"] = { [ "formalname" ] = "Metropolice Unit 3", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_shield", "weapon_mad_usp_match", "helmet_shield", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 3 },
		["mp4"] = { [ "formalname" ] = "Metropolice Unit 4", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_shield", "weapon_mad_usp_match", "helmet_shield", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 4 },
		["to"] = { [ "formalname" ] = "Team Officer", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_shield", "weapon_mad_usp_match", "helmet_shield", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 5, ["caninvite"] = true },
		["cmd"] = { [ "formalname" ] = "Commander", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_shield", "weapon_mad_usp_match", "helmet_shield", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 6, ["caninvite"] = true, ["canpromote"] = true  },
		["divl"] = { [ "formalname" ] = "Division Leader", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_shield", "weapon_mad_usp_match", "helmet_shield", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 7, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 2,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "mp1",
		[ "radiocolor" ] = Color( 200, 255, 200 ),
		[ "iscombine" ] = true,
		[ "radiogroup" ] = 1
	},
	1,
	2,
	"hl2rp/combinearmbandshield",
	{ 	"cca",
		"faction",
		"police",
		"combine"
	})
	
	CAKE.HL2RPFaction( "CCA Ignis Squadron",
	"CCA",
	{ 	["mp1"] = { [ "formalname" ] = "Metropolice Unit 1", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_ignis", "weapon_mad_usp_match", "helmet_ignis", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 1 },
		["mp2"] = { [ "formalname" ] = "Metropolice Unit 2", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_ignis", "weapon_mad_usp_match", "helmet_ignis", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 2 },
		["mp3"] = { [ "formalname" ] = "Metropolice Unit 3", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_ignis", "weapon_mad_usp_match", "helmet_ignis", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 3 },
		["mp4"] = { [ "formalname" ] = "Metropolice Unit 4", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_ignis", "weapon_mad_usp_match", "helmet_ignis", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 4 },
		["to"] = { [ "formalname" ] = "Team Officer", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_ignis", "weapon_mad_usp_match", "helmet_ignis", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 5, ["caninvite"] = true },
		["cmd"] = { [ "formalname" ] = "Commander", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_ignis", "weapon_mad_usp_match", "helmet_ignis", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 6, ["caninvite"] = true, ["canpromote"] = true  },
		["divl"] = { [ "formalname" ] = "Division Leader", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_ignis", "weapon_mad_usp_match", "helmet_ignis", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 7, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 2,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "mp1",
		[ "radiocolor" ] = Color( 120, 70, 0 ),
		[ "iscombine" ] = true,
		[ "radiogroup" ] = 1
	},
	1,
	2,
	"hl2rp/combinearmbandignis",
	{ 	"cca",
		"faction",
		"police",
		"combine"
	})
	
	CAKE.HL2RPFaction( "CCA Viktor Squadron",
	"CCA",
	{ 	["mp1"] = { [ "formalname" ] = "Metropolice Unit 1", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_viktor", "weapon_mad_usp_match", "helmet_viktor", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 1 },
		["mp2"] = { [ "formalname" ] = "Metropolice Unit 2", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_viktor", "weapon_mad_usp_match", "helmet_viktor", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 2 },
		["mp3"] = { [ "formalname" ] = "Metropolice Unit 3", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_viktor", "weapon_mad_usp_match", "helmet_viktor", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 3 },
		["mp4"] = { [ "formalname" ] = "Metropolice Unit 4", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_viktor", "weapon_mad_usp_match", "helmet_viktor", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 4 },
		["to"] = { [ "formalname" ] = "Team Officer", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_viktor", "weapon_mad_usp_match", "helmet_viktor", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 5, ["caninvite"] = true },
		["cmd"] = { [ "formalname" ] = "Commander", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_viktor", "weapon_mad_usp_match", "helmet_viktor", "weapon_mad_mp7", "weapon_zipties"  }, [ "level" ] = 6, ["caninvite"] = true, ["canpromote"] = true  },
		["divl"] = { [ "formalname" ] = "Division Leader", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_viktor", "weapon_mad_usp_match", "helmet_viktor", "weapon_mad_mp7" , "weapon_zipties" }, [ "level" ] = 7, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 2,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "mp1",
		[ "radiocolor" ] = Color( 255, 255, 255 ),
		[ "iscombine" ] = true,
		[ "radiogroup" ] = 1
	},
	1,
	2,
	"hl2rp/combinearmbandviktor",
	{ 	"cca",
		"faction",
		"police",
		"combine"
	})
	
	CAKE.HL2RPFaction( "CCA Legion Squadron",
	"CCA",
	{ 	["mp1"] = { [ "formalname" ] = "Metropolice Unit 1", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_legion", "weapon_mad_usp_match", "helmet_legion", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 1 },
		["mp2"] = { [ "formalname" ] = "Metropolice Unit 2", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_legion", "weapon_mad_usp_match", "helmet_legion", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 2 },
		["mp3"] = { [ "formalname" ] = "Metropolice Unit 3", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_legion", "weapon_mad_usp_match", "helmet_legion", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 3 },
		["mp4"] = { [ "formalname" ] = "Metropolice Unit 4", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_legion", "weapon_mad_usp_match", "helmet_legion", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 4 },
		["to"] = { [ "formalname" ] = "Team Officer", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_legion", "weapon_mad_usp_match", "helmet_legion", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 5, ["caninvite"] = true },
		["cmd"] = { [ "formalname" ] = "Commander", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_legion", "weapon_mad_usp_match", "helmet_legion", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 6, ["caninvite"] = true, ["canpromote"] = true  },
		["divl"] = { [ "formalname" ] = "Division Leader", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_legion", "weapon_mad_usp_match", "helmet_legion", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 7, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 2,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "mp1",
		[ "radiocolor" ] = Color( 20, 255, 20 ),
		[ "iscombine" ] = true,
		[ "radiogroup" ] = 1
	},
	1,
	2,
	"hl2rp/combinearmbandlegion",
	{ 	"cca",
		"faction",
		"police",
		"combine"
	})
	
	CAKE.HL2RPFaction( "Sector 28 Supreme Command",
	"CCA",
	{ 
		["seql"] = { [ "formalname" ] = "Sector Leader", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_elite", "weapon_mad_usp_match", "helmet_elite", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 7, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 2,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "seql",
		[ "radiocolor" ] = Color( 200, 20, 20 ),
		[ "iscombine" ] = true,
		[ "radiogroup" ] = 1
	},
	1,
	2,
	"hl2rp/secbadge",
	{ 	"cca",
		"faction",
		"police",
		"combine"
	})
	
	CAKE.HL2RPFaction( "Recruit Squad",
	"CCA",
	{ 
		["recruit"] = { [ "formalname" ] = "Recruit", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_police", "weapon_mad_usp_match", "weapon_zipties" }, [ "level" ] = 1  },
		["trainer"] = { [ "formalname" ] = "Recruit Trainer", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_police", "weapon_mad_usp_match", "helmet_police", "weapon_mad_mp7", "weapon_zipties" }, [ "level" ] = 2, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 2,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "recruit",
		[ "radiocolor" ] = Color( 200, 100, 200 ),
		[ "iscombine" ] = true,
		[ "radiogroup" ] = 1
	},
	1,
	2,
	"hl2rp/combinearmbandrecruit",
	{ 	"cca",
		"faction",
		"police",
		"combine"
	})
	
	CAKE.HL2RPFaction( "Overwatch",
	"CCA",
	{ 	
		["soldier"] = { [ "formalname" ] = "Overwatch Unit", [ "loadout" ] = { "weapon_mad_knife", "clothing_soldier", "weapon_mad_usp_match", "helmet_soldier", "weapon_mad_ar2", "weapon_mad_grenade", "weapon_zipties" }, [ "level" ] = 1  },
		["elite"] = { [ "formalname" ] = "Overwatch Elite", [ "loadout" ] = { "weapon_mad_knife", "clothing_elite", "weapon_mad_usp_match", "helmet_elite", "weapon_mad_ar2", "weapon_mad_grenade", "weapon_zipties" }, [ "level" ] = 2, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 2,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "soldier",
		[ "radiocolor" ] = Color( 80, 0, 120 ),
		[ "iscombine" ] = true,
		[ "radiogroup" ] = 1
	},
	1,
	2,
	"hl2rp/overwatch",
	{ 	"cca",
		"faction",
		"police",
		"combine"
	})
	
	CAKE.HL2RPFaction( "Lambda Rebellion",
	"Unknown",
	{ 	
		["rebel"] = { [ "formalname" ] = "Lambda Rebel", [ "loadout" ] = { "clothing_combat" }, [ "level" ] = 1  },
		["blackmarket"] = { [ "formalname" ] = "Blackmarket dealer", [ "loadout" ] = { "clothing_combat" }, [ "level" ] = 1, ["canbuy"] = true, ["buygroups"] = { 1, 2, 3 }  },
		["leader"] = { [ "formalname" ] = "Rebellion Leader", [ "loadout" ] = { "weapon_mad_knife", "clothing_combat", "weapon_zipties" }, [ "level" ] = 2, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 1,
		[ "canbroadcast" ] = false,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "rebel",
		[ "radiocolor" ] = Color( 255, 255, 255 ),
		[ "iscombine" ] = false,
		[ "radiogroup" ] = 2
	},
	2,
	2,
	"hl2rp/lambda",
	{ 	"rebel",
		"faction",
		"rebels",
		"rebellion"
	})
	
	CAKE.HL2RPFaction( "Civil Workers Union",
	"Unknown",
	{ 	
		["worker"] = { [ "formalname" ] = "CWU Worker", [ "loadout" ] = { }, [ "level" ] = 1  },
		["salesman"] = { [ "formalname" ] = "CWU Salesman", [ "loadout" ] = { }, [ "level" ] = 1, ["canbuy"] = true, ["buygroups"] = { 1, 3 }  },
		["leader"] = { [ "formalname" ] = "CWU Leader", [ "loadout" ] = { }, [ "level" ] = 2, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 1,
		[ "canbroadcast" ] = false,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "worker",
		[ "radiocolor" ] = Color( 255, 255, 255 ),
		[ "iscombine" ] = false,
		[ "radiogroup" ] = 1
	},
	2,
	2,
	"hl2rp/cwu",
	{ 	"civil",
		"workers",
		"union",
		"cwu"
	})
	
end
