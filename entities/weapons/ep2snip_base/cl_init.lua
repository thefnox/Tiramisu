include("shared.lua")

SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= false
SWEP.ViewModelFOV		= 80
SWEP.ViewModelFlip		= true
SWEP.CSMuzzleFlashes	= true
SWEP.DrawWeaponInfoBox  = true



--This is the font that's used to draw the death icons
surface.CreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
surface.CreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
-- This is the font that's used to draw the sexy firemode HUD display
surface.CreateFont("HalfLife2", 24, 500, true, false, "rg_firemode")

-- We need to get these so we can scale everything to the player's current resolution.
local iScreenWidth = surface.ScreenWidth()
local iScreenHeight = surface.ScreenHeight()

SWEP.FireModeDrawTable = {} -- You can add things to this table from a firemode's init function and call them from a firemode's HUDDraw function


function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	
	draw.SimpleText(self.IconLetter, "CSSelectIcons", x + 0.5*wide, y + tall*0.2, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER )
	
	-- try to fool them into thinking they're playing a Tony Hawks game
	draw.SimpleText(self.IconLetter, "CSSelectIcons", x + 0.5*wide + math.Rand(-2, 2), y + tall*0.2+ math.Rand(-10, 10), Color(255, 220, 0, math.Rand(20, 60)), TEXT_ALIGN_CENTER)
	draw.SimpleText(self.IconLetter, "CSSelectIcons", x + 0.5*wide + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-4, 4), Color(255, 220, 0, math.Rand(20, 60)), TEXT_ALIGN_CENTER)
	
	-- Draw weapon info box
	self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	
end


local SCOPEFADE_TIME = 0.4
function SWEP:DrawHUD()

	if self.UseScope then

		local bScope = self.Weapon:GetNetworkedBool("Scope")
		if bScope ~= self.bLastScope then -- Are we turning the scope off/on?
	
			self.bLastScope = bScope
			self.fScopeTime = CurTime()
			
		elseif 	bScope then
		
			local fScopeZoom = self.Weapon:GetNetworkedFloat("ScopeZoom")
			if fScopeZoom ~= self.fLastScopeZoom then -- Are we changing the scope zoom level?
		
				self.fLastScopeZoom = fScopeZoom
				self.fScopeTime = CurTime()

			end

		end
		

	
		local fScopeTime = self.fScopeTime or 0
		if fScopeTime > CurTime() - SCOPEFADE_TIME then
		
			local Mul = 1.0 -- This scales the alpha
			Mul = 1 - math.Clamp((CurTime() - fScopeTime)/SCOPEFADE_TIME, 0, 1)
		
			surface.SetDrawColor(0, 0, 0, 255*Mul) -- Draw a black rect over everything and scale the alpha for a neat fadein effect
			surface.DrawRect(0,0,iScreenWidth,iScreenHeight)
		
		end

		if bScope then 

			-- Draw the crosshair
			-- surface.SetDrawColor(0, 0, 0, 150)
			-- surface.DrawLine(self.CrossHairTable.x11,self.CrossHairTable.y11,self.CrossHairTable.x12,self.CrossHairTable.y12)
			-- surface.DrawLine(self.CrossHairTable.x21,self.CrossHairTable.y21,self.CrossHairTable.x22,self.CrossHairTable.y22)
			
			-- Draw the cool parabolic sights
			if self.DrawParabolicSights then
				surface.SetDrawColor(0, 0, 0, 220)
				surface.SetTexture(surface.GetTextureID("jaanus/ep2snip_parascope"))
				surface.DrawTexturedRect(self.ParaScopeTable.x,self.ParaScopeTable.y,self.ParaScopeTable.w,self.ParaScopeTable.h)
			end
			
			-- Draw the lens
			surface.SetDrawColor(20,20,20,40)
			surface.SetTexture(surface.GetTextureID("overlays/scope_lens"))
			surface.DrawTexturedRect(self.LensTable.x,self.LensTable.y,self.LensTable.w,self.LensTable.h)

			-- Draw the scope
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("jaanus/sniper_corner"))
			surface.DrawTexturedRectRotated(self.ScopeTable.x1,self.ScopeTable.y1,self.ScopeTable.l,self.ScopeTable.l,270)
			surface.DrawTexturedRectRotated(self.ScopeTable.x2,self.ScopeTable.y2,self.ScopeTable.l,self.ScopeTable.l,180)
			surface.DrawTexturedRectRotated(self.ScopeTable.x3,self.ScopeTable.y3,self.ScopeTable.l,self.ScopeTable.l,90)
			surface.DrawTexturedRectRotated(self.ScopeTable.x4,self.ScopeTable.y4,self.ScopeTable.l,self.ScopeTable.l,0)

			-- Fill in everything else
			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect(self.QuadTable.x1,self.QuadTable.y1,self.QuadTable.w1,self.QuadTable.h1)
			surface.DrawRect(self.QuadTable.x2,self.QuadTable.y2,self.QuadTable.w2,self.QuadTable.h2)
			surface.DrawRect(self.QuadTable.x3,self.QuadTable.y3,self.QuadTable.w3,self.QuadTable.h3)
			surface.DrawRect(self.QuadTable.x4,self.QuadTable.y4,self.QuadTable.w4,self.QuadTable.h4)
			
			local rotatick = CurTime()*90/5
			surface.SetTexture(surface.GetTextureID("jaanus/rotatingthing"))
			surface.SetDrawColor(0,0,0,120)
			surface.DrawTexturedRectRotated(ScrW()/2, ScrH()/2,self.LensTable.w * 1.2, self.LensTable.h * 1.2, rotatick)
			
		end
	
	end
	
	if not self.DrawFireModes then return end
	
	local FireMode = self.Weapon:GetNetworkedInt("FireMode",1)
	self.FireModes[self.AvailableFireModes[FireMode]].HUDDrawFunction(self) -- yuck

	
end


-- mostly garry's code
local IRONSIGHT_TIME = 0.32
function SWEP:GetViewModelPosition(pos, ang)

	if not self.IronSightsPos then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool("Ironsights")
	if bIron ~= self.bLastIron then -- Are we toggling ironsights?
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if bIron then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if not bIron and (fIronTime < CurTime() - IRONSIGHT_TIME) then 
		return pos, ang 
	end
	
	local Mul = 1.0 -- we scale the model pos by this value so we can interpolate between ironsight/normal view
	
	if fIronTime > CurTime() - IRONSIGHT_TIME then
	
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)
		if not bIron then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if self.IronSightsAng then
	
		ang = ang*1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 			self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

-- This function handles player FOV clientside.  It is used for scope and ironsight zooming.
function SWEP:TranslateFOV(current_fov)

	local fScopeZoom = self.Weapon:GetNetworkedFloat("ScopeZoom")
	if self.Weapon:GetNetworkedBool("Scope") then return current_fov/fScopeZoom end
	
	local bIron = self.Weapon:GetNetworkedBool("Ironsights")
	if bIron ~= self.bLastIron then -- Do the same thing as in CalcViewModel.  I don't know why this works, but it does.
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()

	end
	
	local fIronTime = self.fIronTime or 0

	if not bIron and (fIronTime < CurTime() - IRONSIGHT_TIME) then 
		return current_fov
	end
	
	local Mul = 1.0 -- More interpolating shit
	
	if fIronTime > CurTime() - IRONSIGHT_TIME then
	
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)
		if not bIron then Mul = 1 - Mul end
	
	end

	current_fov = current_fov*(1 + Mul/self.IronSightZoom - Mul)

	return current_fov

end
