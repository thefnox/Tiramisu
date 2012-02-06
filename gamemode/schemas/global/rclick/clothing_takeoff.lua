RCLICK.Name = "Take Off Clothes"
RCLICK.SubMenu = "Clothes"

function RCLICK.Condition(target)

	if target == LocalPlayer() and CAKE.ClothingTbl and table.Count( CAKE.ClothingTbl ) > 1 then return true end

end

function RCLICK.Click(target,ply)

	
	timer.Simple( 0, function() --This timer is so the system can close down the previous DermaMenu without closing this one too
		local dmenu = DermaMenu()
		local main = dmenu:AddSubMenu( "Take Off" )

		for _, ent in pairs( CAKE.ClothingTbl ) do
			if ent.item != "none" then
				main:AddOption( ent.item , function() RunConsoleCommand( "rp_takeoffitem", ent.item, ent.itemid ) end)
			end
		end
		dmenu:Open()
		main:AddOption("Take Off Everything", function() RunConsoleCommand( "rp_takeoffallclothing") end)
	end)

end