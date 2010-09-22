/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data)
 	 
	self.Entity:SetParent( data:GetEntity() )
	self.Entity:SetModel( data:GetEntity():GetModel() )
	self.Entity:SetPos( data:GetEntity():GetPos() )
	self.Entity:SetAngles( data:GetEntity():GetAngles() )
	self.Entity:AddEffects( EF_BONEMERGE | EF_BONEMERGE_FASTCULL | EF_PARENT_ANIMATES )

 	self.Time = 1
 	self.LifeTime = CurTime() + self.Time
	
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

	self.Entity:SetMaterial( "models/props_combine/stasisshield_sheet" )
	self.Entity:SetModelScale(Vector(1.1, 1.1, 1.1))	

end  