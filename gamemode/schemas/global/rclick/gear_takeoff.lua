RCLICK.Name = "Take Off Gear"
RCLICK.SubMenu = "Clothes"

function RCLICK.Condition(target)

	if target == LocalPlayer() and CAKE.Gear and table.Count( CAKE.Gear ) > 0 then return true end

end

function RCLICK.Click(target,ply)
	timer.Simple( 0, function() --This timer is so the system can close down the previous DermaMenu without closing this one too
		local dmenu = DermaMenu()
		local main = dmenu:AddSubMenu( "Take Off" )
		local bones = {} 

		for bone, tbl in pairs( CAKE.Gear ) do
			if !bones[bone] then
				bones[bone] = main:AddSubMenu( bone:sub( 1, 1 ):upper() .. bone:sub( 2 ) )
			end
			for k, v in pairs( tbl ) do
				bones[bone]:AddOption( v.name or v.item , function() RunConsoleCommand( "rp_takeoffitem", v.item, v.itemid ) end)
			end
		end
		main:AddOption("Take Off Everything", function() RunConsoleCommand( "rp_takeoffallgear") end)
		dmenu:Open()
	end)

end