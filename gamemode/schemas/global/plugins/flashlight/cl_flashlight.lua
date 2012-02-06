function CAKE.FlashLightBindPress(ply, bind, pressed)
	if string.find(bind, "impulse 100") then
		print(bind)
		RunConsoleCommand("rp_flashlight")
		return true
	end
end
hook.Add("PlayerBindPress", "FlashBind", CAKE.FlashLightBindPress)

function CAKE.FlashLightOn(um)
	ply = um:ReadEntity()
	ply.flashlight = um:ReadEntity()
	print(ply.flashlight)
end
usermessage.Hook( "flashlighton", CAKE.FlashLightOn )

function CAKE.FlashlightThink()
	for k,v in pairs(player.GetAll()) do
		if v.flashlight and v.flashlight:IsValid() then
			headpos = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1"))
			headang = v.CurrentLookAt + v:GetAngles()
			headnorm = headang:Forward()*14
			v.flashlight:SetPos(headpos + headnorm)
			v.flashlight:SetAngles((v.CurrentLookAt + v:GetAngles()) or Angle(90,90,90))
		end
	end
end
hook.Add("PreDrawOpaqueRenderables", "FlashlightThink", CAKE.FlashlightThink)