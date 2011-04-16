--NPC Animations V4

local meta = FindMetaTable( "Player" )
local model

function meta:GetGender()

	model = self:GetModel()
	if table.HasValue( Anims.Female[ "models" ], model ) or self:GetNWString( "gender", "Male" ) == "Female" then
		return "Female"
	end
	
	return "Male"

end

if SERVER then
	--Weapons that are always aimed
	AlwaysAimed = {
		"weapon_physgun",
		"weapon_physcannon",
		"weapon_frag",
		"weapon_slam",
		"weapon_rpg",
		"gmod_tool"
	}

	--Weapons that are never aimed
	NeverAimed = {
    "hands"
	}

    function meta:SetSpecialModel( model )

    self:SetNWBool( "specialmodel", true )
    self:SetModel( model )

    end

	
	function meta:SetAiming( bool )
		local wep = self:GetActiveWeapon()
		if self:GetNWBool( "arrested", false ) then
			bool = false
		end
		if ValidEntity( wep ) then
			if table.HasValue( AlwaysAimed, wep:GetClass() ) then
				bool = true
			end
			if table.HasValue( NeverAimed, wep:GetClass() ) then
				bool = false
			end
			if bool then
				wep:SetNextPrimaryFire( CurTime() )
			else
				wep:SetNextPrimaryFire( CurTime() + 999999 )
			end
		end
		self:DrawViewModel( bool )
		self:SetNWBool( "aiming", bool )
	end
	
	local function HolsterToggle( ply, cmd, args )
		ply:SetAiming( !ply:GetAiming() )
	end
	concommand.Add( "rp_toggleholster", HolsterToggle );
	concommand.Add( "toggleholster", HolsterToggle );
	
	hook.Add( "PlayerSpawn", "TiramisuAnimSpawnHandle", function( ply )
    ply:SetAiming( false )
    ply:SetNWBool( "specialmodel", false )
		timer.Create( ply:SteamID() .. "TiramisuAimTimer", 0.1, 0, function()
			if ValidEntity( ply ) then
				if ply.TiramisuLastWeapon and ValidEntity( ply:GetActiveWeapon() ) and ply:GetActiveWeapon():GetClass() != ply.TiramisuLastWeapon then
					ply:SetAiming( false )
					ply.TiramisuLastWeapon = ply:GetActiveWeapon():GetClass()
				else
					if ValidEntity( ply:GetActiveWeapon() ) then
						ply.TiramisuLastWeapon = ply:GetActiveWeapon():GetClass()
					end
				end
			end
		end)
	end)

    hook.Add( "PlayerSetModel", "TiramisuSetAnimTrees", function( ply )
    if !ply:GetNWBool( "specialmodel", false ) then
        if(ply:IsCharLoaded()) then
            local m = ""
            if( CAKE.GetCharField( ply, "gender" ) == "Female" ) then
            m = "models/Tiramisu/AnimationTrees/femaleanimtree.mdl"
            ply:SetNWString( "gender", "Female" )
            else
            m = "models/Tiramisu/AnimationTrees/maleanimtree.mdl"
            ply:SetNWString( "gender", "Male" )
            end
            
            ply:SetModel( m );
        else
        ply:SetModel("models/kleiner.mdl");
        end
    end
    end )

    hook.Add( "KeyPress", "TiramisuAimCheck", function(ply, key)
    if ValidEntity( ply ) and ValidEntity( ply:GetActiveWeapon() ) then
        if key == IN_ATTACK or key == IN_ATTACK2 then
        ply:SetAiming( true )
        end
    end
    end )
	
end

function meta:GetAiming()
	if self:GetNWBool( "aiming", false ) then
		return true
	end
	
	return false
end

meta = nil

