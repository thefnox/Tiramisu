--Little circle thang.

local sin,cos,rad = math.sin,math.cos,math.rad; --it slightly increases the speed.
local center = Vector( ScrW() - 100, ScrH() - 130, 0 )
local scale = 80
local circle = {}
for i=1,50 do
circle[i] = {x = ScrW() - 100 + cos(rad(i*360)/50)*80,y = ScrH() - 130 + sin(rad(i*360)/50)*80};
end
local pos
local target
local ang
local newpos
local fov = 85

local function CreateCharPortrait()

	CAKE.CharacterPortrait = ClientsideModel(LocalPlayer():GetNWString( "model", "models/kleiner.mdl" ), RENDERGROUP_OPAQUE)
	CAKE.CharacterPortrait:SetNoDraw( true )
	local bone = CAKE.CharacterPortrait:LookupBone("ValveBiped.Bip01_Head1")

	if bone then
		pos, ang = CAKE.CharacterPortrait:GetBonePosition( bone )
		local target = CAKE.CharacterPortrait:GetPos()+Vector(0,0,66)
		local newpos = ang:Forward() * 2 + ang:Right() * 10 - ang:Up() * 13
		pos = target + newpos
		ang = (target-pos):Angle()
		fov = 85
	else
		--Taken from the spawnicon code
		CAKE.CharacterPortrait:SetAngles( Angle( 0, 180, 0 ) )
		local mn, mx = CAKE.CharacterPortrait:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
		size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
		size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
		size = size * (1 - ( size / 900 ))
		ang = Angle( 25, 40, 0 )
		pos = CAKE.CharacterPortrait:GetPos() + ang:Forward() * size * -15 + (mn + mx) * 0.5
		fov = 10
	end

end
CreateCharPortrait()
timer.Create( "RefreshPortrait", 5, 0, function()
	CreateCharPortrait()
end)


hook.Add("HUDPaint","TiramisuCircleHealthDisplay", function()

	--Ryaga made this
	render.ClearStencil()
	render.SetStencilEnable( true )

	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )

	render.SetStencilReferenceValue( 1 )
	--Draw circle holding portrait here.
	surface.SetDrawColor( 0,0,0, 155 ) --set the additive color
	surface.DrawPoly( circle ) --draw the triangle with our triangle table

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	--Draw portrait here.
	cam.Start3D( pos, ang, fov, ScrW() - 190, ScrH() - 220, 180, 180 )
		cam.IgnoreZ( true )   
		render.SuppressEngineLighting( true )
		CAKE.CharacterPortrait:DrawModel()
		render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
	cam.End3D()

	render.SetStencilEnable( false )

	surface.SetDrawColor( 20,20,20, 155 )
	--Black border around the health bar.
	for a = 0, 50 do
		surface.DrawTexturedRectRotated( center.x + cos( rad( a * 7.2 ) ) * scale, center.y - sin( rad( a * 7.2 ) ) * scale, 12, 12, a * 7.2  )
	end
	--Health bar.
	for a = 0, math.Clamp( LocalPlayer():Health() / 2, 0, 49 ) do
		surface.SetDrawColor( 220 - LocalPlayer():Health() * 2, 20 + LocalPlayer():Health() * 2, 20, 255 )
		surface.DrawTexturedRectRotated( center.x + cos( rad( a * 7.2 ) ) * scale, center.y - sin( rad( a * 7.2 ) ) * scale, 8, 12, a * 7.2  )
	end
	--Armor bar.
	if LocalPlayer():Armor() > 0 then
		for a = 0, math.Clamp( LocalPlayer():Armor() / 2, 0, 49 ) do
			surface.SetDrawColor( 80, 80, 220, 200 )
			surface.DrawTexturedRectRotated( center.x + cos( rad( a * 7.2 ) ) * scale, center.y - sin( rad( a * 7.2 ) ) * scale, 10, 12, a * 7.2  )
		end
	end

end)
