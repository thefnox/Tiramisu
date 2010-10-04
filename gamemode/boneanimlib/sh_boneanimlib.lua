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

RegisterLuaAnimation('punchstance', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -131,
					RR = 18,
					RF = 47
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 8,
					RR = -5,
					RF = -27
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -35,
					RR = 15
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = 19
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RF = -23
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -114,
					RR = 50,
					RF = 70
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -2,
					RR = -11,
					RF = 9
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -19
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RR = 30
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 29
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -14,
					RR = 13,
					RF = 39
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -131,
					RR = 18,
					RF = 47
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 8,
					RR = -5,
					RF = -27
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -35,
					RR = 15
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = 19
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RF = -23
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -114,
					RR = 50,
					RF = 70
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -2,
					RR = -11,
					RF = 9
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 29
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RR = 30
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -19
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -14,
					RR = 13,
					RF = 39
				}
			},
			FrameRate = 10
		}
	},
	RestartFrame = 2,
	StartFrame = 1,
	Type = TYPE_SEQUENCE
})

RegisterLuaAnimation('punchanim', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Neck1'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -131,
					RR = 18,
					RF = 47
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 8,
					RR = -5,
					RF = -27
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -35,
					RR = 15
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = 19
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RF = -23
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -19
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_Spine1'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RR = 30
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 29
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -2,
					RR = -11,
					RF = 9
				},
				['ValveBiped.Bip01_Spine'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -114,
					RR = 50,
					RF = 70
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -14,
					RR = 13,
					RF = 39
				}
			},
			FrameRate = 60
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Neck1'] = {
					RF = -1
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 2,
					RR = -9,
					RF = 47
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RR = -14,
					RF = -1
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 8,
					RR = -1,
					RF = 12
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -35,
					RR = 49,
					RF = 98
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = -1
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 3,
					RF = -9
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 29
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -5
				},
				['ValveBiped.Bip01_Spine1'] = {
					RF = -35
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RR = -9
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -73,
					RR = -19
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -2,
					RR = -11,
					RF = 9
				},
				['ValveBiped.Bip01_Spine'] = {
					RF = -20
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -58,
					RR = 6,
					RF = -18
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -14,
					RR = 13,
					RF = 39
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Neck1'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -131,
					RR = 18,
					RF = 47
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 8,
					RR = -5,
					RF = -27
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -35,
					RR = 15
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = 19
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RF = -23
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -114,
					RR = 50,
					RF = 70
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -26
				},
				['ValveBiped.Bip01_Spine1'] = {
				},
				['ValveBiped.Bip01_Spine'] = {
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -2,
					RR = -11,
					RF = 9
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 29
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RR = 30
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -19
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -14,
					RR = 13,
					RF = 39
				}
			},
			FrameRate = 1.5
		}
	},
	RestartFrame = 2,
	StartFrame = 1,
	Type = TYPE_SEQUENCE
})

RegisterLuaAnimation('boxstance', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -100,
					RR = -35
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -58,
					RR = 7,
					RF = 10
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = -7,
					RF = -9
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = -7
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RR = -9,
					RF = -5
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 14
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -7
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -100,
					RR = 7
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 11,
					RF = -6
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RF = 6
				},
				['ValveBiped.Bip01_Spine'] = {
					RU = 12
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -58,
					RR = 7,
					RF = 10
				},
				['ValveBiped.Bip01_Spine1'] = {
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -14,
					RR = 6,
					RF = 10
				}
			},
			FrameRate = 30
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = 13,
					RF = 1
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -58,
					RR = 7,
					RF = 10
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RR = -9,
					RF = -5
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = -7
				},
				['ValveBiped.Bip01_Spine1'] = {
					RU = -4
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -100,
					RR = -35
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -7
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -100,
					RR = 7
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 11,
					RF = -6
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RF = 6
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = -7,
					RF = -9
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -58,
					RR = 7,
					RF = 10
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 14
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -14,
					RR = 6,
					RF = 10
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -100,
					RR = -35
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -58,
					RR = 7,
					RF = 10
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RR = -9,
					RF = -5
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = -7
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -100,
					RR = 7
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 14
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -7
				},
				['ValveBiped.Bip01_Spine1'] = {
					RU = -2
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 11,
					RF = -6
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RF = 6
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -58,
					RR = 7,
					RF = 10
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = -7,
					RF = -9
				},
				['ValveBiped.Bip01_Spine'] = {
					RU = 14,
					RF = 1
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -14,
					RR = 6,
					RF = 10
				}
			},
			FrameRate = 1
		}
	},
	RestartFrame = 2,
	StartFrame = 1,
	Type = TYPE_SEQUENCE
})

RegisterLuaAnimation('punchgesture', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				},
				['ValveBiped.Bip01_Spine1'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -91,
					RR = 14,
					RF = 9
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 136,
					RR = 29
				},
				['ValveBiped.Bip01_Spine1'] = {
					RF = -23
				}
			},
			FrameRate = 5
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				},
				['ValveBiped.Bip01_Spine1'] = {
				}
			},
			FrameRate = 5
		}
	},
	Type = TYPE_GESTURE
})
RegisterLuaAnimation('swimidle', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -40,
					RR = 10
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RR = 38,
					RF = 26
				},
				['ValveBiped.Bip01_Head1'] = {
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -40,
					RR = -10
				},
				['ValveBiped.Bip01_L_Calf'] = {
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -38,
					RF = -26
				},
				['ValveBiped.Bip01_L_Thigh'] = {
				},
				['ValveBiped.Bip01_R_Calf'] = {
				},
				['ValveBiped.Bip01_R_Thigh'] = {
				}
			},
			FrameRate = 60
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -33,
					RR = 10
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -9,
					RR = 38,
					RF = 26
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 7
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -33,
					RR = -10
				},
				['ValveBiped.Bip01_L_Calf'] = {
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_R_Calf'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -9,
					RR = -38,
					RF = -26
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -13
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = 18
				}
			},
			FrameRate = 3
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -22,
					RR = 10
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RR = 38,
					RF = 26
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 4
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -38,
					RF = -26
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -22,
					RR = -10
				},
				['ValveBiped.Bip01_L_Calf'] = {
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 27
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_L_Thigh'] = {
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -7
				}
			},
			FrameRate = 3
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_Calf'] = {
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = 9,
					RR = 38,
					RF = 26
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 2
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 9,
					RR = -38,
					RF = -26
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -10,
					RR = -10
				},
				['ValveBiped.Bip01_L_Calf'] = {
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -10,
					RR = 10
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = 13
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -18
				}
			},
			FrameRate = 3
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_Calf'] = {
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RR = 38,
					RF = 26
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 4
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -38,
					RF = -26
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -22,
					RR = -10
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 27
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -22,
					RR = 10
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -7
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_R_Thigh'] = {
				}
			},
			FrameRate = 3
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -33,
					RR = 10
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -9,
					RR = 38,
					RF = 26
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 7
				},
				['ValveBiped.Bip01_L_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 8
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -33,
					RR = -10
				},
				['ValveBiped.Bip01_L_Calf'] = {
				},
				['ValveBiped.Bip01_R_Foot'] = {
					RU = 37
				},
				['ValveBiped.Bip01_R_Calf'] = {
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -13
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -9,
					RR = -38,
					RF = -26
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = 18
				}
			},
			FrameRate = 60
		}
	},
	RestartFrame = 2,
	StartFrame = 1,
	Type = TYPE_SEQUENCE
})
