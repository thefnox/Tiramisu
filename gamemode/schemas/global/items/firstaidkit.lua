ITEM.Name = "First Aid Kit"
ITEM.Class = "firstaidkit"
ITEM.Description = "Hold near patient then press actuator"
ITEM.Model = "models/Items/healthkit.mdl"
ITEM.Purchaseable = true
ITEM.Price = 25
ITEM.ItemGroup = 3

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)
	
	local possible = {}
	
	-- Find the target
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 10)) do
	
		if(v != nil and v:IsValid() and v:IsTiraPlayer() and v != ply) then
		
			table.insert(possible, v)
			
		elseif(v != nil and v:IsValid() and v:GetClass() == "prop_ragdoll" and v.isdeathdoll and v.ply:GetNWInt("deathmode") == 1 and v.ply != ply) then
		
			-- This is what makes 'revival' possible, and makes deathmode have a purpose.
			
			v.ply:Spawn()
			v.ply:SetHealth(15)
			v.ply:SetPos(v:GetPos())
			CAKE.SendChat(ply, "*beep* Anabolic Steroids Injected")
			CAKE.SendChat(v.ply, "*beep* Anabolic Steroids Injected")
			self:Remove()
			v:Remove()
			return
			
		end
		
	end
	
	if(#possible > 1) then
	
		CAKE.SendChat(ply, "*beep* Multiple targets found")
		return
		
	elseif(#possible == 0) then
	
		CAKE.SendChat(ply, "*beep* No target found")
		return
		
	end
	
	possible[1]:SetHealth(math.Clamp(possible[1]:Health() + 100, 0, possible[1]:MaxHealth()))
	ply:Say("/me heals " .. possible[1]:Nick())
	self:Remove()

end