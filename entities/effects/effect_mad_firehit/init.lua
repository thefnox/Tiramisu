/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data)
	
	local vOffset = data:GetOrigin()

	local emitter = ParticleEmitter(vOffset)

		local particle = emitter:Add("effects/fire_cloud1", vOffset)

			particle:SetVelocity(25 * data:GetNormal())
			particle:SetAirResistance(200)

			particle:SetDieTime(0.2)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetStartSize(8)
			particle:SetEndSize(0)

			particle:SetRoll(math.Rand(180, 480))
			particle:SetRollDelta(math.Rand(-1, 1))

			particle:SetColor(255, 255, 255)

		local particle = emitter:Add("particle/particle_smokegrenade", vOffset)

			particle:SetVelocity(100 * data:GetNormal())
			particle:SetAirResistance(400)
			particle:SetGravity(Vector(0, 0, math.Rand(25, 100)))

			particle:SetDieTime(math.Rand(1.0, 2.0))

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetStartSize(math.Rand(5, 10))
			particle:SetEndSize(math.Rand(20, 40))

			particle:SetRoll(math.Rand(-25, 25))
			particle:SetRollDelta(math.Rand(-0.05, 0.05))

			particle:SetColor(255, 255, 255)

	emitter:Finish()
end

/*---------------------------------------------------------
	EFFECT:Think()
---------------------------------------------------------*/
function EFFECT:Think()

	return false
end

/*---------------------------------------------------------
	EFFECT:Render()
---------------------------------------------------------*/
function EFFECT:Render()
end