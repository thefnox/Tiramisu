/*
function TIRA.FlashLightBindPress(ply, bind, pressed)
	if string.find(bind, "impulse 100") then
		RunConsoleCommand("rp_flashlight")
		return true
	end
end
hook.Add("PlayerBindPress", "FlashBind", TIRA.FlashLightBindPress)

function TIRA.FlashLightOn(um)
	local ply = um:ReadEntity()
	ply.flashlight = um:ReadEntity()
end
usermessage.Hook( "flashlighton", TIRA.FlashLightOn )

function TIRA.FlashlightThink()
	for k,v in pairs(player.GetAll()) do
		if v.flashlight and v.flashlight:IsValid() then
			local headpos = v:EyePos()
			local headang = v.CurrentLookAt + v:GetAngles()
			local headnorm = headang:Forward()*14
			v.flashlight:SetPos(headpos + headnorm)
			v.flashlight:SetAngles((v.CurrentLookAt + v:GetAngles()) or Angle(90,90,90))
		end
	end
end
hook.Add("Think", "FlashlightThink", TIRA.FlashlightThink)*/