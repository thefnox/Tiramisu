function EFFECT:Init(data)
	
	local NumParticles = 128
	
	local emitter = ParticleEmitter(data:GetOrigin())
	
		for i = 0, NumParticles do

			local Pos = (data:GetOrigin() + Vector(math.Rand(-24, 24), math.Rand(-24, 24), math.Rand(-24, 24)) + Vector(0, 0, math.Rand(0, 80)))
		
			local particle = emitter:Add("particle/particle_smokegrenade", Pos)

			if (particle) then
				particle:SetVelocity(VectorRand() * math.Rand(250, 500))
				
				particle:SetLifeTime(0)
				particle:SetDieTime(math.Rand(1, 3))
				
				particle:SetColor(math.Rand(145, 195), 0, math.Rand(170, 220))			

				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				
				local Size = math.Rand(15, 50)
				particle:SetStartSize(Size)
				particle:SetEndSize(Size * 2)
				
				particle:SetRoll(math.Rand(-360, 360))
				particle:SetRollDelta(math.Rand(-0.21, 0.21))
				
				particle:SetAirResistance(500)
				
				particle:SetGravity(Vector(math.Rand(-1000, 1000), math.Rand(-1000, 1000), math.Rand(0, -1000)))

				particle:SetCollide(true)
				particle:SetBounce(0.45)

				particle:SetLighting(1)
			end
		end
		
	emitter:Finish()
end

function EFFECT:Think()

	return false
end

function EFFECT:Render()
end