hook.Add("PlayerBindPress", "Tiramisu.FlashBind", function(ply, bind, pressed)
	if string.find(bind, "impulse 100") and pressed then
		RunConsoleCommand("rp_flashlight")
		return true
	end
end)

usermessage.Hook( "flashlighton", function(um)
	local ply = um:ReadEntity()
	ply.flashlight = um:ReadEntity()
end)

hook.Add("Think", "Tiramisu.FlashlightThink", function()

	for k,v in pairs(player.GetAll()) do
		if v.flashlight and v.flashlight:IsValid() then
			local headpos = v:EyePos()
			local headang = v.CurrentLookAt + v:GetAngles()
			local headnorm = headang:Forward()*14
			v.flashlight:SetPos(headpos + headnorm)
			v.flashlight:SetAngles((v.CurrentLookAt + v:GetAngles()) or Angle(90,90,90))
		end
	end

end)