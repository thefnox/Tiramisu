Anims.Male = {}
if CAKE.ConVars[ "UseEnhancedCitizens" ] then
	Anims.Male[ "models" ] = {
		"models/bloo_ltcom/citizens/male_01.mdl",
		"models/breen.mdl",
		"models/player/breen.mdl",
		"models/Barney.mdl"
	}
else
	Anims.Male[ "models" ] = {
		"models/breen.mdl",
		"models/player/breen.mdl",
		"models/Barney.mdl"
	}
end
Anims.Male.Emotes = {
	["wave"] = {
		["anim"] = {
			["type"] = "sequence",
			["act"] = "Wave"
		},
		["name"] = "Wave",
		["length"] = 4
	},
	["bringit"] = {
		["anim"] = {
			["type"] = "sequence",
			["act"] = "Wave_close"
		},
		["name"] = "Bring It",
		["length"] = 2.4
	},
	["disgust"] = {
		["anim"] = {
			["type"] = "sequence",
			["act"] = "photo_react_blind"
		},
		["name"] = "Show Disgust",
		["length"] = 3.4
	},
	["startle"] = {
		["anim"] = {
			["type"] = "sequence",
			["act"] = "photo_react_startle"
		},
		["name"] = "Startle",
		["length"] = 2
	},
	["throw"] = {
		["anim"] = {
			["type"] = "sequence",
			["act"] = "throw1"
		},
		["name"] = "Throw",
		["length"] = 2
	},
}
Anims.Male[ "default" ] = { 
	[ "idle" ] = {
		["type"] = "sequence",
		["act"] = "LineIdle03"
	},
	--[ "walk" ] = "&gesture:;ACT_WALK;G_what;1",
	[ "walk" ] = "ACT_WALK",
	[ "run" ] = "ACT_RUN",
	[ "jump" ] = "ACT_JUMP",
	[ "land" ] = "ACT_LAND",
	[ "fly" ] = "ACT_GLIDE",
	[ "sit" ] = "ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = {
		["model"] = "models/player/breen.mdl",
		["type"] = "switch",
		["act"] = "ACT_MP_SWIM"
	},
	[ "sitground" ] = "ACT_BUSY_SIT_GROUND",
	[ "sitgroundentry" ] = "ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = {
		["type"] = "sequence",
		["act"] = "sprint_all"
	},
	[ "flinch" ] = {
		["explosion"] = "ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	}
}
Anims.Male[ "relaxed" ] = { 
	[ "idle" ] = {
		["type"] = "sequence",
		["act"] = "LineIdle01"
	},
	[ "walk" ] = {
		["type"] = "sequence",
		["act"] = "walk_all_Moderate"
	},
	[ "run" ] = "ACT_RUN",
	[ "jump" ] = "ACT_JUMP",
	[ "land" ] = "ACT_LAND",
	[ "fly" ] = "ACT_GLIDE",
	[ "sit" ] = "ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = {
		["model"] = "models/player/breen.mdl",
		["type"] = "switch",
		["act"] = "ACT_MP_SWIM"
	},
	[ "sitground" ] = "ACT_BUSY_SIT_GROUND",
	[ "sitgroundentry" ] = "ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = {
		["type"] = "sequence",
		["act"] = "sprint_all"
	},
	[ "flinch" ] = {
	["explosion"] = "ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	}
}
Anims.Male[ "headstrong" ] = { 
	[ "idle" ] = {
		["type"] = "sequence",
		["act"] = "idle_subtle"
	},
	[ "walk" ] = "ACT_WALK",
	[ "run" ] = "ACT_RUN",
	[ "jump" ] = "ACT_JUMP",
	[ "land" ] = "ACT_LAND",
	[ "fly" ] = "ACT_GLIDE",
	[ "sit" ] = "ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = {
		["model"] = "models/player/breen.mdl",
		["type"] = "switch",
		["act"] = "ACT_MP_SWIM"
	},
	[ "sitground" ] = "ACT_BUSY_SIT_GROUND",
	[ "sitgroundentry" ] = "ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = {
		["type"] = "sequence",
		["act"] = "sprint_all"
	},
	[ "flinch" ] = {
		["explosion"] = "ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
			[ "idle" ] = "ACT_COVER_LOW",
			[ "walk" ] = "ACT_WALK_CROUCH",
			[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
			[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	}
}
Anims.Male[ "frustrated" ] = { 
	[ "idle" ] = {
		["type"] = "sequence",
		["act"] = "LineIdle02"
	},
	[ "walk" ] = {
		["type"] = "sequence",
		["act"] = "pace_all"
	},
	[ "run" ] = "ACT_RUN",
	[ "jump" ] = "ACT_JUMP",
	[ "land" ] = "ACT_LAND",
	[ "fly" ] = "ACT_GLIDE",
	[ "sit" ] = "ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = {
		["model"] = "models/player/breen.mdl",
		["type"] = "switch",
		["act"] = "ACT_MP_SWIM"
	},
	[ "sitground" ] = "ACT_BUSY_SIT_GROUND",
	[ "sitgroundentry" ] = "ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = {
		["type"] = "sequence",
		["act"] = "sprint_all"
	},
	[ "flinch" ] = {
	["explosion"] = "ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
			[ "idle" ] = "ACT_COVER_LOW",
			[ "walk" ] = "ACT_WALK_CROUCH",
			[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
			[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	}
}
Anims.Male[ "pistol" ] = {
	[ "idle" ] = Anims.Male[ "default" ]["idle"],
	[ "walk" ] = Anims.Male[ "default" ]["walk"],
	[ "run" ] = Anims.Male[ "default" ]["run"],
	[ "crouch" ] = {
		[ "idle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH"
		},
		[ "walk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH"
		},
		[ "aimidle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_PISTOL"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_PISTOL"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_PISTOL"
		},
		[ "walk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_PISTOL"
		},
		[ "run" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_PISTOL"
		},
	},
	[ "fire" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
	[ "reload" ] = ACT_HL2MP_GESTURE_RELOAD_PISTOL
}
Anims.Male[ "ar2" ] = {
	[ "idle" ] = "ACT_IDLE_SMG1_RELAXED",
	[ "walk" ] = "ACT_WALK_RIFLE_RELAXED",
	[ "run" ] = "ACT_RUN_RIFLE_RELAXED",
	[ "crouch" ] = {
		[ "idle" ] = "ACT_COVER_LOW",
		[ "walk" ] = "ACT_WALK_CROUCH_RIFLE",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	},
	["fire"] = ACT_GESTURE_RANGE_ATTACK_SMG1
}

Anims.Male[ "smg" ] = {
	[ "idle" ] = {
		["model"] = "models/Barney.mdl",
		["type"] = "switch",
		["act"] = "ACT_IDLE_SMG1_RELAXED"
	},
	[ "walk" ] = {
		["model"] = "models/Barney.mdl",
		["type"] = "switch",
		["act"] = "ACT_WALK_RIFLE_STIMULATED"
	},
	[ "run" ] = {
		["model"] = "models/Barney.mdl",
		["type"] = "switch",
		["act"] = "ACT_RUN_RIFLE_STIMULATED"
	},
	[ "crouch" ] = {
		[ "idle" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "switch",
			["act"] = "ACT_COVER_LOW"
		},
		[ "walk" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Crouch_walk_holding_all"
		},
		[ "aimidle" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "crouch_aim_smg1"
		},
		[ "aimwalk" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Crouch_walk_aiming_all"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Idle_SMG1_Aim_Alert"
		},
		[ "walk" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "switch",
			["act"] = "ACT_WALK_AIM_RIFLE"
		},
		[ "run" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "switch",
			["act"] = "ACT_RUN_AIM_RIFLE"
		},
	},
	[ "fire" ] = ACT_GESTURE_RANGE_ATTACK_SMG1,
	[ "reload" ] = ACT_GESTURE_RELOAD_SMG1
}

Anims.Male[ "shotgun" ] = {
	[ "idle" ] = {
		["model"] = "models/Barney.mdl",
		["type"] = "switch",
		["act"] = "ACT_IDLE_SHOTGUN_RELAXED"
	},
	[ "walk" ] = {
		["model"] = "models/Barney.mdl",
		["type"] = "switch",
		["act"] = "ACT_WALK_RPG_RELAXED"
	},
	[ "run" ] = {
		["model"] = "models/Barney.mdl",
		["type"] = "sequence",
		["act"] = "run_RPG_Relaxed_all"
	},
	[ "crouch" ] = {
		[ "idle" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Crouch_Idle_RPG"
		},
		[ "walk" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Crouch_walk_holding_RPG_all"
		},
		[ "aimidle" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "crouch_aim_smg1"
		},
		[ "aimwalk" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Crouch_walk_aiming_all"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Idle_RPG_Aim"
		},
		[ "walk" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "walkAlertAimALL1"
		},
		[ "run" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "run_aiming_ar2_all"
		},
	},
	["fire"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
}

Anims.Male[ "crossbow" ] = {
	[ "idle" ] = {
		["model"] = "models/Barney.mdl",
		["type"] = "switch",
		["act"] = "ACT_IDLE_SHOTGUN_RELAXED"
	},
	[ "walk" ] = {
		["model"] = "models/Barney.mdl",
		["type"] = "switch",
		["act"] = "ACT_WALK_RPG_RELAXED"
	},
	[ "run" ] = {
		["model"] = "models/Barney.mdl",
		["type"] = "sequence",
		["act"] = "run_RPG_Relaxed_all"
	},
	[ "crouch" ] = {
		[ "idle" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Crouch_Idle_RPG"
		},
		[ "walk" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Crouch_walk_holding_RPG_all"
		},
		[ "aimidle" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "crouch_aim_smg1"
		},
		[ "aimwalk" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Crouch_walk_aiming_all"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "Idle_RPG_Aim"
		},
		[ "walk" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "walkAlertAimALL1"
		},
		[ "run" ] = {
			["model"] = "models/Barney.mdl",
			["type"] = "sequence",
			["act"] = "run_aiming_ar2_all"
		},
	},
	["fire"] = ACT_GESTURE_RANGE_ATTACK_AR2
}

Anims.Male[ "rpg" ] = {
	[ "idle" ] = "ACT_IDLE_RPG",
	[ "walk" ] = "ACT_WALK_RPG_RELAXED",
	[ "run" ] = "ACT_RUN_RPG_RELAXED",
	[ "crouch" ] = {
		[ "idle" ] = "ACT_COVER_LOW_RPG",
		[ "walk" ] = "ACT_WALK_CROUCH_RPG",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_ANGRY_RPG",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	},
	["fire"] = ACT_GESTURE_RANGE_ATTACK_SMG1
}

Anims.Male[ "melee" ] = {
	[ "idle" ] = Anims.Male[ "default" ]["idle"],
	[ "walk" ] = Anims.Male[ "default" ]["walk"],
	[ "run" ] = Anims.Male[ "default" ]["run"],
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_MELEE"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_MELEE"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_MELEE"
		},
		[ "walk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_MELEE"
		},
		[ "run" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_MELEE"
		},
	},
	["fire"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
}

Anims.Male[ "melee2" ] = {
	[ "idle" ] = Anims.Male[ "default" ]["idle"],
	[ "walk" ] = Anims.Male[ "default" ]["walk"],
	[ "run" ] = Anims.Male[ "default" ]["run"],
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_MELEE2"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_MELEE2"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_MELEE2"
		},
		[ "walk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_MELEE2"
		},
		[ "run" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_MELEE2"
		},
	},
	["fire"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
}

Anims.Male[ "knife" ] = {
	[ "idle" ] = Anims.Male[ "default" ]["idle"],
	[ "walk" ] = Anims.Male[ "default" ]["walk"],
	[ "run" ] = Anims.Male[ "default" ]["run"],
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_KNIFE"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_KNIFE"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_KNIFE"
		},
		[ "walk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_KNIFE"
		},
		[ "run" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_KNIFE"
		},
	},
	["fire"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
}

Anims.Male[ "grenade" ] = {
	[ "idle" ] = Anims.Male[ "default" ]["idle"],
	[ "walk" ] = Anims.Male[ "default" ]["walk"],
	[ "run" ] = Anims.Male[ "default" ]["run"],
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_GRENADE"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_GRENADE"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_GRENADE"
		},
		[ "walk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_GRENADE"
		},
		[ "run" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_GRENADE"
		},
	},
	["fire"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE
}

