RCLICK.Name = "Edit Gear"
RCLICK.SubMenu = "Appearance"

function RCLICK.Condition(target)

	if target == LocalPlayer() and TIRA.Gear and table.Count( TIRA.Gear ) > 0 then return true end

end

function RCLICK.Click(target,ply)

	timer.Simple( 0, function() --This timer is so the system can close down the previous DermaMenu without closing this one too
		local dmenu = DermaMenu()
		local main = dmenu:AddSubMenu( "Edit" )
		local bones = {} 

		for bone, tbl in pairs( TIRA.Gear ) do
			if !bones[bone] then
				bones[bone] = main:AddSubMenu( bone )
			end
			for k, v in pairs( tbl ) do
				bones[bone]:AddOption(v.name or v.item , function() EditGear() StartGearEditor( v.entity, v.item, bone, v.entity:GetDTVector( 1 ), v.entity:GetDTAngle( 1 ), v.entity:GetDTVector( 2 ), v.entity:GetSkin(), v.name ) end)
			end
		end
		dmenu:Open()
	end)

end