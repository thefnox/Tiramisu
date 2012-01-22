include('shared.lua')

ENT.HeadBonesIndex = {}
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

local parent
function ENT:Draw()

	parent = self.Entity:GetDTEntity( 1 )

	if ValidEntity( parent) then
		if !self.HeadBonesIndex[ parent:GetModel() ] then
			self.HeadBonesIndex[ parent:GetModel() ] = {}
			for _,bone in pairs(self.HeadBones) do
				index = parent:LookupBone(bone)
				if index then
					table.insert(self.HeadBonesIndex[ parent:GetModel() ], index)
				end
			end
		end

		local position, angles = self.Entity:GetDTEntity( 1 ):GetBonePosition(self.Entity:GetDTInt(1))
		local newposition, newangles = LocalToWorld( self.Entity:GetDTVector(1), self.Entity:GetDTAngle(1), position, angles )
		self.Entity:SetPos(newposition)
		self.Entity:SetAngles(newangles)
		self.Entity:SetModelScale( self.Entity:GetDTVector(2) )
	end

	if !self.Entity:GetDTInt(1) or !parent then
		--no shirt, no pants, no service
		return
	end

	if !self.Entity:GetDTBool(1) then
		--If it is not meant to be drawn, don't draw it.
		return
	end

	--If it is attached to a head bone then hide it when the body is visible in first person
	if self.HeadBonesIndex and parent == LocalPlayer() and !parent:InVehicle() and !(CAKE.Thirdperson:GetBool() and CAKE.ThirdpersonDistance:GetInt() != 0 ) and !CAKE.FreeScroll and !CAKE.ForceDraw and CAKE.FirstpersonBody:GetBool() and table.HasValue(self.HeadBonesIndex, self.Entity:GetDTInt(1)) then
		return
	end

	--If the body ain't visible neither should the gear item be.
	if (parent == LocalPlayer() or self.Entity:GetParent() == LocalPlayer()) and !hook.Call("ShouldDrawLocalPlayer", GAMEMODE) then
		return
	end

	self.Entity:DrawModel()
	self.Entity:DrawShadow( false )
	
end

/*

function ENT:Think()
	if ValidEntity( self.Entity:GetParent() ) and ValidEntity( self.Entity:GetDTEntity( 1 ) ) then
		local position, angles = self.Entity:GetDTEntity( 1 ):GetBonePosition(self.Entity:GetDTInt(1))
		local newposition, newangles = LocalToWorld( self.Entity:GetDTVector(1), self.Entity:GetDTAngle(1), position, angles )
		self.Entity:SetPos(newposition)
		self.Entity:SetAngles(newangles)
		self.Entity:SetModelScale( self.Entity:GetDTVector(2) )
	end
end*/