Anims = {}
Anims.Male = {}
Anims.Male[ "models" ] = {
	"models/Tiramisu/AnimationTrees/maleanimtree.mdl",
	"models/Tiramisu/AnimationTrees/combineanimtree.mdl",
	"models/Tiramisu/AnimationTrees/policeanimtree.mdl"
}
Anims.Male[ "default" ] = { 
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_IDLE",
		--[ "idle" ] = "&sequence:LineIdle01;models/Tiramisu/AnimationTrees/maleanimtree.mdl",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RUN",
    [ "jump" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_JUMP",
    [ "land" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_LAND",
    [ "fly" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_GLIDE",
    [ "sit" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_BUSY_SIT_CHAIR",
    [ "sitentry" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
    [ "sitexit" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_GLIDE",
    [ "sitground" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_BUSY_SIT_GROUND",
    [ "sitgroundentry" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
    [ "sitgroundexit" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_BUSY_SIT_GROUND_EXIT",
    [ "flinch" ] = {
    ["explosion"] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_GESTURE_FLINCH_BLAST"
    },
		[ "crouch" ] = {
				[ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_COVER_LOW",
				[ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_CROUCH",
				[ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
				[ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
		},
		[ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    }
}
Anims.Male[ "pistol" ] = {
    [ "idle" ] = "ACT_IDLE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_PISTOL",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_RUN_PISTOL",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_IDLE_ANGRY_PISTOL",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_AIM_PISTOL",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_RUN_AIM_PISTOL"
    },
		[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_PISTOL",
    [ "reload" ] = "ACT_GESTURE_RELOAD_PISTOL"
}
Anims.Male[ "ar2" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_IDLE_SMG1_RELAXED",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_RIFLE_RELAXED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RUN_RIFLE_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Male[ "smg" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_IDLE_SMG1",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_RIFLE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_RUN_RIFLE",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_COVER_SMG1_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_COVER_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_IDLE_ANGRY_SMG1",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_AIM_RIFLE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_RUN_AIM_RIFLE"
    },
		[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_SMG1",
    [ "reload" ] = "ACT_GESTURE_RELOAD_SMG1"
}

Anims.Male[ "shotgun" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_WALK_RIFLE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_RUN_RIFLE",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_RANGE_AIM_AR2_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_WALK_CROUCH_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_IDLE_ANGRY_SHOTGUN",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_WALK_AIM_SHOTGUN",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_RUN_AIM_SHOTGUN"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SHOTGUN"
}

Anims.Male[ "crossbow" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_WALK_RIFLE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_RUN_RIFLE",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_RANGE_AIM_AR2_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_WALK_CROUCH_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_IDLE_ANGRY",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_WALK_AIM_RIFLE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/combineanimtree.mdl;ACT_RUN_AIM_RIFLE"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_AR2"
}

Anims.Male[ "rpg" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_IDLE_RPG",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_RPG_RELAXED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RUN_RPG_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_COVER_LOW_RPG",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_CROUCH_RPG",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_IDLE_ANGRY_RPG",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Male[ "melee" ] = {
		[ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_IDLE_ANGRY_MELEE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_ANGRY",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_RUN"
    },
		["fire"] = "ACT_MELEE_ATTACK_SWING_GESTURE"
}

Anims.Male[ "grenade" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_IDLE_ANGRY_MELEE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_WALK_ANGRY",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_RUN"
    },
		["fire"] = "&switch:models/Tiramisu/AnimationTrees/policeanimtree.mdl;ACT_COMBINE_THROW_GRENADE"
}

Anims.Male[ "slam" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_SUITCASE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_CROUCH_RPG"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_IDLE_PACKAGE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_WALK_PACKAGE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_RUN"
    },
		["fire"] = "&switch:models/Tiramisu/AnimationTrees/maleanimtree.mdl;ACT_PICKUP_RACK"
}
 
 
Anims.Female = {}
Anims.Female[ "models" ] = {
	"models/Tiramisu/AnimationTrees/femaleanimtree.mdl",
	"models/Tiramisu/AnimationTrees/alyxanimtree.mdl"
}
Anims.Female[ "default" ] = { 
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RUN",
    [ "jump" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_JUMP",
    [ "land" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_LAND",
    [ "fly" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_GLIDE",
    [ "sit" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_BUSY_SIT_CHAIR",
    [ "sitentry" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_BUSY_SIT_CHAIR_ENTRY",
    [ "sitexit" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_BUSY_SIT_CHAIR_EXIT",
	[ "swim" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_GLIDE",
    [ "sitground" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_BUSY_SIT_GROUND",
    [ "sitgroundentry" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_BUSY_SIT_GROUND_ENTRY",
    [ "sitgroundexit" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_BUSY_SIT_GROUND_EXIT",
    [ "flinch" ] = {
    ["explosion"] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_GESTURE_FLINCH_BLAST"
    },
		[ "crouch" ] = {
				[ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_COVER_LOW",
				[ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_CROUCH",
				[ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
				[ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
		},
		[ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    }
}
Anims.Female[ "pistol" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_IDLE_PISTOL",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_IDLE_ANGRY_PISTOL",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_AIM_PISTOL",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RUN_AIM_PISTOL"
    },
		[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_PISTOL",
}
Anims.Female[ "ar2" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_IDLE_SMG1_RELAXED",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_RIFLE_RELAXED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RUN_RIFLE_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Female[ "smg" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_IDLE_SMG1",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_RIFLE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RUN_RIFLE",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_IDLE_ANGRY_SMG1",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_AIM_RIFLE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RUN_AIM_RIFLE"
    },
		[ "fire" ] = "ACT_GESTURE_RANGE_ATTACK_SMG1",
}

Anims.Female[ "shotgun" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_IDLE_SHOTGUN_STIMULATED",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_RIFLE_RELAXED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RUN_RIFLE_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_CROUCH_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_IDLE_ANGRY_RPG",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_AIM_RIFLE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RUN_AIM_RIFLE"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SHOTGUN"
}

Anims.Female[ "crossbow" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_IDLE_SMG1_RELAXED",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_RIFLE_RELAXED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RUN_RIFLE_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_CROUCH_RIFLE",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_IDLE_AIM_RIFLE_STIMULATED",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Female[ "rpg" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_IDLE_RPG",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_RPG_RELAXED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RUN_RPG_RELAXED",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_COVER_LOW_RPG",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_CROUCH_RPG",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_CROUCH_AIM_RIFLE"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_IDLE_ANGRY_RPG",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_AIM_RIFLE_STIMULATED",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RUN_AIM_RIFLE_STIMULATED"
    },
		["fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
}

Anims.Female[ "melee" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_IDLE_MANNEDGUN",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_PACKAGE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RUN"
    },
		["fire"] = "ACT_MELEE_ATTACK_SWING"
}

Anims.Female[ "grenade" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_COVER_PISTOL_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_CROUCH"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_IDLE_ANGRY_PISTOL",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_WALK_PACKAGE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/alyxanimtree.mdl;ACT_RUN"
    },
		["fire"] = "ACT_MELEE_ATTACK_SWING"
}


Anims.Female[ "slam" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_IDLE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_SUITCASE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RUN",
    [ "crouch" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_COVER_LOW",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_CROUCH",
    [ "aimidle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RANGE_AIM_SMG1_LOW",
    [ "aimwalk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_CROUCH_RPG"
    },
    [ "aim" ] = {
    [ "idle" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_IDLE_PACKAGE",
    [ "walk" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_WALK_PACKAGE",
    [ "run" ] = "&switch:models/Tiramisu/AnimationTrees/femaleanimtree.mdl;ACT_RUN"
    },
		["fire"] = "ACT_PICKUP_RACK"
}

--local cachetable = {}
local function FindEnumeration( actname ) --Finds the enumeration number based on it's name.

	--if cachetable[actname] then return cachetable[actname] end

	for k, v in pairs ( _E ) do
		if(  k == actname ) then
			--cachetable[actname] = v
			return tonumber( v );
		end
	end
	
	return -1;

end

local function FindName( actnum ) --Finds the enumeration name based on it's number.
	for k, v in pairs ( _E ) do
		if(  v == actnum ) then
			return tostring( k );
		end
	end
	
	return "ACT_IDLE";
end	

local function HandleLuaAnimation( ply, animation )
	
	if CLIENT then
		if !ply.InLuaSequence then
			ply.InLuaSequence = true
			ply:SetLuaAnimation( animation )
		end
	end
	
end

function HandleSequence( ply, seq ) --Internal function to handle different sequence types.
	
	--print( seq )
	
	local exp
	local exp2
	local model
	local sequence
	local skeletonanim
	local gender
	local lastseq
	--print( ply:GetModel() )
	
	/*
	if ply.Sequence == seq then
		return FindEnumeration(lastseq)
	end*/
	
	if !ply.SpecialModel then
		ply.SpecialModel = ply:GetNWBool( "specialmodel", false )
	end
	

	if !ply.Sequence then
		ply.Sequence = "none"
	end
	
	--if ply.Sequence != seq then
		--print(ply.Sequence .. "GEGSJ")
		if string.match( seq, "&" ) then
			ply.Sequence = seq
			if string.match( seq, "sequence" ) then
				exp = string.Explode( ";", string.gsub( seq, "&", "" ) )
				exp2 = string.Explode( ":", exp[1] )
				model = exp2[2]
				if !model then
					model = "models/Gustavio/" .. string.lower( ply:GetGender() ) .. "animtree.mdl"
				end
				if( ply:GetModel() != model and !ply.SpecialModel ) then
					--print( "Changing model to " .. model )
					ply:SetModel( model )
				end
				timer.Simple( 0, function()
					if string.match( exp2[2], "g_" ) or string.match( exp2[2], "gesture" ) then
						ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence( string.gsub( exp2[2], ";", "" ) ) )
					else
						ply:SetSequence( ply:LookupSequence( string.gsub( exp2[2], ";", "" ) ) )
					end
				end)
				return ply:LookupSequence( string.gsub( exp2[2], ";", "" ) )
			elseif string.match( seq, "number" ) then
				exp = string.Explode( ":", string.gsub( seq, "&", "" ) )
				return tonumber( FindName(exp[2]) )
			end
			
			if string.match( seq, "lua" ) then
				exp = string.Explode( ";", string.gsub( seq, "&", "" ) )
				exp2 = string.Explode( ":", exp[1] )
				sequence = exp2[2]
				skeletonanim = exp[2] or "ACT_DIERAGDOLL"
				HandleLuaAnimation( ply, sequence )
				return FindEnumeration( skeletonanim )
			else
				if ply.InLuaSequence then
					if CLIENT then
						ply:StopAllLuaAnimations()
					end
					ply.InLuaSequence = false
				end
			end
			
			if string.match( seq, "switch" ) then --Internal handler used to switch skeletons.
				exp = string.Explode( ";", string.gsub( seq, "&", "" ) )
				exp2 = string.Explode( ":", exp[1] )
				model = exp2[2]
				seq = exp[2]
				if( ply:GetModel() != string.lower(model) and !ply.SpecialModel and ply:GetNWBool( "charloaded", false )) then
					ply:SetModel( model )
				end
				return FindEnumeration( seq )
			end
		end
	--end

	--print( tostring( FindEnumeration( seq ) ) )
	--print(seq)
	return FindEnumeration( seq )
	
end

local shotgunholdtypes = {
	"shotgun"
}

local meleeholdtypes = {
	"passive",
	"knife",
	"melee2",
	"melee" 
}
		
local function DetectHoldType( act ) --This is just a function used to group up similar holdtype for them to use the same sequences, since NPC animations are kinda limited.
	--You can add or remove to this list as you see fit, if you feel like creating a different holdtype.
	
	if string.match(  act, "pistol" ) then
		return "pistol"
	end
	for k, v in pairs( shotgunholdtypes ) do
		if string.match( act, v ) then
			return "shotgun"
		end
	end
	for k, v in pairs( meleeholdtypes ) do
		if string.match( act, v ) then
			return "melee"
		end
	end
	if string.match(  act, "ar2" ) then
		return "ar2"
	end
	if string.match(  act, "smg" ) then
		return "smg"
	end
	if string.match(  act, "rpg" ) then
		return "rpg"
	end
	if string.match(  act, "grenade" ) then
		return "grenade"
	end
	if string.match(  act, "slam" ) then
		return "slam"
	end
	return "default"
	
end

function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed ) -- This handles everything about how sequences run, the framerate, boneparameters, everything.
	
	local eye
	local estyaw
	local myaw
	local len2d
	local rate
	eye = ply:EyeAngles()
	if !ply:GetNWBool( "sittingchair", false ) then
		ply:SetLocalAngles( eye )
		ply:SetEyeTarget( ply:EyePos( ) )
	end

	if CLIENT then
		if !ply:GetNWBool( "sittingchair", false ) then
			ply:SetRenderAngles( eye )
		end
	end
	
	estyaw = math.Clamp( math.atan2(velocity.y, velocity.x) * 180 / 3.141592, -180, 180 )
	myaw = math.NormalizeAngle(math.NormalizeAngle(eye.y) - estyaw)

	if !ply:GetNWBool( "sittingchair", false ) then
		ply:SetPoseParameter("move_yaw", myaw * -1 )
	else
		ply:SetPoseParameter("move_yaw", 0 )
	end
	--This set of boneparameters are all set to 0 to avoid having the engine setting them to something else, thus resulting in  awkwardly twisted models
	ply:SetPoseParameter("aim_yaw", 0 )
	ply:SetPoseParameter("body_yaw", 0 )
	ply:SetPoseParameter("spine_yaw", 0 )
	ply:SetPoseParameter("head_roll", 0 )
	
	len2d = velocity:Length2D() --Velocity in the x and y axis
	rate = 1.0
	
	if len2d > 0.5 then
			rate =  ( ( len2d * 0.8 ) / maxseqgroundspeed )
	end
	
	rate = math.Clamp(rate, 0, 1.5)	
	ply:SetPlaybackRate( rate )
	
end

function GM:HandlePlayerJumping( ply ) --Handles jumping

    local holdtype
    --If we're not on the ground, then play the gliding animation.
    if !ply.Jumping and !ply:OnGround() and !ply:GetNWBool( "sittingchair", false ) then
    ply.Jumping = true
    ply.FirstJumpFrame = false
    ply.JumpStartTime = CurTime()
    end
    
    if ply.Jumping then
    if ply.FirstJumpFrame then
        ply.FirstJumpFrame = false
        ply:AnimRestartMainSequence()
    end
    
    if ply:WaterLevel() >= 2 then
        ply.Jumping = false
        ply:AnimRestartMainSequence()
				end
				
    if (CurTime() - ply.JumpStartTime) > 0.4 then --If we have been on the air for more than 0.4 seconds, then we're meant to play the land animation.
        if ply:OnGround() and !ply.Landing and ply:GetMoveType() == MOVETYPE_WALK then
							ply.Landing = true
							timer.Simple( 0.3, function()
									ply.Landing = false
									ply.Jumping = false
							end)
						return true
        end
				else
					if ply:OnGround() and !ply.Landing then
						ply.Jumping = false
        ply:AnimRestartMainSequence()
					end
    end
    
    if ply.Jumping then --If we're still on a part of the jumping sequence, that means we're either on the process of jumping or landing.
		      if !ply.Landing then 
        ply.CalcIdeal = ACT_JUMP
		      else
						ply.CalcIdeal = ACT_LAND
			end
    return true
    end
    end
    
    return false
end
 
function GM:HandlePlayerDucking( ply, velocity ) --Handles crouching

		local holdtype = "default"
		if( ValidEntity(  ply:GetActiveWeapon() ) ) then
			holdtype = DetectHoldType( ply:GetActiveWeapon():GetHoldType() ) 
		end
    if ply:Crouching() then
			if ply:GetNWBool( "aiming", false ) then
    len2d = velocity:Length2D() -- the velocity on the x and y axis.
    if len2d > 0.5 then
    ply.CalcIdeal =  HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "crouch" ][ "aimwalk" ] )
    else
    ply.CalcIdeal =  HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype][ "crouch" ][ "aimidle" ] )
    end
			else
				len2d = velocity:Length2D()
    
    if len2d > 0.5 then
						ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "crouch" ][ "walk" ] )
    else
        ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "crouch" ][ "idle" ] )
    end
			end
			return true
    end
    
    return false
end
 
function GM:HandlePlayerSwimming( ply ) --Handles swimming.

    if ply:WaterLevel() >= 2 then
				ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ "default" ][ "swim" ] )
				return true
		end
    
    return false
end

function GM:HandlePlayerDriving( ply ) --Handles sequences while in vehicles.

	local vehicle
	local class
 
    if ply:InVehicle() then
    vehicle = ply:GetVehicle()
    class = vehicle:GetClass()
	if ( class == "prop_vehicle_prisoner_pod" and vehicle:GetModel() == "models/vehicles/prisoner_pod_inner.mdl" ) then
			ply.CalcIdeal = HandleSequence( ply, "ACT_IDLE" )
    else
			ply.CalcIdeal = HandleSequence( ply, "&switch:models/Tiramisu/AnimationTrees/playeranimtree.mdl;ACT_DRIVE_JEEP" )
    end

    return true
		end
end

function GM:HandleExtraActivities( ply ) --Drop in here everything additional you need checks for.

	--Use this hook for all the other sequenced activities you may wanna add, like uh, flying I guess.

		if ply:GetNWBool( "sittingchair", false ) then
			if !ply.IsSittingDamn then
				ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ "default" ][ "sitentry" ]  )
				timer.Simple( 1.5, function()
					ply.IsSittingDamn = true
				end)
				return true
			else
				ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ "default" ][ "sit" ]  )
				return true
			end
		else
			if ply.IsSittingDamn then
				ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ "default" ][ "sitexit" ]  )
				timer.Simple( 0.8, function()
					ply.IsSittingDamn = false
				end)
				return true
			end
		end
		
		if ply:GetNWBool( "sittingground", false ) then
			if !ply.IsSittingGround then
				ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ "default" ][ "sitgroundentry" ]  )
				timer.Simple( 1.7, function()
					ply.IsSittingGround = true
				end)
				return true
			else
				ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ "default" ][ "sitground" ]  )
				return true
			end
		else
			if ply.IsSittingGround then
				ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ "default" ][ "sitgroundexit" ]  )
				timer.Simple( 1.2, function()
					ply.IsSittingGround = false
				end)
				return true
			end
		end
    
    return false

end

function GM:CalcMainActivity( ply, velocity )
		--This is the hook used to handle sequences, if you need to add additional activities you should check the hook above.
		--By a general rule you don't have to touch this hook at all.
		local holdtype = "default"
		if( ValidEntity(  ply:GetActiveWeapon() ) ) then
			holdtype = DetectHoldType( ply:GetActiveWeapon():GetHoldType() ) 
		end
    ply.CalcIdeal = ACT_IDLE
    ply.CalcSeqOverride = -1
    
    if self:HandleExtraActivities( ply ) or self:HandlePlayerDriving( ply ) or
    self:HandlePlayerJumping( ply ) or
    self:HandlePlayerDucking( ply, velocity ) or
    self:HandlePlayerSwimming( ply ) 
		then
			--We do nothing, I guess, lol.
		else
    len2d = velocity:Length2D()
				
			if ply:GetNWBool( "aiming", false ) then
				if len2d > 135 then
					ply.CalcIdeal =  HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "run" ] )
				elseif len2d > 0.1 then
					ply.CalcIdeal =  HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "aim" ][ "walk" ] )
				else
					ply.CalcIdeal  = HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "aim" ][ "idle" ] )
				end
			else
				if len2d > 135 then
					ply.CalcIdeal =  HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "run" ] )
            if SERVER then
            ply:SetAiming( false )
            end
				elseif len2d > 0.1 then
					ply.CalcIdeal =  HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "walk" ] )
				else
					ply.CalcIdeal =  HandleSequence( ply, Anims[ ply:GetGender() ][  holdtype ][ "idle" ] )
				end
			end
    end
		
		--print( tostring( ply.CalcIdeal ) )
		
    return ply.CalcIdeal, ply.CalcSeqOverride
