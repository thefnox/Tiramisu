
local LASER = Material('effects/bluelaser1')
local SPRITE = Material('sprites/blueglow2')

function EFFECT:Init( effectdata )
 
self.Pos = effectdata:GetOrigin()
self.Entity:SetPos( self.Pos )

self.Attachment = "1"--effectdata:GetAttachment()

self.Weapon = effectdata:GetEntity()

self.Forw = self.Weapon:GetForward()

self.Alpha = 0--0

self.MAlpha = 150

self.rot = math.random(-100, 100)

self.Spawntime = CurTime()
self.Lifetime = 2
 
end 

function EFFECT:Think()
	
	if !self.Weapon:IsValid() then return false end
	

	self.Pos, self.Forw = self:GetTracerShootPosAng(self.Weapon:GetOwner():GetShootPos(), self.Weapon, self.Attachment)
	

	
	self.Entity:SetPos( self.Pos )
	
	local lifeleft = self.Spawntime + self.Lifetime - CurTime()
	if lifeleft < 0.8 then self.Alpha = lifeleft/0.8 * self.MAlpha end
	
	local livelived = CurTime() - self.Spawntime
	if livelived < 0.9 then self.Alpha = (livelived - 0.1)/0.8 * self.MAlpha end
	
	if livelived < 0.1 then self.Alpha = 0 end
	
	return CurTime() <= (self.Spawntime + self.Lifetime) and self.Weapon:GetOwner():GetActiveWeapon():GetClass() == "weapon_ep2sniper"
	
end


function EFFECT:Render()
	
	if self.Alpha == 0 then return end

	
	local origin = self.Pos
	local target
	local normal
	local beamscale
	
	if self.Forw:Distance(self.Weapon:GetOwner():GetAimVector()) < 0.05 then
		local traceres = self.Weapon:GetOwner():GetEyeTrace()
		target = traceres.HitPos
		normal = traceres.HitNormal
		
		beamscale = traceres.HitPos:Distance(origin) / 200
	else
	

		local traceres = util.QuickTrace(origin, self.Forw * 5000, {})
		target = traceres.HitPos
		normal = traceres.HitNormal
		
		beamscale = traceres.HitPos:Distance(origin) / 200
	end
	
	
	render.SetMaterial( LASER )
	render.DrawBeam(origin, target, 2, 0, beamscale, Color(255, 255, 255, self.Alpha))
	
	render.SetMaterial( SPRITE )
	render.DrawSprite( target + normal*1, 10, 10, Color(255, 255, 255, self.Alpha * 0.7) )
	render.DrawQuadEasy( target + normal*0.5, normal, 11, 11, Color(255, 255, 255, self.Alpha), CurTime() * self.rot )
	
end


function EFFECT:GetTracerShootPosAng( Position, Ent, Attachment )

	self.ViewModelTracer = false
	
	local Forward = Vector(0,0,1)
	
	if (!Ent:IsValid()) then return Position, Vector(0,0,1) end
	if (!Ent:IsWeapon()) then return Position, Vector(0,0,1) end

	// Shoot from the viewmodel
	if ( Ent:IsCarriedByLocalPlayer() && GetViewEntity() == LocalPlayer() ) then
	
		local ViewModel = LocalPlayer():GetViewModel()
		
		if ( ViewModel:IsValid() ) then
			
			local att = ViewModel:GetAttachment( Attachment )
			if ( att ) then
				Position = att.Pos + att.Ang:Right() * -2 - att.Ang:Forward() * 40
				Forward = att.Ang:Forward()
				self.ViewModelTracer = true
			end
			
		end
	
	// Shoot from the world model
	else
	

			Forward = Ent:GetOwner():GetAimVector()
			Position = Ent:GetPos() + Forward * 40 + Ent:GetUp() * 13 + Ent:GetRight() * 8

	
	end

	return Position,Forward

end
