-- Set Title
function ccSetTitle( ply, cmd, args )

	local title = table.concat( args, " " )

	CAKE.SetCharField( ply, "title", title );
	ply:SetNWString("title", title);
	
	return;
	
end
concommand.Add( "rp_title", ccSetTitle );

-- Change IC Name
function ccChangeName( ply, cmd, args )

	local name = table.concat( args, " " )
	CAKE.SetCharField(ply, "name", name );
	ply:SetNWString("name", name);
	
end
concommand.Add( "rp_changename", ccChangeName );

function ccGiveMoney( ply, cmd, args )
	
	if( player.GetByID( args[ 1 ] ) != nil ) then
	
		local target = player.GetByID( args[ 1 ] );
		
		if( tonumber( args[ 2 ] ) > 0 ) then
		
			if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= tonumber( args[ 2 ] ) ) then
			
				CAKE.ChangeMoney( target, args[ 2 ] );
				CAKE.ChangeMoney( ply, 0 - args[ 2 ] );
				CAKE.SendChat( ply, "You gave " .. target:Nick( ) .. " " .. args[ 2 ] .. " credits!" );
				CAKE.SendChat( target, ply:Nick( ) .. " gave you " .. args[ 2 ] .. " credits!" );
				
			else
			
				CAKE.SendChat( ply, "You do not have that many tokens!" );
				
			end
			
		else
		
			CAKE.SendChat( ply, "Invalid amount of money!" );
			
		end
		
	else
	
		CAKE.SendChat( ply, "Target not found!" );
		
	end
	
end
concommand.Add( "rp_givemoney", ccGiveMoney );	

local function ccKnockOut( ply, cmd, args )

	CAKE.UnconciousMode( ply )
	
end
concommand.Add( "rp_passout", ccKnockOut )

local function ccWakeUp( ply, cmd, args )

	if ply:GetNWBool( "unconciousmode", false ) then
		CAKE.UnconciousMode( ply )
	end

end
concommand.Add( "rp_wakeup", ccWakeUp )