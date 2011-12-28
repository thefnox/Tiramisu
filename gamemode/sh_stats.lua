--Stats for the fighting system, plus stamina

CAKE.Stats = {}

CAKE.Stats.Stamina = {}
CAKE.Stats.Stamina.BaseRegenRate = 1 --This is the percentage recovered per second.

local meta = FindMetaTable( "Player" )

--General

--This works for all stats, it's a way to increase them (or decrease them) over a certain amount of time.
--Time is the time in seconds the effect will take place
--Interval is the fraction of a second the effect will be performed on.
--Amount is the amount to be increased
--Condition is an optional callback, if the condition is false then the effect is broken.
function meta:StatDamage( stat, time, interval, amount, condition )
	local timername
	time = time or 1
	interval = interval or 1
	amount = amount or 1
	condition = condition or function()
		if self:Alive() then
			return true
		end
		return false
	end
	if stat:lower() == "stamina" then
		timername = RealTime()
		timer.Create(timername, interval, time * (1/interval), function()
			if condition then
				self:SetStamina( self:GetStamina() + amount )
			else
				timer.Destroy( timername )
			end
		end)
	end
end


--Stamina

if CLIENT then
	usermessage.Hook( "Tiramisu.SendStamina", function(um)
		LocalPlayer():SetStamina( um:ReadShort() )
	end)
else
	hook.Add( "PlayerSpawn", "Tiramisu.ResetStamina", function( ply )
		ply:SetStamina( 100 )
		timer.Create( "Tiramisu.StaminaRecovery." .. ply:SteamID(), 1, 0, function()
			ply:SetStamina(ply:GetStamina() + CAKE.Stats.Stamina.BaseRegenRate)
		end)
	end)
end

function meta:GetStamina()
	return self.Stamina or 100
end

function meta:SetStamina( amount )
	self.Stamina = math.Clamp( amount, 0, 100 )
	if self.Stamina == 100 then
		timer.Stop( "Tiramisu.StaminaRecovery." .. self:SteamID() )
	else
		timer.Start( "Tiramisu.StaminaRecovery." .. self:SteamID() )
	end
	if SERVER then
		umsg.Start( "Tiramisu.SendStamina", self )
			umsg.Short( self.Stamina )
		umsg.End()
	end
end