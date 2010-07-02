local matLight2 = Material("effects/yellowflare")

util.PrecacheSound("weapons/explode3.wav")
util.PrecacheSound("weapons/explode4.wav")
util.PrecacheSound("weapons/explode5.wav")

/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data)
 	 
 	// This is how long the spawn effect  
 	// takes from start to finish. 
 	self.Time = 1
 	self.LifeTime = CurTime() + self.Time 
	
 	self.Explosion = {}
	self.Explosion[1] = "weapons/explode3.wav"
	self.Explosion[2] = "weapons/explode4.wav"
	self.Explosion[3] = "weapons/explode5.wav"
 	self.vOffset = data:GetOrigin()
	
	WorldSound(self.Explosion[math.random(1, 3)], self.vOffset, 160, 130) 	 
end

/*---------------------------------------------------------
	EFFECT:Think()
---------------------------------------------------------*/
function EFFECT:Think() 
   
	return (self.LifeTime > CurTime())  
end 

/*---------------------------------------------------------
	EFFECT:Render()
---------------------------------------------------------*/
function EFFECT:Render() 
 	 
 	local Fraction = (self.LifeTime - CurTime()) / self.Time 
 	Fraction = math.Clamp(Fraction, 0, 1) 
 	
	self.Entity:SetColor(255, 255, 255, 255 * Fraction)
	self.Entity:SetModelScale(Vector() * 100 * (1 - Fraction))
	
   	render.SetMaterial(matLight2)
	render.DrawQuadEasy(self.vOffset, VectorRand(), 2000 * (Fraction) , 2000 * (Fraction) , color_white)
	render.DrawQuadEasy(self.vOffset, VectorRand(), math.Rand(32, 500), math.Rand(32, 500), color_white)
	render.DrawSprite(self.vOffset, 2000 * (Fraction), 2000 * (Fraction), Color(255, 150, 150, 255))
end  