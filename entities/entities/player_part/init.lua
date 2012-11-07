AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self:AddEffects( bit.bor(bit.bor( EF_BONEMERGE, EF_BONEMERGE_FASTCULL ), EF_PARENT_ANIMATES ) )
	self:SetSolid(SOLID_NONE)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup( COLLISION_GROUP_PUSHAWAY )
	self:SetCollisionBounds( Vector(0, 0, 0), Vector(0, 0, 0) )
	local phy = self:GetPhysicsObject()
	if phy:IsValid() then
		phy:EnableCollisions(false)
		phy:EnableDrag(false)
		phy:SetMass( 0)
		phy:Sleep()
	end

	n = self:GetBoneCount()

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


end

local index, n

function ENT:Think()
end

function ENT:OnTakeDamage()

end

function ENT:Touch( )

end

function ENT:StartTouch( )

end

function ENT:EndTouch( )

end

function ENT:PhysicsCollide()

end