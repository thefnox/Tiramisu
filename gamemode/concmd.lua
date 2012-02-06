--Removing the cleanup command.
concommand.Remove( "gmod_admin_cleanup" )
concommand.Add( "gmod_admin_cleanup", function( ply, cmd, args )
	-- Thanks SirMasterCombat
	print("Cannot use cleanup in this gamemode!")
end)


-- Set Title
concommand.Add( "rp_title", function( ply, cmd, args )

	local title = table.concat( args, " " )

	CAKE.SetCharField( ply, "title", title )
	ply:SetNWString("title", title)

end)

--Set Name
concommand.Add( "rp_changename", function( ply, cmd, args )

	local name = table.concat( args, " " )
	local oldsig = CAKE.GetCharSignature( ply )
	local group = CAKE.GetCharField( ply, "group" )

	CAKE.SetCharField(ply, "name", name )
	ply:SetNWString("name", name)

	--Changes the name within the group too
	if CAKE.ChangeMemberName then
		CAKE.ChangeMemberName( group, ply, oldsig )
	end

end)

--Give Money
concommand.Add( "rp_givemoney", function( ply, cmd, args )

	if( player.GetByID( args[ 1 ] ) != nil ) then
	
		local target = player.GetByID( args[ 1 ] )
		
		if( tonumber( args[ 2 ] ) > 0 ) then
		
			if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= tonumber( args[ 2 ] ) ) then
			
				CAKE.ChangeMoney( target, args[ 2 ] )
				CAKE.ChangeMoney( ply, 0 - args[ 2 ] )
				CAKE.SendChat( ply, "You gave " .. target:Nick( ) .. " " .. args[ 2 ] .. " credits!" )
				CAKE.SendChat( target, ply:Nick( ) .. " gave you " .. args[ 2 ] .. " credits!" )
				
			else
			
				CAKE.SendChat( ply, "You do not have that many tokens!" )
				
			end
			
		else
		
			CAKE.SendChat( ply, "Invalid amount of money!" )
			
		end
		
	else
	
		CAKE.SendChat( ply, "Target not found!" )
		
	end
	
end)	

--Makes you fall unconcious.
concommand.Add( "rp_passout", function( ply, cmd, args )
	CAKE.UnconciousMode( ply )
end)

--Makes you wake up if unconcious.
concommand.Add( "rp_wakeup", function( ply, cmd, args )

	if ply:GetNWBool( "unconciousmode", false ) then
		CAKE.UnconciousMode( ply )
	end

end)

--Selects a weapon.
concommand.Add( "rp_selectweapon", function( ply, cmd, args )
	if ply:HasWeapon(args[1]) then
		ply:SelectWeapon(args[1])
		ply:HideActiveWeapon()
	end
end)

--Renames an item.
concommand.Add( "rp_renameitem", function( ply, cmd, args )
	if ply:HasItemID( args[1] ) and !CAKE.GetUData( args[2], "uniquename" ) then
		CAKE.SetUData( args[1], "name", args[2])
		ply:RefreshInventory( )
	elseif CAKE.GetUData( args[2], "uniquename" ) then
		CAKE.SendError( ply, "You cannot rename that item!" )
	end
end)

concommand.Add( "test_viewmodel", function( ply, cmd, args)
	local model = CAKE.GetUData( CAKE.GetCharField( ply, "clothingid" ), "model") or CAKE.ItemData[ CAKE.GetCharField( ply, "clothing" ) ].Model or ply:GetModel()
	ply.ViewModelTest = ents.Create( "player_viewmodel" )
	ply.ViewModelTest:SetModel( model )
	ply.ViewModelTest:SetParent( ply:GetViewModel() )
	if ValidEntity( ply.ViewModelTest:GetPhysicsObject( ) ) then
		ply.ViewModelTest:GetPhysicsObject( ):EnableCollisions( false )
	end
	ply.ViewModelTest:Spawn()
end)