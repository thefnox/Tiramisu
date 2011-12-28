--Little circle thang.
CAKE.DisplayCharPortrait = CreateClientConVar( "rp_displaycharportrait", 0, true, true )

local sin,cos,rad = math.sin,math.cos,math.rad; --it slightly increases the speed.
local screenpos = Vector( 130, 100, 0 )
local portraitpos = screenpos
local scale = 80
local circle = {}
for i=1,15 do
	circle[i] = {x = portraitpos.x + cos(rad(i*360)/15)*80,y = portraitpos.y + sin(rad(i*360)/15)*80}
end
local displayportrait = false
local pos
local target
local ang
local newpos
local fov = 85

--Refreshes the character portrait on the circle HUD element.
local function CreateCharPortrait()

	CAKE.CharacterPortrait = ClientsideModel(LocalPlayer():GetNWString( "model", "models/kleiner.mdl" ), RENDERGROUP_OPAQUE)
	CAKE.CharacterPortrait:SetNoDraw( true )
	local bone = CAKE.CharacterPortrait:LookupBone("ValveBiped.Bip01_Head1")

	if bone then
		pos, ang = CAKE.CharacterPortrait:GetBonePosition( bone )
		local target = CAKE.CharacterPortrait:GetPos()+Vector(0,0,66)
		local newpos = ang:Forward() * 2 + ang:Right() * 10 + ang:Up() * 13
		pos = target + newpos
		ang = (target-pos):Angle()
		fov = 85
	else
	--Taken from the spawnicon code
	CAKE.CharacterPortrait:SetPoseParameter("aim_yaw", 0 )
	CAKE.CharacterPortrait:SetPoseParameter("head_yaw", 0 )
	CAKE.CharacterPortrait:SetPoseParameter("body_yaw", 0 )
	CAKE.CharacterPortrait:SetPoseParameter("spine_yaw", 0 )
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

--Internal to see if the portrait should be displayed at some point. Also takes care of fading in/out the element.
local function DisplayCharPortrait( bool )
	if bool then
		portraitpos = Vector( Lerp( 0.2, portraitpos.x, screenpos.x ), screenpos.y, screenpos.z )
		for i=1,15 do
			circle[i] = {x = portraitpos.x + cos(rad(i*360)/15)*80,y = portraitpos.y + sin(rad(i*360)/15)*80}
		end
		displayportrait = true
	else
		portraitpos = Vector( Lerp( 0.2, portraitpos.x, -500 ), screenpos.y, screenpos.z )
		if portraitpos.x < 0 then
			displayportrait = false
		end
	end
end

---Simple check to make the element display when damaged.
hook.Add( "Think", "TiramisuDisplayPortrait",function()

	if CAKE.DisplayCharPortrait:GetBool() then
		DisplayCharPortrait( true )
	else
		DisplayCharPortrait( LocalPlayer().IsDamaged or false )
	end

end)

--Handles the entire drawing part.
hook.Add("HUDPaint","TiramisuCircleHealthDisplay", function()

	if displayportrait then

		--Ryaga made this
		render.ClearStencil()
		render.SetStencilEnable( true )

		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )

		render.SetStencilReferenceValue( 1 )
		--Draw circle holding portrait here.
		if displayportrait then
			surface.SetDrawColor( 0,0,0, 155 ) --set the additive color
			surface.DrawPoly( circle ) --draw the triangle with our triangle table
		end

		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		--Draw portrait here.
		cam.Start3D( pos, ang, fov, portraitpos.x-100,portraitpos.y-100 , 100 + scale , 100 + scale )
			cam.IgnoreZ( true )
			render.SuppressEngineLighting( true )
			render.SetLightingOrigin( CAKE.CharacterPortrait:GetPos() )
			render.ResetModelLighting( 1,1,1 )
			render.SetColorModulation( 1,1,1 )
			render.SetBlend( 1 )
			render.SetLightingOrigin( CAKE.CharacterPortrait:GetPos() )
			CAKE.CharacterPortrait:DrawModel()
			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
		cam.End3D()

		render.SetStencilEnable( false )

		surface.SetDrawColor( 20,20,20, 155 )
		--Black border around the health bar.
		surface.SetTexture()
		for a = 0, 50 do
			surface.DrawTexturedRectRotated( portraitpos.x + cos( rad( a * 7.2 ) ) * scale, portraitpos.y - sin( rad( a * 7.2 ) ) * scale, 12, 12, a * 7.2  )
		end
		--Health circle.
		surface.SetDrawColor( CAKE.BaseColor.r * LocalPlayer():Health() / 100 , CAKE.BaseColor.g * LocalPlayer():Health() / 100, CAKE.BaseColor.b * LocalPlayer():Health() / 100, 255 )
		for a = 0, math.Clamp( LocalPlayer():Health() / 2, 0, 49 ) do
			surface.DrawTexturedRectRotated( portraitpos.x + cos( rad( a * 7.2 ) ) * scale, portraitpos.y - sin( rad( a * 7.2 ) ) * scale, 8, 12, a * 7.2  )
		end
		--Money bar.
		-- draw.WordBox( 4, portraitpos.x+scale + 4    ,portraitpos.y - 8 , CurrencyTable.abr .. ": " .. LocalPlayer():GetNWString("money", "0" ), "TiramisuTimeFont" , Color( 20, 20, 20, 155 ), Color( 220, 220, 220, 200 ))

		--Armor circle.
		if LocalPlayer():Armor() > 0 then
			surface.SetDrawColor( 120, 120, 250, 150 )
			for a = 0, math.Clamp( LocalPlayer():Armor() / 2, 0, 49 ) do
				surface.DrawTexturedRectRotated( portraitpos.x + cos( rad( a * 7.2 ) ) * ( scale + 6 ), portraitpos.y - sin( rad( a * 7.2 ) ) * ( scale + 6 ), 6, 12, a * 7.2  )
			end
		end

	end
end)
