include('shared.lua')

function ENT:BoneScale( realboneid, scale )
self:ManipulateBoneScale( realboneid, Vector( scale, scale, scale ) )
end

function ENT:Draw()

if self.Entity:GetParent() == LocalPlayer() and !hook.Call("ShouldDrawLocalPlayer", GAMEMODE) then
return
end

self.Entity:DrawModel()
self.Entity:DrawShadow( true )

local n = self:GetBoneCount()

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

if self.Entity:GetParent() == LocalPlayer() and ((!(CAKE.Thirdperson:GetBool() and CAKE.ThirdpersonDistance:GetInt() != 0 ) and !CAKE.FreeScroll and !CAKE.ForceDraw and CAKE.FirstpersonBody:GetBool()) or self.Entity:GetParent():InVehicle()) then
--First person, but with body visible
for i=0, n do
if table.HasValue(self.HeadBonesIndex, i) then --If they're part of the head
self:ManipulateBoneScale(i, Vector(0,0,0)) -- Scale them down so they don't get in the way.
end	
end

else

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

	end

end