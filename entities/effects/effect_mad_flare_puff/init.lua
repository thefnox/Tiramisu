function EFFECT:Init(data)
	
	local NumParticles = 64
	
	local emitter = ParticleEmitter(data:GetOrigin())
	
		for i = 0, NumParticles do

			local Pos = (data:GetOrigin())
		
			local particle = emitter:Add("particle/particle_smokegrenade", Pos)

			if (particle) then
				particle:SetVelocity(VectorRand() * math.Rand(200, 400))
				
				particle:SetLifeTime(0)
				particle:SetDieTime(1.5)
				
				particle:SetColor(180, 0, 0)			

				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				
				particle:SetStartSize(5)
				particle:SetEndSize(20)
				
				particle:SetRoll(math.Rand(-360, 360))
				particle:SetRollDelta(math.Rand(-0.21, 0.21))
				
				particle:SetAirResistance(math.Rand(500, 800))
				
				particle:SetGravity(Vector(0, 0, -50))

				particle:SetCollide(true)
				particle:SetBounce(0.45)
			end
		end
		
	emitter:Finish()
end

function EFFECT:Think()

	return false
end

function EFFECT:Render()
end