include('shared.lua')

local lolpos

function ENT:Draw()

	if CAKE.ForceDraw then
			self.Entity:DrawModel()
	end

	if self.Entity:GetParent() == LocalPlayer() then
		if !CAKE.Thirdperson:GetBool() and !CAKE.MiddleDown then
			if !gamemode.Call( "ShouldDrawLocalPlayer" ) then
				return
			end
		end
	end


	self.Entity:DrawShadow( true )
	
end

local function BoneScale( self, realboneid, scale )

	local matBone = self:GetBoneMatrix( realboneid )
	if matBone then
		matBone:Scale( Vector( scale, scale, scale ) )
		self:SetBoneMatrix( realboneid, matBone )
	end

end

function SolveIKForArm( self, laterality )

	local shoulderid = self:LookupBone( "ValveBiped.Bip01_" .. laterality .. "_UpperArm" ) 
	local shoulderpos, shoulderang = self:GetBonePosition( shoulderid )
	local elbowid = self:LookupBone( "ValveBiped.Bip01_" .. laterality .. "_Forearm" )
	local elbowpos, elbowang = self:GetBonePosition( elbowid )
	local uparmlength = 11.5
	local armlength = uparmlength * 2

	local wristnormal = self.Entity:GetParent():GetAimVector():Normalize()
	local wristdest = wristnormal * armlength
	local targetang = self.Entity:GetParent():GetAimVector():Angle()

	self:SetBonePosition( shoulderid, shoulderpos, targetang )
	self:SetBonePosition( elbowid, elbowpos, targetang )
	/*
	if shoulderpos:Distance(wristdest) >= armlength then -- We don't even need to bend the arm!
		-- just return some simple values :)
		local wristnormal = wristdest:Normalize()
		local wristdest = wristnormal * armlength
		local shoulderang = wristdest:Normalize():Angle()
		local elbowpos = wristnormal * uparmlength
		return shoulderang, shoulderang
	end



	if shoulderpos:Distance(wristdest) >= uparmlength then
		--What we're doing here is assuming that the length of the arm and the forearm are the same. The end result will be off by a couple of inches but it makes the entire equation so easy to solve.
		local height = Vector(0, 0, 0):Distance(wristdest) - armlength
		--The end result 
		local destinationangle = math.asin( height / uparmlength ) * -1
		shoulderang:RotateAroundAxis( shoulderang:Up(), destinationangle )
		elbowang:RotateAroundAxis( elbowang:Up(), destinationangle * -1 )

	end
	*/

end

local body = {
	"ValveBiped.Bip01_Head1",
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
	"ValveBiped.Bip01_R_Hand",

}

local gloves = {
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

local head = {
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
local bodyaddup = {
}
local headaddup = {
	["ValveBiped.Bip01_Head1"] = 3
}
/*---------------------------------------------------------
   Name: BuildBonePositions
   Desc:
---------------------------------------------------------*/
function ENT:BuildBonePositions( NumBones, NumPhysBones )

	local tbl = {}
	local bodyinflate = {}
	local headinflate = {}
	local index = 0
	local inverse = false
	local exceptions = {}
	if self.Entity:GetDTInt( 1 ) == 0 then
		inverse = true
	elseif self.Entity:GetDTInt( 1 ) == 1 then
		exceptions = body
		inverse = true
	elseif self.Entity:GetDTInt( 1 ) == 2 then
		exceptions = head
	elseif self.Entity:GetDTInt( 1 ) == 3 then
		exceptions = gloves
	elseif self.Entity:GetDTInt( 1 ) == 4 then
		exceptions = gloves
		inverse = true
	elseif self.Entity:GetDTInt( 1 ) == 5 then
		exceptions = head
		inverse = true
	end
	for k, v in pairs( exceptions ) do
		index = self.Entity:LookupBone( v )
		if index != 0 then
			table.insert( tbl, index )
		end
	end
	for k, v in pairs( bodyaddup ) do
		index = self.Entity:LookupBone( k )
		if index != 0 then
			bodyinflate[ k ] = index
		end
	end
	for k, v in pairs( headaddup ) do
		index = self.Entity:LookupBone( k )
		if index != 0 then
			headinflate[ k ] = index
		end
	end
	
	for i=0, NumBones do
		if inverse then
			if ( table.HasValue( tbl, i ) ) then
				BoneScale( self, i, 0.01 )
			end
			if ( table.HasValue( bodyinflate, i ) ) then
				for k, v in pairs( bodyinflate ) do
					if i == v then
						--BoneScale( self, i, bodyaddup[ k ]  )
						break
					end
				end
			end
		else
			if ( !table.HasValue( tbl, i, 0 ) ) then
				BoneScale( self, i, 0.01 )
			end
			if ( table.HasValue( headinflate, i ) ) then
				for k, v in pairs( headinflate ) do
					if i == v then
						BoneScale( self, i, self.Entity:GetDTInt( headaddup[ k ] ) )
						break
					end
				end
			end
		end
	end

	--SolveIKForArm( self, "R" )

end

