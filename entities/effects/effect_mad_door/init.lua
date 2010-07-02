function EFFECT:Init(data)

	local vOffset = data:GetOrigin()

	local emitter = ParticleEmitter(data:GetOrigin())

		for i = 0, 32 do
			local particle = emitter:Add("particle/particle_smokegrenade", vOffset)

			if (particle) then
				particle:SetVelocity(VectorRand() * math.Rand(500, 1000))
				
				particle:SetLifeTime(0)
				particle:SetDieTime(math.Rand(5, 15))
				
				particle:SetColor(120, 120, 120)			

				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				
				particle:SetStartSize(25)
				particle:SetEndSize(math.random(50,100))
				
				particle:SetRoll(math.Rand(-360, 360))
				particle:SetRollDelta(math.Rand(-0.21, 0.21))
				
				particle:SetAirResistance(math.Rand(520, 620))
				
				particle:SetGravity(Vector(0, 0, math.Rand(-32, -64)))

				particle:SetCollide(true)
				particle:SetBounce(0.42)
			end
		end
		
	emitter:Finish()
end

function EFFECT:Think()

	return false
end

function EFFECT:Render()

end

