ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""

ENT.AutomaticFrameAdvance = true

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

CLOTHING_FULL = 0
CLOTHING_BODY = 1
CLOTHING_HEAD = 2
CLOTHING_HANDS = 3
CLOTHING_HEADANDBODY = 4
CLOTHING_BODYANDHANDS = 5
CLOTHING_HEADANDHANDS = 6

--Enums for the DTVars, they are the same than the DTVar unique ID
CLOTHING_TYPE = 1
CLOTHING_PARENTINDEX = 2 --The entity index of the parent.
CLOTHING_HEADRATIO = 1 
CLOTHING_BODYRATIO = 2
CLOTHING_HANDRATIO = 3

ENT.HandBones = { --All of the bones that could possibly exist in a player's hand.
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Finger0",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger4",
	"ValveBiped.Bip01_L_Finger01",
	"ValveBiped.Bip01_L_Finger02",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_L_Finger41",
	"ValveBiped.Bip01_L_Finger42",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Finger0",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger4",
	"ValveBiped.Bip01_R_Finger01",
	"ValveBiped.Bip01_R_Finger02",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32",
	"ValveBiped.Bip01_R_Finger41",
	"ValveBiped.Bip01_R_Finger42",
	"ValveBiped.Bip01_R_Hand"
}

ENT.HeadBones = { --All of the bones related to the head.
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_Neck1",
	"Bip01_ponytail",
	"Bip01_ponytail1",
	"Bip01_ponytail2",
	"Bip01_ponytail3",
	"Bip01_ponytail4",
	"HairN",
	"LMomi01N",
	"LMomi02N",
	"Ponytail01N",
	"Ponytail02N",
	"Ponytail03N",
	"RMomi01N",
	"RMomi02N",
	"ValveBiped.Bip01_hair10",
	"ValveBiped.Bip01_hair20",
	"ValveBiped.Bip01_hair30",
	"ValveBiped.Bip01_hair40",
	"ValveBiped.Bip01_hair1",
	"ValveBiped.Bip01_hair2",
	"ValveBiped.Bip01_hair3",
	"ValveBiped.Bip01_hair4",
	"ValveBiped.Bip01_hair5",
	"ValveBiped.Bip01_hair6",
	"ValveBiped.Bip01_hair7",
	"ValveBiped.Bip01_hair8",
	"ValveBiped.Bip01_hair9",
	"ValveBiped.Bip01_hair11",
	"ValveBiped.Bip01_hair12",
	"ValveBiped.Bip01_hair13",
	"ValveBiped.Bip01_hair14",
	"ValveBiped.Bip01_hair15",
	"ValveBiped.Bip01_hair16",
	"ValveBiped.Bip01_hair17",
	"ValveBiped.Bip01_hair18",
	"ValveBiped.Bip01_hair19",
	"ValveBiped.Bip01_hair21",
	"ValveBiped.Bip01_hair22",
	"ValveBiped.Bip01_hair23",
	"ValveBiped.Bip01_hair24",
	"ValveBiped.Bip01_hair25",
	"ValveBiped.Bip01_hair26",
	"ValveBiped.Bip01_hair27",
	"ValveBiped.Bip01_hair28",
	"ValveBiped.Bip01_hair29",
	"ValveBiped.Bip01_hair31",
	"ValveBiped.Bip01_hair32",
	"ValveBiped.Bip01_hair33",
	"ValveBiped.Bip01_hair34",
	"ValveBiped.Bip01_hair35",
	"ValveBiped.Bip01_hair36",
	"ValveBiped.Bip01_hair37",
	"ValveBiped.Bip01_hair38",
	"ValveBiped.Bip01_hair39",
	"ValveBiped.Bip01_hair41",
	"ValveBiped.Bip01_hair42",
	"ValveBiped.Bip01_hair43",
	"ValveBiped.Bip01_hair44",
	"ValveBiped.Bip01_hair45",
	"Head",
	"headBase",
	"brow_Left",
	"brow_right",
	"eyeBlink_Right",
	"outBrow_left",
	"outBrow_Right",
	"underEye_left",
	"underEye_Right",
	"mouthBase",
	"cheek_Left",
	"cheek_right",
	"innerUpperLip_Left",
	"upperLip_Left",
	"innerUpperLip_right",
	"upperLip_right",
	"jawBone",
	"innerLowLip_right",
	"lowerLip_right",
	"innerLowLip_left",
	"lowerLip_Left",
	"LowerCheek_left",
	"lowerCheek_right",
	"Tongue",
	"outerUpperLip_left",
	"LipCorner_Left",
	"outerUpperLip_right",
	"LipCorner_right",
	"Eye_Right",
	"Eye_Left",
	"lowLid_Right",
	"eyeBlink_Left",
	"lowLid_Left",
	"Sneer",
	"Neck",
	"Neck1"
	
}

function ENT:SetupDataTables()
	self:DTVar("Int", 1, "type")
	self:DTVar("Int", 2, "index" )
	self:DTVar("Float", 1, "headratio" )
	self:DTVar("Float", 2, "bodyratio" )
	self:DTVar("Float", 3, "handratio" )
end

function ENT:PhysicsCollide()

end

function ENT:Think()

end