end		
    
function GM:TranslateActivity( ply, act )
		
		--We're not translating through the weapon, thus, this hook isn't used.
		return act
		
end
 
function GM:DoAnimationEvent( ply, event, data ) -- This is for gestures.

		holdtype = "default"
		if( ValidEntity(  ply:GetActiveWeapon() ) ) then
			holdtype = DetectHoldType( ply:GetActiveWeapon():GetHoldType() ) 
		end

    if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
				if Anims[ ply:GetGender() ][ holdtype ][ "fire" ] then
					if !string.match( Anims[ ply:GetGender() ][ holdtype ][ "fire" ], "&lua" ) then
						if( string.match( Anims[ ply:GetGender() ][ holdtype ][ "fire" ], "GESTURE" ) ) then
								ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, FindEnumeration(  Anims[ ply:GetGender() ][ holdtype ][ "fire" ] ) ) -- Not a sequence, so I don't use HandleSequence here.
						else
							ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "fire" ] )
						end
					else
						exp = string.Explode( ";", string.gsub( Anims[ ply:GetGender() ][ holdtype ][ "fire" ], "&", "" ) )
						exp2 = string.Explode( ":", exp[1] )
						sequence = exp2[2]
						if CLIENT then
							ply:SetLuaAnimation( sequence )
						end
					end
				else
						ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GESTURE_RANGE_ATTACK_SMG1 )
				end

    return ACT_VM_PRIMARYATTACK
    
    elseif event == PLAYERANIMEVENT_RELOAD then
				if Anims[ ply:GetGender() ][ holdtype ][ "reload" ] then
						if( string.match( Anims[ ply:GetGender() ][ holdtype ][ "reload" ], "GESTURE" ) ) then
								ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, FindEnumeration(  Anims[ ply:GetGender() ][ holdtype ][ "reload" ] ) )
						else
							--ply.CalcIdeal = HandleSequence( ply, Anims[ ply:GetGender() ][ holdtype ][ "reload" ] )
						end	
				else
        ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GESTURE_RELOAD_SMG1 )
				end
    
    return ACT_INVALID
		elseif event == PLAYERANIMEVENT_CANCEL_RELOAD then
    
    ply:AnimResetGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD )
    
    return ACT_INVALID
    end
    
    if event == PLAYERANIMEVENT_JUMP then
    
    ply.Jumping = true
    ply.FirstJumpFrame = true
    ply.JumpStartTime = CurTime()
    
    ply:AnimRestartMainSequence()
    
    return ACT_INVALID
    
		end
 
    return nil
end