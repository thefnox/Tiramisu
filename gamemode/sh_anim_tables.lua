Anims = {}
Anims.Male = {}
Anims.Male[ "models" ] = {
	"models/tiramisu/animationtrees/maleanimtree.mdl",
	"models/tiramisu/animationtrees/combineanimtree.mdl",
	"models/tiramisu/animationtrees/policeanimtree.mdl"
}
Anims.Male[ "default" ] = { 
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_IDLE",
	--[ "walk" ] = "&gesture:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK;G_what;1",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RUN",
    [ "jump" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_JUMP",
    [ "land" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_LAND",
    [ "fly" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_GLIDE",
    [ "sit" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_BUSY_SIT_CHAIR",
    [ "sitentry" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
    [ "sitexit" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_GLIDE",
    [ "sitground" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_BUSY_SIT_GROUND",
    [ "sitgroundentry" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
    [ "sitgroundexit" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_BUSY_SIT_GROUND_EXIT",
    [ "flinch" ] = {
    ["explosion"] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_GESTURE_FLINCH_BLAST"
    },
		[ "crouch" ] = {
				[ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_COVER_LOW",
				[ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_CROUCH",
				[ "aimidle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
				[ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
		},
		[ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    }
}
Anims.Male[ "pistol" ] = {
    [ "idle" ] = "ACT_IDLE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_PISTOL",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_RUN_PISTOL",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_IDLE_ANGRY_PISTOL",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_AIM_PISTOL",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_RUN_AIM_PISTOL"
    },
		[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_PISTOL",
    [ "reload" ] = "ACT_GESTURE_RELOAD_PISTOL"
}
Anims.Male[ "ar2" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_IDLE_SMG1_RELAXED",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_RIFLE_RELAXED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RUN_RIFLE_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Male[ "smg" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_IDLE_SMG1",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_RIFLE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_RUN_RIFLE",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_COVER_SMG1_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_COVER_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_IDLE_ANGRY_SMG1",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_AIM_RIFLE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_RUN_AIM_RIFLE"
    },
		[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_SMG1",
    [ "reload" ] = "ACT_GESTURE_RELOAD_SMG1"
}

Anims.Male[ "shotgun" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_WALK_RIFLE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_RUN_RIFLE",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_RANGE_AIM_AR2_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_WALK_CROUCH_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_IDLE_ANGRY_SHOTGUN",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_WALK_AIM_SHOTGUN",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_RUN_AIM_SHOTGUN"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SHOTGUN"
}

Anims.Male[ "crossbow" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_WALK_RIFLE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_RUN_RIFLE",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_RANGE_AIM_AR2_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_WALK_CROUCH_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_IDLE_ANGRY",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_WALK_AIM_RIFLE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/combineanimtree.mdl;ACT_RUN_AIM_RIFLE"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_AR2"
}

Anims.Male[ "rpg" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_IDLE_RPG",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_RPG_RELAXED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RUN_RPG_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_COVER_LOW_RPG",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_CROUCH_RPG",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_IDLE_ANGRY_RPG",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Male[ "melee" ] = {
		[ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_IDLE_ANGRY_MELEE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_ANGRY",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_RUN"
    },
		["fire"] = "ACT_MELEE_ATTACK_SWING_GESTURE"
}

Anims.Male[ "grenade" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_IDLE_ANGRY_MELEE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_WALK_ANGRY",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_RUN"
    },
		["fire"] = "&switch:models/tiramisu/animationtrees/policeanimtree.mdl;ACT_COMBINE_THROW_GRENADE"
}

Anims.Male[ "slam" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_SUITCASE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_CROUCH_RPG"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_IDLE_PACKAGE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_WALK_PACKAGE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_RUN"
    },
		["fire"] = "&switch:models/tiramisu/animationtrees/maleanimtree.mdl;ACT_PICKUP_RACK"
}
 
Anims.Female = {}
Anims.Female[ "models" ] = {
	"models/tiramisu/animationtrees/femaleanimtree.mdl",
	"models/tiramisu/animationtrees/alyxanimtree.mdl"
}
Anims.Female[ "default" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RUN",
    [ "jump" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_JUMP",
    [ "land" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_LAND",
    [ "fly" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_GLIDE",
    [ "sit" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_BUSY_SIT_CHAIR",
    [ "sitentry" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
    [ "sitexit" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
[ "swim" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_GLIDE",
    [ "sitground" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_BUSY_SIT_GROUND",
    [ "sitgroundentry" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
    [ "sitgroundexit" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_BUSY_SIT_GROUND_EXIT",
    [ "flinch" ] = {
    ["explosion"] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_GESTURE_FLINCH_BLAST"
    },
[ "crouch" ] = {
[ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_COVER_LOW",
[ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_CROUCH",
[ "aimidle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
[ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
},
[ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    }
}
Anims.Female[ "pistol" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_IDLE_PISTOL",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_IDLE_ANGRY_PISTOL",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_AIM_PISTOL",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RUN_AIM_PISTOL"
    },
[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_PISTOL",
}
Anims.Female[ "ar2" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_IDLE_SMG1_RELAXED",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_RIFLE_RELAXED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RUN_RIFLE_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    },
["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Female[ "smg" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_IDLE_SMG1",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_RIFLE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RUN_RIFLE",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_IDLE_ANGRY_SMG1",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_AIM_RIFLE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RUN_AIM_RIFLE"
    },
[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_SMG1",
}

Anims.Female[ "shotgun" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_IDLE_SHOTGUN_STIMULATED",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_RIFLE_RELAXED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RUN_RIFLE_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_CROUCH_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_IDLE_ANGRY_RPG",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_AIM_RIFLE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RUN_AIM_RIFLE"
    },
["fire"] = "ACT_GESTURE_RANGE_ATTACK_SHOTGUN"
}

Anims.Female[ "crossbow" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_IDLE_SMG1_RELAXED",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_RIFLE_RELAXED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RUN_RIFLE_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    },
["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Female[ "rpg" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_IDLE_RPG",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_RPG_RELAXED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RUN_RPG_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_COVER_LOW_RPG",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_CROUCH_RPG",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_IDLE_ANGRY_RPG",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    },
["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Female[ "melee" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_IDLE_MANNEDGUN",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_PACKAGE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RUN"
    },
["fire"] = "ACT_MELEE_ATTACK_SWING"
}

Anims.Female[ "grenade" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_IDLE_ANGRY_PISTOL",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_WALK_PACKAGE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/alyxanimtree.mdl;ACT_RUN"
    },
["fire"] = "ACT_MELEE_ATTACK_SWING"
}


Anims.Female[ "slam" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_SUITCASE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_CROUCH_RPG"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_IDLE_PACKAGE",
    [ "walk" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_WALK_PACKAGE",
    [ "run" ] = "&switch:models/tiramisu/animationtrees/femaleanimtree.mdl;ACT_RUN"
    },
["fire"] = "ACT_PICKUP_RACK"
}