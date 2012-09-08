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
	if type(condition) != "function" then
		condition = function()
			if self:Alive() then
				return true
			end
			return false
		end
	end
	if stat:lower() == "stamina" then
		timername = util.CRC( RealTime() )
		timer.Create(timername, interval, time * (1/interval), function()
			if condition() then
				self:AddStamina( amount )
			else
				timer.Destroy( timername )
			end
		end)
	end
end


--Stamina

if CLIENT then
	usermessage.Hook( "Tiramisu.SendStamina", function(um)
		if LocalPlayer().SetStamina then
			LocalPlayer():SetStamina( um:ReadFloat() )
			if LocalPlayer():GetStamina() == 100 then
				timer.Simple( 3, function()
					LocalPlayer().TiramisuStaminaRegen = false
				end)
			else
				LocalPlayer().TiramisuStaminaRegen = true
			end
		end
	end)

	hook.Add( "HUDPaint", "Tiramisu.DrawStaminaBar", function()
		--See cl_skin.lua for it.
		derma.SkinHook( "Paint", "StaminaBar" )
	end)
else
	hook.Add( "PlayerSpawn", "Tiramisu.ResetStamina", function( ply )
		if ply:IsCharLoaded() then
			ply:SetStamina( 100 )
			timer.Create( "Tiramisu.StaminaRecovery." .. ply:SteamID(), 1, 0, function()
				if ValidEntity( ply ) then
					ply:SetStamina(ply:GetStamina() + TIRA.Stats.Stamina.BaseRegenRate)
				end
			end)
		end
	end)

	hook.Add( "PlayerDisconnected", "Tiramisu.DestroyResetStaminaTimer", function( ply )
		timer.Destroy("Tiramisu.StaminaRecovery." .. ply:SteamID())
	end)

	hook.Add( "SetupMove", "Tiramisu.DrainStaminaWhenRunning", function( ply, mv )
		if ply:KeyDown(IN_SPEED) and ply:KeyDown(IN_FORWARD) and ply:GetStamina() >= TIRA.Stats.Stamina.BaseRunCost then
			if !ply.IsRunning then
				if ply:GetStamina() > 10 then
					ply:StatDamage( "stamina",0, 0.25, TIRA.Stats.Stamina.BaseRunCost/-4, function()
						if ply:KeyDown(IN_SPEED) and ply:KeyDown(IN_FORWARD) and ply.IsRunning and ply:GetRunSpeed() > TIRA.ConVars[ "WalkSpeed" ] and ply:Alive() then
							return true
						end
						ply.IsRunning = false
						return false
					end)
					ply.IsRunning = true
				end
			end
			if ply.IsRunning then
				if( ValidEntity(ply:GetActiveWeapon()) and Anims.DetectHoldType(ply:GetActiveWeapon():GetHoldType()) == "default") then
					if !ply:KeyDown( IN_MOVELEFT ) and !ply:KeyDown( IN_MOVERIGHT ) then
						ply:SetRunSpeed( Lerp( 0.01, ply:GetRunSpeed(), TIRA.ConVars[ "RunSpeed" ] ))
					else
						ply:SetRunSpeed( Lerp( 0.01, ply:GetRunSpeed(), TIRA.ConVars[ "RunSpeed" ] * 0.75 ))				
					end
				else
					ply:SetRunSpeed( Lerp( 0.01, ply:GetRunSpeed(), TIRA.ConVars[ "RunSpeed" ] * 0.66 ))
				end
			end
		else
			if ply:GetWalkSpeed() < TIRA.ConVars[ "WalkSpeed" ] + 10 then
				ply.IsRunning = false
			end
			if ply.IsRunning and ply:KeyDown(IN_FORWARD) then
				ply:SetRunSpeed( Lerp( 0.1, ply:GetRunSpeed(), TIRA.ConVars[ "WalkSpeed" ] ))
				ply:SetWalkSpeed( ply:GetRunSpeed() )
			elseif ply.IsRunning and !ply:KeyDown(IN_FORWARD) then
				ply:SetRunSpeed( Lerp( 0.1, ply:GetRunSpeed(), 0 ))
				ply:SetVelocity( ply:GetForward() * ply:GetRunSpeed() / 10 )
			else
				ply:SetRunSpeed( TIRA.ConVars[ "WalkSpeed" ] )
				ply:SetWalkSpeed( TIRA.ConVars[ "WalkSpeed" ] )
			end
		end
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
			umsg.Float( self.Stamina )
		umsg.End()
	end
end

function meta:AddStamina( amount )
	self:SetStamina( self:GetStamina() + amount )
end


--Health

if CLIENT then

	function meta:GetMaxHealth()
		return self.MaxHealth or 100
	end

	usermessage.Hook( "Tiramisu.SendMaxHealth", function(um)
		LocalPlayer().MaxHealth = um:ReadFloat()
		if LocalPlayer().MaxHealth == LocalPlayer():Health() then
			timer.Simple( 3, function()
				LocalPlayer().TiramisuHealthRegen = false
			end)
		else
			LocalPlayer().TiramisuHealthRegen = true
		end
	end)

	hook.Add( "HUDPaint", "Tiramisu.DrawHealthBar", function()
		derma.SkinHook( "Paint", "HealthBar" )
	end)
else
	hook.Add( "PlayerSpawn", "Tiramisu.ResetHealth", function( ply )
		if ply:IsCharLoaded() then
			ply:SetMaxHealth( math.Clamp(TIRA.GetCharField( ply, "health" ),1, TIRA.Stats.Health.Max))
			umsg.Start("Tiramisu.SendMaxHealth", ply )
				umsg.Float(TIRA.GetCharField( ply, "health" ))
			umsg.End()
			timer.Create( "Tiramisu.HealthRecovery." .. ply:SteamID(), 1, 0, function()
				if ValidEntity( ply ) then
					if (ply:Health() + TIRA.Stats.Health.BaseRegenRate) / ply:GetMaxHealth() * 100 <= TIRA.Stats.Health.MaxRegenPerc then
						ply:SetHealth(ply:Health() + TIRA.Stats.Health.BaseRegenRate)
					end
				end
			end)
		end
	end)

	hook.Add( "PlayerDisconnected", "Tiramisu.DestroyResetHealthTimer", function( ply )
		timer.Destroy("Tiramisu.HealthRecovery." .. ply:SteamID())
	end)
end

function PLUGIN.Init()
	TIRA.AddDataField( 2, "health", TIRA.Stats.Health.Base )
end