Anims.Male[ "fist" ] = {
	[ "idle" ] = Anims.Male[ "default" ]["idle"],
	[ "walk" ] = Anims.Male[ "default" ]["walk"],
	[ "run" ] = Anims.Male[ "default" ]["run"],
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "crouchidlehide",
			["act"] = "LineIdle03"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_FIST"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_FIST"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_FIST"
		},
		[ "walk" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_FIST"
		},
		[ "run" ] = {
			["model"] = "models/player/breen.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_FIST"
		},
	},
}

Anims.Male[ "slam" ] = {
	[ "idle" ] = Anims.Male[ "default" ]["idle"],
	[ "walk" ] = Anims.Male[ "default" ]["walk"],
	[ "run" ] = Anims.Male[ "default" ]["run"],
	[ "crouch" ] = {
	[ "idle" ] = "ACT_COVER_LOW",
	[ "walk" ] = "ACT_WALK_CROUCH",
	[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "ACT_WALK_CROUCH_RPG"
	},
	[ "aim" ] = {
	[ "idle" ] = "ACT_IDLE_PACKAGE",
	[ "walk" ] = "ACT_WALK_PACKAGE",
	[ "run" ] = "ACT_RUN"
	},
}


--FEMALE ANIMATIONS

 
Anims.Female = {}
if CAKE.ConVars[ "UseEnhancedCitizens" ] then
	Anims.Female[ "models" ] = {
		"models/bloo_ltcom/citizens/female_01.mdl",
		"models/alyx.mdl",
		"models/player/mossman.mdl"
	}
else
	Anims.Female[ "models" ] = {
		"models/alyx.mdl",
		"models/player/mossman.mdl"
	}
end
Anims.Female.Emotes = {
	["wave"] = {
		["anim"] = {
			["type"] = "sequence",
			["act"] = "Wave"
		},
		["name"] = "Wave",
		["length"] = 4
	},
	["bringit"] = {
		["anim"] = {
			["type"] = "sequence",
			["act"] = "Wave_close"
		},
		["name"] = "Bring It",
		["length"] = 2.4
	},
	["disgust"] = {
		["anim"] = {
			["type"] = "sequence",
			["act"] = "photo_react_blind"
		},
		["name"] = "Show Disgust",
		["length"] = 3.4
	},
	["startle"] = {
		["anim"] = {
			["type"] = "sequence",
			["act"] = "photo_react_startle"
		},
		["name"] = "Startle",
		["length"] = 2
	},
	["throw"] = {
		["anim"] = {
			["type"] = "sequence",
			["act"] = "throw1"
		},
		["name"] = "Throw",
		["length"] = 2
	},
}

Anims.Female[ "default" ] = {
	[ "idle" ] = "ACT_IDLE",
	[ "walk" ] = "ACT_WALK",
	[ "run" ] = "ACT_RUN",
	[ "jump" ] = "ACT_JUMP",
	[ "land" ] = "ACT_LAND",
	[ "fly" ] = "ACT_GLIDE",
	[ "sit" ] = "ACT_BUSY_SIT_CHAIR",
	[ "swim" ] = {
		["model"] = "models/player/mossman.mdl",
		["type"] = "sequence",
		["act"] = "ACT_MP_SWIM"
	},
	[ "sitentry" ] = "ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "ACT_GLIDE",
	[ "sitground" ] = "ACT_BUSY_SIT_GROUND",
	[ "sitgroundentry" ] = "ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "ACT_RUN",
	[ "flinch" ] = {
		["explosion"] = "ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
		[ "idle" ] = "ACT_COVER_LOW",
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	},
}
Anims.Female[ "relaxed" ] = { 
	[ "idle" ] = {
		["type"] = "sequence",
		["act"] = "LineIdle02"
	},
	[ "walk" ] = {
		["type"] = "sequence",
		["act"] = "walk_all_Moderate"
	},
	[ "run" ] = "ACT_RUN",
	[ "jump" ] = "ACT_JUMP",
	[ "land" ] = "ACT_LAND",
	[ "fly" ] = "ACT_GLIDE",
	[ "sitentry" ] = "ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "ACT_BUSY_SIT_CHAIR_EXIT",
	[ "sit" ] = "ACT_BUSY_SIT_CHAIR",
	[ "swim" ] = {
		["model"] = "models/player/mossman.mdl",
		["type"] = "sequence",
		["act"] = "ACT_MP_SWIM"
	},
	[ "sitground" ] = {
		["type"] = "sequence",
		["act"] = "canals_mary_postidle"
	},
	[ "sitgroundentry" ] = "ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "ACT_RUN",
	[ "flinch" ] = {
		["explosion"] = "ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "roofidle2"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	}
}
Anims.Female[ "headstrong" ] = {
	[ "idle" ] = {
		["type"] = "sequence",
		["act"] = "Idle_subtle"
	},
	[ "walk" ] = {
		["type"] = "sequence",
		["act"] = "walk_all"
	},
	[ "run" ] = {
		["type"] = "sequence",
		["act"] = "run_all"
	},
	[ "jump" ] = "ACT_JUMP",
	[ "land" ] = "ACT_LAND",
	[ "fly" ] = "ACT_GLIDE",
	[ "sitentry" ] = "ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "ACT_BUSY_SIT_CHAIR_EXIT",
	[ "sit" ] = "ACT_BUSY_SIT_CHAIR",
	[ "swim" ] = {
		["model"] = "models/player/mossman.mdl",
		["type"] = "sequence",
		["act"] = "ACT_MP_SWIM"
	},
	[ "sitground" ] = "ACT_BUSY_SIT_GROUND",
	[ "sitgroundentry" ] = "ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "ACT_RUN",
	[ "flinch" ] = {
		["explosion"] = "ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
		[ "idle" ] = "ACT_COVER_LOW",
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	},
}
Anims.Female[ "frustrated" ] = { 
	[ "idle" ] = {
		["type"] = "sequence",
		["act"] = "LineIdle01"
	},
	--[ "walk" ] = "&gesture:;ACT_WALK;G_what;1",
	[ "walk" ] = {
		["type"] = "sequence",
		["act"] = "walk_all_Moderate"
	},
	[ "run" ] = "ACT_RUN",
	[ "jump" ] = "ACT_JUMP",
	[ "land" ] = "ACT_LAND",
	[ "fly" ] = "ACT_GLIDE",
	[ "sitentry" ] = "ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "ACT_BUSY_SIT_CHAIR_EXIT",
	[ "sit" ] = "ACT_BUSY_SIT_CHAIR",
	[ "swim" ] = {
		["model"] = "models/player/mossman.mdl",
		["type"] = "switch",
		["act"] = "ACT_MP_SWIM"
	},
	[ "sitground" ] = {
		["type"] = "sequence",
		["act"] = "canals_mary_postidle"
	},
	[ "sitgroundentry" ] = "ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "ACT_RUN",
	[ "flinch" ] = {
		["explosion"] = "ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "roofidle2"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	}
}
Anims.Female[ "pistol" ] = {
	[ "idle" ] = {
		["model"] = "models/alyx.mdl",
		["type"] = "switch",
		["act"] = "ACT_IDLE_PISTOL"
	},
	[ "walk" ] = {
		["model"] = "models/alyx.mdl",
		["type"] = "switch",
		["act"] = "ACT_WALK"
	},
	[ "run" ] = {
		["model"] = "models/alyx.mdl",
		["type"] = "switch",
		["act"] = "ACT_RUN"
	},
	[ "crouch" ] = {
		[ "idle" ] = {
			["model"] = "models/alyx.mdl",
			["type"] = "switch",
			["act"] = "ACT_COVER_LOW"
		},
		[ "walk" ] = {
			["model"] = "models/alyx.mdl",
			["type"] = "switch",
			["act"] = "ACT_WALK_CROUCH"
		},
		[ "aimidle" ] = {
			["model"] = "models/alyx.mdl",
			["type"] = "switch",
			["act"] = "ACT_RANGE_AIM_SMG1_LOW"
		},
		[ "aimwalk" ] = {
			["model"] = "models/alyx.mdl",
			["type"] = "switch",
			["act"] = "ACT_WALK_CROUCH_AIM_RIFLE"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/alyx.mdl",
			["type"] = "switch",
			["act"] = "ACT_IDLE_ANGRY_PISTOL"
		},
		[ "walk" ] = {
			["model"] = "models/alyx.mdl",
			["type"] = "switch",
			["act"] = "ACT_WALK_AIM_PISTOL"
		},
		[ "run" ] = {
			["model"] = "models/alyx.mdl",
			["type"] = "switch",
			["act"] = "ACT_RUN_AIM_PISTOL"
		},
	},
	[ "fire" ] = ACT_GESTURE_RANGE_ATTACK_PISTOL,
}
Anims.Female[ "ar2" ] = {
	[ "idle" ] = "ACT_IDLE_SMG1_RELAXED",
	[ "walk" ] = "ACT_WALK_RIFLE_RELAXED",
	[ "run" ] = "ACT_RUN_RIFLE_RELAXED",
	[ "crouch" ] = {
		[ "idle" ] = "ACT_COVER_LOW",
		[ "walk" ] = "ACT_WALK_CROUCH_RIFLE",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	},
["fire"] = ACT_GESTURE_RANGE_ATTACK_SMG1
}

Anims.Female[ "smg" ] = {
	[ "idle" ] = "ACT_IDLE_SMG1",
	[ "walk" ] = "ACT_WALK_RIFLE",
	[ "run" ] = "ACT_RUN_RIFLE",
	[ "crouch" ] = {
		[ "idle" ] = "ACT_COVER_LOW",
		[ "walk" ] = "ACT_WALK_CROUCH_RIFLE",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
		[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_ANGRY_SMG1",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE",
		[ "run" ] = "ACT_RUN_AIM_RIFLE"
	},
[ "fire" ] = ACT_GESTURE_RANGE_ATTACK_SMG1,
}

Anims.Female[ "shotgun" ] = {
	[ "idle" ] = "ACT_IDLE_SHOTGUN_STIMULATED",
	[ "walk" ] = "ACT_WALK_RIFLE_RELAXED",
	[ "run" ] = "ACT_RUN_RIFLE_RELAXED",
	[ "crouch" ] = {
		[ "idle" ] = "ACT_COVER_LOW",
		[ "walk" ] = "ACT_WALK_CROUCH_RIFLE",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_ANGRY_RPG",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE",
		[ "run" ] = "ACT_RUN_AIM_RIFLE"
	},
["fire"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
}

Anims.Female[ "crossbow" ] = {
	[ "idle" ] = "ACT_IDLE_SMG1_RELAXED",
	[ "walk" ] = "ACT_WALK_RIFLE_RELAXED",
	[ "run" ] = "ACT_RUN_RIFLE_RELAXED",
	[ "crouch" ] = {
		[ "idle" ] = "ACT_COVER_LOW",
		[ "walk" ] = "ACT_WALK_CROUCH_RIFLE",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	},
["fire"] = ACT_GESTURE_RANGE_ATTACK_SMG1
}

Anims.Female[ "rpg" ] = {
	[ "idle" ] = "ACT_IDLE_RPG",
	[ "walk" ] = "ACT_WALK_RPG_RELAXED",
	[ "run" ] = "ACT_RUN_RPG_RELAXED",
	[ "crouch" ] = {
		[ "idle" ] = "ACT_COVER_LOW_RPG",
		[ "walk" ] = "ACT_WALK_CROUCH_RPG",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_ANGRY_RPG",
		[ "walk" ] = "ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "ACT_RUN_AIM_RIFLE_STIMULATED"
	},
["fire"] = ACT_GESTURE_RANGE_ATTACK_SMG1
}

Anims.Female[ "melee" ] = {
	[ "idle" ] = Anims.Female[ "default" ][ "idle" ],
	[ "walk" ] = Anims.Female[ "default" ][ "walk" ],
	[ "run" ] = Anims.Female[ "default" ][ "run" ],
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_MELEE"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_MELEE"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_MELEE"
		},
		[ "walk" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_MELEE"
		},
		[ "run" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_MELEE"
		},
	},
	["fire"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
}

Anims.Female[ "melee2" ] = {
	[ "idle" ] = Anims.Female[ "default" ][ "idle" ],
	[ "walk" ] = Anims.Female[ "default" ][ "walk" ],
	[ "run" ] = Anims.Female[ "default" ][ "run" ],
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_MELEE2"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_MELEE2"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_MELEE2"
		},
		[ "walk" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_MELEE2"
		},
		[ "run" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_MELEE2"
		},
	},
	["fire"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
}

Anims.Female[ "knife" ] = {
	[ "idle" ] = Anims.Female[ "default" ][ "idle" ],
	[ "walk" ] = Anims.Female[ "default" ][ "walk" ],
	[ "run" ] = Anims.Female[ "default" ][ "run" ],
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_KNIFE"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_KNIFE"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_KNIFE"
		},
		[ "walk" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_KNIFE"
		},
		[ "run" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_KNIFE"
		},
	},
	["fire"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
}

Anims.Female[ "fist" ] = {
	[ "idle" ] = Anims.Female[ "default" ][ "idle" ],
	[ "walk" ] = Anims.Female[ "default" ][ "walk" ],
	[ "run" ] = Anims.Female[ "default" ][ "run" ],
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_FIST"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_FIST"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_FIST"
		},
		[ "walk" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_FIST"
		},
		[ "run" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_FIST"
		},
	},
	["fire"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST
}

Anims.Female[ "grenade" ] = {
	[ "idle" ] = Anims.Female[ "default" ][ "idle" ],
	[ "walk" ] = Anims.Female[ "default" ][ "walk" ],
	[ "run" ] = Anims.Female[ "default" ][ "run" ],
	[ "crouch" ] = {
		[ "idle" ] = {
			["type"] = "sequence",
			["act"] = "crouchidlehide"
		},
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_CROUCH_GRENADE"
		},
		[ "aimwalk" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_CROUCH_GRENADE"
		},
	},
	[ "aim" ] = {
		[ "idle" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_IDLE_GRENADE"
		},
		[ "walk" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_WALK_GRENADE"
		},
		[ "run" ] = {
			["model"] = "models/player/mossman.mdl",
			["type"] = "switch",
			["act"] = "ACT_HL2MP_RUN_GRENADE"
		},
	},
	["fire"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE
}

Anims.Female[ "slam" ] = {
	[ "idle" ] = "ACT_IDLE",
	[ "walk" ] = "ACT_WALK_SUITCASE",
	[ "run" ] = "ACT_RUN",
	[ "crouch" ] = {
		[ "idle" ] = "ACT_COVER_LOW",
		[ "walk" ] = "ACT_WALK_CROUCH",
		[ "aimidle" ] = "ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "ACT_WALK_CROUCH_RPG"
	},
	[ "aim" ] = {
		[ "idle" ] = "ACT_IDLE_PACKAGE",
		[ "walk" ] = "ACT_WALK_PACKAGE",
		[ "run" ] = "ACT_RUN"
	},
}

util.PrecacheModel("models/gibs/agibs.mdl")
for _,mdl in pairs(Anims.Male[ "models" ]) do
	util.PrecacheModel( mdl )
end

for _,mdl in pairs(Anims.Female[ "models" ]) do
	util.PrecacheModel( mdl )
end