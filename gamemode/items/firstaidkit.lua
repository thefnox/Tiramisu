ITEM.Name = "First Aid Kit"
ITEM.Class = "firstaidkit"
ITEM.Description = "Hold near patient then press actuator"
ITEM.Model = "models/Items/healthkit.mdl"
ITEM.Purchaseable = true
ITEM.Price = 25
ITEM.ItemGroup = 3
ITEM.Unusable = true
ITEM.RightClick = {
	["Revive"] = "UseItem"
}


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)
	

	local id = self:GetNWString("id")

	if !CAKE.GetUData(id , "lastrevive") then
		CAKE.SetUData(id , "lastrevive", -99999) 
	end

	if !ply.ReviveCooldown then
		ply.ReviveCooldown = -99999
	end

	if (ply.ReviveCooldown + 120) > os.time() then
		CAKE.SendChat(ply, "Please wait " .. math.floor(ply.ReviveCooldown + 120 - os.time()) .. " seconds until you can revive again." )
		return
	end

	if (CAKE.GetUData(id , "lastrevive") + 120) > os.time() then
		CAKE.SendChat(ply, "Please wait " .. math.floor(CAKE.GetUData(id , "lastrevive")+ 120 - os.time())  .. " seconds for this unit to be usable again." )
		return
	end

	if ply:GetNWInt("deathmode",0) > 0 then
		CAKE.SendChat(ply, "*beep* Anabolic Steroids Injected")
		ply:Spawn()
		if IsValid(ply.rag) then
			ply:SetPos(ply.rag:GetPos() + Vector( 0, 0, 30 ))
			ply.rag:Remove()
			ply.rag = nil
		else
			ply:SetPos(self:GetPos() + Vector( 0, 0, 30 ))
		end
		ply:SetHealth(15)
		ply.ReviveCooldown = os.time()
		CAKE.SetUData(id, "lastrevive", os.time()) 
		return
	else
		for _, pl in pairs(ents.FindInSphere(self:GetPos(), 100)) do
			if IsValid(pl) and pl:IsTiraPlayer() and pl:GetNWInt("deathmode",0) > 0 then
				pl:Spawn()
				pl:SetHealth()
				pl:SetPos(ply:CalcDrop() + Vector( 0, 0, 6 ))
				CAKE.SendChat(ply, "*beep* Anabolic Steroids Injected")
				CAKE.SendChat(pl, "*beep* Anabolic Steroids Injected")
				if IsValid( pl.rag ) then
					pl.rag:Remove()
				end
				pl.rag = nil
				ply.ReviveCooldown = os.time()
				CAKE.SetUData(id, "lastrevive", os.time()) 
				return
			end
		end
	end

	CAKE.SendChat(ply, "*beep* No target found")

end