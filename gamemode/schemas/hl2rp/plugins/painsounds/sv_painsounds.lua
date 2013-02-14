// Pain Sounds, by VorteX

local legs = {
	
	HITGROUP_LEFTLEG,
	HITGROUP_RIGHTLEG
	
	}

local arms = {
	
	HITGROUP_LEFTARM,
	HITGROUP_RIGHTARM
	
	}


function PS_EntityTakeDamage(ent, dmginfo)
	
	if !ent:IsPlayer() then return end
	
	local hitgroup = ent:LastHitGroup()
	
	local gender = CAKE.GetCharField(ent, "gender") or "Male"
	local moansound
	
	if table.HasValue(legs, hitgroup) then
		
		if gender == "Male" then
			
			moansound = Sound("vo/npc/male01/myleg0" .. math.random(1, 2) .. ".wav")
			
		else
			
			moansound = Sound("vo/npc/female01/myleg0" .. math.random(1, 2) .. ".wav")
			
		end
		
	elseif table.HasValue(arms, hitgroup) then
		
		if gender == "Male" then
			
			moansound = Sound("vo/npc/male01/myarm0"..math.random(1, 2)..".wav")
			
		else
			
			moansound = Sound("vo/npc/female01/myarm0"..math.random(1, 2)..".wav")
			
		end
		
	else
		
		if gender == "Male" then
			
			moansound = Sound("vo/npc/male01/pain0"..math.random(1, 9)..".wav")
			
		else
			
			moansound = Sound("vo/npc/female01/pain0"..math.random(1, 9)..".wav")
			
		end
		
	end
	
	--I added a timer for them so they don't play all the time
	if !ent.LastPlayedMoanSound then ent.LastPlayedMoanSound = CurTime() end
	if ent.LastPlayedMoanSound <= CurTime() then 
		ent:EmitSound(moansound)
		ent.LastPlayedMoanSound = CurTime() + math.random(1, 4)
	end
end
hook.Add("EntityTakeDamage", "PainSounds_ETD", PS_EntityTakeDamage)