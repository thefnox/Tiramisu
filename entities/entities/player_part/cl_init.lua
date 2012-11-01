include('shared.lua')

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

--From sanbox
local function ConvertRelativeToEyesAttachment( Entity, Pos )

	// Convert relative to eye attachment
	local eyeattachment = Entity:LookupAttachment( "eyes" )
	if ( eyeattachment == 0 ) then return end
	local attachment = Entity:GetAttachment( eyeattachment )
	if ( !attachment ) then return end

	local LocalPos, LocalAng = WorldToLocal( Pos, Angle(0,0,0), attachment.Pos, attachment.Ang )

	return LocalPos

end

function ENT:Draw()

	if self.Entity:GetParent() == LocalPlayer() and !hook.Call("ShouldDrawLocalPlayer", GAMEMODE) then
		return
	end
	
	self.Entity:DrawModel()
	self.Entity:DrawShadow( true )
	
end

function ENT:BoneScale( realboneid, scale )

	local matBone = self:GetBoneMatrix( realboneid )
	if matBone then
		matBone:Scale( Vector( scale, scale, scale ) )
		self:SetBoneMatrix( realboneid, matBone )
	end

end

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
local index
function ENT:BuildBonePositions( n, physbones )

	if !self.HeadBonesIndex then
		self.HeadBonesIndex = {}
		for _,bone in pairs(self.HeadBones) do
			index = self.Entity:LookupBone(bone)
			if index then
				table.insert(self.HeadBonesIndex, index)
			end
		end
	end

	if !self.HandBonesIndex then
		self.HandBonesIndex = {}
		for _,bone in pairs(self.HandBones) do
			index = self.Entity:LookupBone(bone)
			if index then
				table.insert(self.HandBonesIndex, index)
			end
		end
	end

	if self.Entity:GetDTInt( CLOTHING_TYPE ) == CLOTHING_FULL then --Don't do anything.
		for i=0, n do
			if table.HasValue(self.HeadBonesIndex, i) then --If they're part of the head
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_HEADRATIO)) --Scale to head ratio
			elseif table.HasValue(self.HandBonesIndex, i) then --If they're part of the hands
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_HANDRATIO)) --Scale to hand ratio
			else
				--Else they're part of the body.
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_BODYRATIO)) --Scale to body ratio
			end
		end
	elseif self.Entity:GetDTInt( CLOTHING_TYPE ) == CLOTHING_BODY then --Scale down hands and head
		for i=0, n do
			if table.HasValue(self.HeadBonesIndex, i) or table.HasValue(self.HandBonesIndex, i) then
				self:BoneScale(i,0) -- Scale them down if they're either hands or head bones.
			else
				--Else they're part of the body.
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_BODYRATIO)) --Scale to body ratio
			end
		end
	elseif self.Entity:GetDTInt( CLOTHING_TYPE ) == CLOTHING_HEAD then --Scale down everything but the head.
		for i=0, n do
			if !table.HasValue(self.HeadBonesIndex, i) then
				self:BoneScale(i,0) -- Scale them down if they're not part of the head
			else
				--They're part of the head.
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_HEADRATIO))--Scale them to the head
			end
		end
	elseif self.Entity:GetDTInt( CLOTHING_TYPE ) == CLOTHING_HANDS then --Keep just the hands
		for i=0, n do
			if !table.HasValue(self.HandBonesIndex, i) then
				self:BoneScale(i,0) -- Scale them down if they're not part of the hand
			else
				--They're part of the hand.
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_HANDRATIO)) --Scale to hand ratio
			end
		end
	elseif self.Entity:GetDTInt( CLOTHING_TYPE ) == CLOTHING_HEADANDBODY then --Keep everything but the hands.
		for i=0, n do
			if table.HasValue(self.HandBonesIndex, i) then
				self:BoneScale(i,0) -- Scale them down if they're part of the hands
			elseif table.HasValue(self.HeadBonesIndex, i) then
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_HEADRATIO))--Scale head bones to the head ratio
			else
				--If they're not part of head or hands, then they're part of the body.
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_BODYRATIO)) --Scale to body ratio
			end
		end
	elseif self.Entity:GetDTInt( CLOTHING_TYPE ) == CLOTHING_BODYANDHANDS then --Keep everything but the head
		for i=0, n do
			if table.HasValue(self.HeadBonesIndex, i) then
				self:BoneScale(i, 0) --Scale them down if they're part of the head.
			elseif table.HasValue(self.HandBonesIndex, i) then
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_HANDRATIO)) --Scale to hand ratio
			else
				--If they're not part of head or hands, then they're part of the body.
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_BODYRATIO)) --Scale to body ratio
			end
		end
	elseif self.Entity:GetDTInt( CLOTHING_TYPE ) == CLOTHING_HEADANDHANDS then --Keep everything but the body
		for i=0, n do
			if table.HasValue(self.HeadBonesIndex, i) then
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_HEADRATIO)) --Scale to head ratio
			elseif table.HasValue(self.HandBonesIndex, i) then
				self:BoneScale(i, self.Entity:GetDTFloat(CLOTHING_HANDRATIO)) --Scale to hand ratio
			else
				self:BoneScale(i, 0)
			end
		end
	end

	if self.Entity:GetParent() == LocalPlayer() and ((!(TIRA.Thirdperson:GetBool() and TIRA.ThirdpersonDistance:GetInt() != 0 ) and !TIRA.FreeScroll and !TIRA.ForceDraw and TIRA.FirstpersonBody:GetBool()) or self.Entity:GetParent():InVehicle()) then
		--First person, but with body visible
		for i=0, n do
			if table.HasValue(self.HeadBonesIndex, i) then --If they're part of the head
				self:BoneScale(i, 0) -- Scale them down so they don't get in the way.
			end		
		end
	end

end

