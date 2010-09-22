--[[

Bone Animations Library
Created by William "JetBoom" Moodhe (jetboom@yahoo.com / www.noxiousnet.com)
Because I wanted custom, dynamic animations.
Give credit or reference if used in your creations.

]]

TYPE_GESTURE = 0 -- Gestures are keyframed animations that use the current position and angles of the bones. They play once and then stop automatically.
TYPE_POSTURE = 1 -- Postures are static animations that use the current position and angles of the bones. They stay that way until manually stopped. Use TimeToArrive if you want to have a posture lerp.
TYPE_STANCE = 2 -- Stances are keyframed animations that use the current position and angles of the bones. They play forever until manually stopped. Use RestartFrame to specify a frame to go to if the animation ends (instead of frame 1).
TYPE_SEQUENCE = 3 -- Sequences are keyframed animations that use the reference pose. They play forever until manually stopped. Use RestartFrame to specify a frame to go to if the animation ends (instead of frame 1).
-- You can also use StartFrame to specify a starting frame for the first loop.

local Animations = {}

function GetLuaAnimations()
	return Animations
end

function RegisterLuaAnimation(sName, tInfo)
	if tInfo.FrameData then
		local BonesUsed = {}
		for iFrame, tFrame in ipairs(tInfo.FrameData) do
			for iBoneID, tBoneTable in pairs(tFrame.BoneInfo) do
				BonesUsed[iBoneID] = (BonesUsed[iBoneID] or 0) + 1
				tBoneTable.MU = tBoneTable.MU or 0
				tBoneTable.MF = tBoneTable.MF or 0
				tBoneTable.MR = tBoneTable.MR or 0
				tBoneTable.RU = tBoneTable.RU or 0
				tBoneTable.RF = tBoneTable.RF or 0
				tBoneTable.RR = tBoneTable.RR or 0
			end
		end

		if #tInfo.FrameData > 1 then
			for iBoneUsed, iTimesUsed in pairs(BonesUsed) do
				for iFrame, tFrame in ipairs(tInfo.FrameData) do
					if not tFrame.BoneInfo[iBoneUsed] then
						tFrame.BoneInfo[iBoneUsed] = {MU = 0, MF = 0, MR = 0, RU = 0, RF = 0, RR = 0}
					end
				end
			end
		end
	end
	Animations[sName] = tInfo
end
RegisterLuaAnimation('aaaa2', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = 30,
					RR = 30
				},
				['ValveBiped.Bip01_Head1'] = {
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = -30,
					RR = -30
				},
				['ValveBiped.Bip01_Head1'] = {
					RF = 102
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Head1'] = {
					RF = -227
				},
				['ValveBiped.Bip01_Spine'] = {
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Head1'] = {
					RF = 128
				},
				['ValveBiped.Bip01_Spine'] = {
				}
			},
			FrameRate = 1
		}
	},
	RestartFrame = 1,
	Type = TYPE_STANCE
})
RegisterLuaAnimation('sleep', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RR = 128
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -10,
					RR = -17
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 4,
					RR = 20,
					RF = 24
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -56,
					RR = -4,
					RF = 8
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = 34
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -40
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -57,
					RR = -48,
					RF = -140
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -21
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -56,
					RR = -41,
					RF = -30
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 131,
					RF = 7
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RU = -21,
					MF = 26,
					MU = -15,
					RF = -90
				},
				['ValveBiped.Bip01_Spine'] = {
					RF = -8
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = 14
				},
				['ValveBiped.Bip01_Spine4'] = {
					RF = 17
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = 7,
					RR = -2
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RR = 128
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -10,
					RR = -17
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 4,
					RR = 20,
					RF = 24
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -40
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -57,
					RR = -48,
					RF = -140
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = 34
				},
				['ValveBiped.Bip01_Spine4'] = {
					RF = 17
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -21
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -56,
					RR = -41,
					RF = -30
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 131,
					RF = 7
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RU = -21,
					MF = 26,
					MU = -15,
					RF = -90
				},
				['ValveBiped.Bip01_Spine'] = {
					RF = -8
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = 14
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -56,
					RR = -4,
					RF = 8
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = 7,
					RR = -2
				}
			},
			FrameRate = 1
		}
	},
	RestartFrame = 2,
	Type = TYPE_SEQUENCE
})

RegisterLuaAnimation('punch', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -70,
					RR = 42
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RR = 13
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 13,
					RR = -19,
					RF = -38
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -35,
					RR = -13,
					RF = 18
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 17,
					RR = 8,
					RF = -2
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = -21,
					RR = 1,
					RF = -92
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RR = 52
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -33
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -120,
					RR = 51
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 58
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RU = 7,
					RR = 11,
					RF = 20
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 35,
					RR = 30,
					RF = 74
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 21
				},
				['ValveBiped.Bip01_L_Toe0'] = {
					RU = -58
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RR = 25,
					RF = 72
				}
			},
			FrameRate = 100
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -70,
					RR = 42
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RR = 13
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RR = 52
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -35,
					RR = -13,
					RF = 18
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 17,
					RR = 8,
					RF = -2
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = -21,
					RR = 1,
					RF = -92
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 13,
					RR = -19,
					RF = -38
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -33
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -120,
					RR = 51
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 58
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RU = 7,
					RR = 11,
					RF = 20
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 35,
					RR = 30,
					RF = 74
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 21
				},
				['ValveBiped.Bip01_L_Toe0'] = {
					RU = -58
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RR = 25,
					RF = 72
				}
			},
			FrameRate = 1
		}
	},
	RestartFrame = 2,
	Type = TYPE_SEQUENCE
})
/* EXAMPLES!

-- If your animation is only used on one model, use numbers instead of bone names (cache the lookup).
-- If it's being used on a wide array of models (including default player models) then you should use bone names.
-- You can use Callback as a function instead of MU, RR, etc. which will allow you to do some interesting things.
-- See cl_boneanimlib.lua for the full format.

STANCE: stancetest
A simple looping stance that stretches the model's spine up and down until stopped.

RegisterLuaAnimation("stancetest", {
	FrameData = {
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = 64
				}
			},
			FrameRate = 0.25
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = -32
				}
			},
			FrameRate = 1.5
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = 32
				}
			},
			FrameRate = 4
		}
	},
	RestartFrame = 2,
	Type = TYPE_STANCE
})

--[[
STANCE: staffholdspell
To be used with the ACT_HL2MP_IDLE_MELEE2 animation.
Player holds the staff so that their left hand is over the top of it.
]]

RegisterLuaAnimation("staffholdspell", {
	FrameData = {
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = 40,
					RF = -40
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = 40
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = -40
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = 40
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = -40
				}
			},
			FrameRate = 6
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = 2,
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = 1
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = -10
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = 8
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = -12
				}
			},
			FrameRate = 0.4
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = -2,
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = -1
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = 10
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = -8
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = 12
				}
			},
			FrameRate = 0.1
		}
	},
	RestartFrame = 2,
	Type = TYPE_STANCE,
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		local wepstatus = pl.WeaponStatus
		return wepstatus and wepstatus:IsValid() and wepstatus:GetSkin() == 1 and wepstatus.IsStaff
	end
})

*/
