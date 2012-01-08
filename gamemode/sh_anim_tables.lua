Anims.Male = {}
Anims.Male[ "models" ] = {
	"models/humans/group01/male_01.mdl",
	"models/combine_soldier.mdl",
	"models/police.mdl"
}
Anims.Male[ "default" ] = { 
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_IDLE",
	--[ "walk" ] = "&gesture:models/humans/group01/male_01.mdl;ACT_WALK;G_what;1",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK",
	[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN",
	[ "jump" ] = "&switch:models/humans/group01/male_01.mdl;ACT_JUMP",
	[ "land" ] = "&switch:models/humans/group01/male_01.mdl;ACT_LAND",
	[ "fly" ] = "&switch:models/humans/group01/male_01.mdl;ACT_GLIDE",
	[ "sit" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/humans/group01/male_01.mdl;ACT_GLIDE",
	[ "sitground" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_GROUND",
	[ "sitgroundentry" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "&sequence:models/humans/group01/male_01.mdl;sprint_all",
	[ "flinch" ] = {
		["explosion"] = "&switch:models/humans/group01/male_01.mdl;ACT_GESTURE_FLINCH_BLAST"
	},
		[ "crouch" ] = {
				[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_COVER_LOW",
				[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH",
				[ "aimidle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
				[ "aimwalk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
		},
		[ "aim" ] = {
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
	[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	}
}
Anims.Male[ "relaxed" ] = { 
	[ "idle" ] = "&sequence:models/humans/group01/male_01.mdl;LineIdle01",
	--[ "walk" ] = "&gesture:models/humans/group01/male_01.mdl;ACT_WALK;G_what;1",
	[ "walk" ] = "&sequence:models/humans/group01/male_01.mdl;walk_all_Moderate",
	[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN",
	[ "jump" ] = "&switch:models/humans/group01/male_01.mdl;ACT_JUMP",
	[ "land" ] = "&switch:models/humans/group01/male_01.mdl;ACT_LAND",
	[ "fly" ] = "&switch:models/humans/group01/male_01.mdl;ACT_GLIDE",
	[ "sit" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/humans/group01/male_01.mdl;ACT_GLIDE",
	[ "sitground" ] = "&sequence:models/humans/group01/male_01.mdl;plazaidle4",
	[ "sitgroundentry" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "&sequence:models/humans/group01/male_01.mdl;sprint_all",
	[ "flinch" ] = {
	["explosion"] = "&switch:models/humans/group01/male_01.mdl;ACT_GESTURE_FLINCH_BLAST"
	},
		[ "crouch" ] = {
				[ "idle" ] = "&sequence:models/humans/group01/male_01.mdl;roofidle2",
				[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH",
				[ "aimidle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
				[ "aimwalk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
		},
		[ "aim" ] = {
			[ "idle" ] = "&sequence:models/humans/group01/male_01.mdl;Man_Gun",
			[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
			[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
}
Anims.Male[ "headstrong" ] = { 
	[ "idle" ] = "&sequence:models/barney.mdl;ACT_IDLE",
	--[ "walk" ] = "&gesture:models/barney.mdl;ACT_WALK;G_what;1",
	[ "walk" ] = "&sequence:models/barney.mdl;walk_all_Moderate",
	[ "run" ] = "&switch:models/barney.mdl;ACT_RUN",
	[ "jump" ] = "&switch:models/barney.mdl;ACT_JUMP",
	[ "land" ] = "&switch:models/barney.mdl;ACT_LAND",
	[ "fly" ] = "&switch:models/barney.mdl;ACT_GLIDE",
	[ "sit" ] = "&switch:models/barney.mdl;ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "&switch:models/barney.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "&switch:models/barney.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/barney.mdl;ACT_GLIDE",
	[ "sitground" ] = "&sequence:models/barney.mdl;plazaidle4",
	[ "sitgroundentry" ] = "&switch:models/barney.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "&switch:models/barney.mdl;ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "&sequence:models/barney.mdl;sprint_all",
	[ "flinch" ] = {
		["explosion"] = "&switch:models/barney.mdl;ACT_GESTURE_FLINCH_BLAST"
	},
		[ "crouch" ] = {
				[ "idle" ] = "&sequence:models/barney.mdl;roofidle2",
				[ "walk" ] = "&switch:models/barney.mdl;ACT_WALK_CROUCH",
				[ "aimidle" ] = "&switch:models/barney.mdl;ACT_RANGE_AIM_SMG1_LOW",
				[ "aimwalk" ] = "&switch:models/barney.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
		},
		[ "aim" ] = {
			[ "idle" ] = "&sequence:models/barney.mdl;Man_Gun",
			[ "walk" ] = "&switch:models/barney.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
			[ "run" ] = "&switch:models/barney.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
}
Anims.Male[ "frustrated" ] = { 
	[ "idle" ] = "&sequence:models/humans/group01/male_01.mdl;LineIdle02",
	--[ "walk" ] = "&gesture:models/humans/group01/male_01.mdl;ACT_WALK;G_what;1",
	[ "walk" ] = "&sequence:models/humans/group01/male_01.mdl;walk_all_Moderate",
	[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN",
	[ "jump" ] = "&switch:models/humans/group01/male_01.mdl;ACT_JUMP",
	[ "land" ] = "&switch:models/humans/group01/male_01.mdl;ACT_LAND",
	[ "fly" ] = "&switch:models/humans/group01/male_01.mdl;ACT_GLIDE",
	[ "sit" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/humans/group01/male_01.mdl;ACT_GLIDE",
	[ "sitground" ] = "&sequence:models/humans/group01/male_01.mdl;plazaidle4",
	[ "sitgroundentry" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "&switch:models/humans/group01/male_01.mdl;ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "&sequence:models/humans/group01/male_01.mdl;sprint_all",
	[ "flinch" ] = {
	["explosion"] = "&switch:models/humans/group01/male_01.mdl;ACT_GESTURE_FLINCH_BLAST"
	},
		[ "crouch" ] = {
				[ "idle" ] = "&sequence:models/humans/group01/male_01.mdl;roofidle2",
				[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH",
				[ "aimidle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
				[ "aimwalk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
		},
		[ "aim" ] = {
			[ "idle" ] = "&sequence:models/humans/group01/male_01.mdl;Man_Gun",
			[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
			[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
}
Anims.Male[ "pistol" ] = {
	[ "idle" ] = "ACT_IDLE",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK_PISTOL",
	[ "run" ] = "&switch:models/police.mdl;ACT_RUN_PISTOL",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/police.mdl;ACT_COVER_PISTOL_LOW",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK_CROUCH",
	[ "aimidle" ] = "&switch:models/police.mdl;ACT_COVER_PISTOL_LOW",
	[ "aimwalk" ] = "&switch:models/police.mdl;ACT_WALK_CROUCH"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/police.mdl;ACT_IDLE_ANGRY_PISTOL",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK_AIM_PISTOL",
	[ "run" ] = "&switch:models/police.mdl;ACT_RUN_AIM_PISTOL"
	},
		[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_PISTOL",
	[ "reload" ] = "ACT_GESTURE_RELOAD_PISTOL"
}
Anims.Male[ "ar2" ] = {
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_IDLE_SMG1_RELAXED",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_RIFLE_RELAXED",
	[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN_RIFLE_RELAXED",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH_RIFLE",
	[ "aimidle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
	[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Male[ "smg" ] = {
	[ "idle" ] = "&switch:models/police.mdl;ACT_IDLE_SMG1",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK_RIFLE",
	[ "run" ] = "&switch:models/police.mdl;ACT_RUN_RIFLE",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/police.mdl;ACT_COVER_SMG1_LOW",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK_CROUCH",
	[ "aimidle" ] = "&switch:models/police.mdl;ACT_COVER_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/police.mdl;ACT_WALK_CROUCH"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/police.mdl;ACT_IDLE_ANGRY_SMG1",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK_AIM_RIFLE",
	[ "run" ] = "&switch:models/police.mdl;ACT_RUN_AIM_RIFLE"
	},
		[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_SMG1",
	[ "reload" ] = "ACT_GESTURE_RELOAD_SMG1"
}

Anims.Male[ "shotgun" ] = {
	[ "idle" ] = "&switch:models/combine_soldier.mdl;ACT_IDLE",
	[ "walk" ] = "&switch:models/combine_soldier.mdl;ACT_WALK_RIFLE",
	[ "run" ] = "&switch:models/combine_soldier.mdl;ACT_RUN_RIFLE",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/combine_soldier.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/combine_soldier.mdl;ACT_WALK_CROUCH_RIFLE",
	[ "aimidle" ] = "&switch:models/combine_soldier.mdl;ACT_RANGE_AIM_AR2_LOW",
	[ "aimwalk" ] = "&switch:models/combine_soldier.mdl;ACT_WALK_CROUCH_RIFLE"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/combine_soldier.mdl;ACT_IDLE_ANGRY_SHOTGUN",
	[ "walk" ] = "&switch:models/combine_soldier.mdl;ACT_WALK_AIM_SHOTGUN",
	[ "run" ] = "&switch:models/combine_soldier.mdl;ACT_RUN_AIM_SHOTGUN"
	},
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SHOTGUN"
}

Anims.Male[ "crossbow" ] = {
	[ "idle" ] = "&switch:models/combine_soldier.mdl;ACT_IDLE",
	[ "walk" ] = "&switch:models/combine_soldier.mdl;ACT_WALK_RIFLE",
	[ "run" ] = "&switch:models/combine_soldier.mdl;ACT_RUN_RIFLE",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/combine_soldier.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/combine_soldier.mdl;ACT_WALK_CROUCH_RIFLE",
	[ "aimidle" ] = "&switch:models/combine_soldier.mdl;ACT_RANGE_AIM_AR2_LOW",
	[ "aimwalk" ] = "&switch:models/combine_soldier.mdl;ACT_WALK_CROUCH_RIFLE"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/combine_soldier.mdl;ACT_IDLE_ANGRY",
	[ "walk" ] = "&switch:models/combine_soldier.mdl;ACT_WALK_AIM_RIFLE",
	[ "run" ] = "&switch:models/combine_soldier.mdl;ACT_RUN_AIM_RIFLE"
	},
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_AR2"
}

Anims.Male[ "rpg" ] = {
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_IDLE_RPG",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_RPG_RELAXED",
	[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN_RPG_RELAXED",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_COVER_LOW_RPG",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH_RPG",
	[ "aimidle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_IDLE_ANGRY_RPG",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
	[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Male[ "melee" ] = {
		[ "idle" ] = "&switch:models/police.mdl;ACT_IDLE",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK",
	[ "run" ] = "&switch:models/police.mdl;ACT_RUN",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/police.mdl;ACT_COVER_PISTOL_LOW",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK_CROUCH",
	[ "aimidle" ] = "&switch:models/police.mdl;ACT_COVER_PISTOL_LOW",
	[ "aimwalk" ] = "&switch:models/police.mdl;ACT_WALK_CROUCH"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/police.mdl;ACT_IDLE_ANGRY_MELEE",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK_ANGRY",
	[ "run" ] = "&switch:models/police.mdl;ACT_RUN"
	},
		["fire"] = "ACT_MELEE_ATTACK_SWING_GESTURE"
}

Anims.Male[ "grenade" ] = {
	[ "idle" ] = "&switch:models/police.mdl;ACT_IDLE",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK",
	[ "run" ] = "&switch:models/police.mdl;ACT_RUN",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/police.mdl;ACT_COVER_PISTOL_LOW",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK_CROUCH",
	[ "aimidle" ] = "&switch:models/police.mdl;ACT_COVER_PISTOL_LOW",
	[ "aimwalk" ] = "&switch:models/police.mdl;ACT_WALK_CROUCH"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/police.mdl;ACT_IDLE_ANGRY_MELEE",
	[ "walk" ] = "&switch:models/police.mdl;ACT_WALK_ANGRY",
	[ "run" ] = "&switch:models/police.mdl;ACT_RUN"
	},
		["fire"] = "&switch:models/police.mdl;ACT_COMBINE_THROW_GRENADE"
}

Anims.Male[ "slam" ] = {
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_IDLE",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_SUITCASE",
	[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH",
	[ "aimidle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_CROUCH_RPG"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/humans/group01/male_01.mdl;ACT_IDLE_PACKAGE",
	[ "walk" ] = "&switch:models/humans/group01/male_01.mdl;ACT_WALK_PACKAGE",
	[ "run" ] = "&switch:models/humans/group01/male_01.mdl;ACT_RUN"
	},
		["fire"] = "&switch:models/humans/group01/male_01.mdl;ACT_PICKUP_RACK"
}


--FEMALE ANIMATIONS

 
Anims.Female = {}
Anims.Female[ "models" ] = {
	"models/humans/group01/female_01.mdl",
	"models/alyx.mdl"
}
Anims.Female[ "default" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN",
	[ "jump" ] = "&switch:models/humans/group01/female_01.mdl;ACT_JUMP",
	[ "land" ] = "&switch:models/humans/group01/female_01.mdl;ACT_LAND",
	[ "fly" ] = "&switch:models/humans/group01/female_01.mdl;ACT_GLIDE",
	[ "sit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/humans/group01/female_01.mdl;ACT_GLIDE",
	[ "sitground" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_GROUND",
	[ "sitgroundentry" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN",
	[ "flinch" ] = {
		["explosion"] = "&switch:models/humans/group01/female_01.mdl;ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
		[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_COVER_LOW",
		[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH",
		[ "aimidle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
	[ "fire" ] = "&sequence:models/humans/group01/female_01.mdl;MeleeAttack01"
}
Anims.Female[ "relaxed" ] = { 
	[ "idle" ] = "&sequence:models/humans/group01/female_01.mdl;LineIdle02",
	--[ "walk" ] = "&gesture:models/humans/group01/female_01.mdl;ACT_WALK;G_what;1",
	[ "walk" ] = "&sequence:models/humans/group01/female_01.mdl;walk_all_Moderate",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN",
	[ "jump" ] = "&switch:models/humans/group01/female_01.mdl;ACT_JUMP",
	[ "land" ] = "&switch:models/humans/group01/female_01.mdl;ACT_LAND",
	[ "fly" ] = "&switch:models/humans/group01/female_01.mdl;ACT_GLIDE",
	[ "sit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/humans/group01/female_01.mdl;ACT_GLIDE",
	[ "sitground" ] = "&sequence:models/humans/group01/female_01.mdl;plazaidle4",
	[ "sitgroundentry" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN",
	[ "flinch" ] = {
		["explosion"] = "&switch:models/humans/group01/female_01.mdl;ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
		[ "idle" ] = "&sequence:models/humans/group01/female_01.mdl;roofidle2",
		[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH",
		[ "aimidle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
	[ "fire" ] = "&sequence:models/humans/group01/female_01.mdl;MeleeAttack01"
}
Anims.Female[ "headstrong" ] = {
	[ "idle" ] = "&sequence:models/alyx.mdl;Idle_subtle",
	[ "walk" ] = "&sequence:models/alyx.mdl;walk_all",
	[ "run" ] = "&sequence:models/alyx.mdl;run_all",
	[ "jump" ] = "&switch:models/humans/group01/female_01.mdl;ACT_JUMP",
	[ "land" ] = "&switch:models/humans/group01/female_01.mdl;ACT_LAND",
	[ "fly" ] = "&switch:models/humans/group01/female_01.mdl;ACT_GLIDE",
	[ "sit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/humans/group01/female_01.mdl;ACT_GLIDE",
	[ "sitground" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_GROUND",
	[ "sitgroundentry" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN",
	[ "flinch" ] = {
		["explosion"] = "&switch:models/humans/group01/female_01.mdl;ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
		[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_COVER_LOW",
		[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH",
		[ "aimidle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
	[ "fire" ] = "&sequence:models/humans/group01/female_01.mdl;MeleeAttack01"
}
Anims.Female[ "frustrated" ] = { 
	[ "idle" ] = "&sequence:models/humans/group01/female_01.mdl;LineIdle01",
	--[ "walk" ] = "&gesture:models/humans/group01/female_01.mdl;ACT_WALK;G_what;1",
	[ "walk" ] = "&sequence:models/humans/group01/female_01.mdl;walk_all_Moderate",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN",
	[ "jump" ] = "&switch:models/humans/group01/female_01.mdl;ACT_JUMP",
	[ "land" ] = "&switch:models/humans/group01/female_01.mdl;ACT_LAND",
	[ "fly" ] = "&switch:models/humans/group01/female_01.mdl;ACT_GLIDE",
	[ "sit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR",
	[ "sitentry" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
	[ "sitexit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/humans/group01/female_01.mdl;ACT_GLIDE",
	[ "sitground" ] = "&sequence:models/humans/group01/female_01.mdl;plazaidle4",
	[ "sitgroundentry" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
	[ "sitgroundexit" ] = "&switch:models/humans/group01/female_01.mdl;ACT_BUSY_SIT_GROUND_EXIT",
	[ "sprint" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN",
	[ "flinch" ] = {
		["explosion"] = "&switch:models/humans/group01/female_01.mdl;ACT_GESTURE_FLINCH_BLAST"
	},
	[ "crouch" ] = {
		[ "idle" ] = "&sequence:models/humans/group01/female_01.mdl;roofidle2",
		[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH",
		[ "aimidle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
		[ "aimwalk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
		[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
		[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
		[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
	[ "fire" ] = "&sequence:models/humans/group01/female_01.mdl;MeleeAttack01"
}
Anims.Female[ "pistol" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_IDLE_PISTOL",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK",
	[ "run" ] = "&switch:models/alyx.mdl;ACT_RUN",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_CROUCH",
	[ "aimidle" ] = "&switch:models/alyx.mdl;ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/alyx.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_IDLE_ANGRY_PISTOL",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_AIM_PISTOL",
	[ "run" ] = "&switch:models/alyx.mdl;ACT_RUN_AIM_PISTOL"
	},
[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_PISTOL",
}
Anims.Female[ "ar2" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_SMG1_RELAXED",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_RIFLE_RELAXED",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN_RIFLE_RELAXED",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_RIFLE",
	[ "aimidle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Female[ "smg" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_IDLE_SMG1",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_RIFLE",
	[ "run" ] = "&switch:models/alyx.mdl;ACT_RUN_RIFLE",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_CROUCH_RIFLE",
	[ "aimidle" ] = "&switch:models/alyx.mdl;ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/alyx.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_IDLE_ANGRY_SMG1",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_AIM_RIFLE",
	[ "run" ] = "&switch:models/alyx.mdl;ACT_RUN_AIM_RIFLE"
	},
[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_SMG1",
}

Anims.Female[ "shotgun" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_IDLE_SHOTGUN_STIMULATED",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_RIFLE_RELAXED",
	[ "run" ] = "&switch:models/alyx.mdl;ACT_RUN_RIFLE_RELAXED",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_CROUCH_RIFLE",
	[ "aimidle" ] = "&switch:models/alyx.mdl;ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/alyx.mdl;ACT_WALK_CROUCH_RIFLE"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_IDLE_ANGRY_RPG",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_AIM_RIFLE",
	[ "run" ] = "&switch:models/alyx.mdl;ACT_RUN_AIM_RIFLE"
	},
["fire"] = "ACT_GESTURE_RANGE_ATTACK_SHOTGUN"
}

Anims.Female[ "crossbow" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_SMG1_RELAXED",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_RIFLE_RELAXED",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN_RIFLE_RELAXED",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_RIFLE",
	[ "aimidle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Female[ "rpg" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_RPG",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_RPG_RELAXED",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN_RPG_RELAXED",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_COVER_LOW_RPG",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_RPG",
	[ "aimidle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_ANGRY_RPG",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
	},
["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Female[ "melee" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_IDLE",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK",
	[ "run" ] = "&switch:models/alyx.mdl;ACT_RUN",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_CROUCH",
	[ "aimidle" ] = "&switch:models/alyx.mdl;ACT_COVER_PISTOL_LOW",
	[ "aimwalk" ] = "&switch:models/alyx.mdl;ACT_WALK_CROUCH"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_IDLE_MANNEDGUN",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_PACKAGE",
	[ "run" ] = "&switch:models/alyx.mdl;ACT_RUN"
	},
["fire"] = "ACT_MELEE_ATTACK_SWING"
}

Anims.Female[ "grenade" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_IDLE",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK",
	[ "run" ] = "&switch:models/alyx.mdl;ACT_RUN",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_CROUCH",
	[ "aimidle" ] = "&switch:models/alyx.mdl;ACT_COVER_PISTOL_LOW",
	[ "aimwalk" ] = "&switch:models/alyx.mdl;ACT_WALK_CROUCH"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/alyx.mdl;ACT_IDLE_ANGRY_PISTOL",
	[ "walk" ] = "&switch:models/alyx.mdl;ACT_WALK_PACKAGE",
	[ "run" ] = "&switch:models/alyx.mdl;ACT_RUN"
	},
["fire"] = "ACT_MELEE_ATTACK_SWING"
}


Anims.Female[ "slam" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_SUITCASE",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN",
	[ "crouch" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_COVER_LOW",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH",
	[ "aimidle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RANGE_AIM_SMG1_LOW",
	[ "aimwalk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_CROUCH_RPG"
	},
	[ "aim" ] = {
	[ "idle" ] = "&switch:models/humans/group01/female_01.mdl;ACT_IDLE_PACKAGE",
	[ "walk" ] = "&switch:models/humans/group01/female_01.mdl;ACT_WALK_PACKAGE",
	[ "run" ] = "&switch:models/humans/group01/female_01.mdl;ACT_RUN"
	},
["fire"] = "ACT_PICKUP_RACK"
}

util.PrecacheModel("models/tiramisu/gearhandler.mdl")
for _,mdl in pairs(Anims.Male[ "models" ]) do
	util.PrecacheModel( mdl )
end

for _,mdl in pairs(Anims.Female[ "models" ]) do
	util.PrecacheModel( mdl )
end