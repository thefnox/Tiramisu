CAKE.ClockStarted = false


function CAKE.ReferenceFix(data)

	if(type(data) == "table") then
	
		return table.Copy(data);
		
	else
	
		return data;
		
	end
	
end

function CAKE.NilFix(val, default)

	if(val == nil) then
	
		return default;
	
	else
	
		return val;
		
	end
	
end

function CAKE.FindPlayer(name)

	local ply = nil;
	local count = 0;
	
	for k, v in pairs(player.GetAll()) do
	
		if(string.find(v:Nick(), name) != nil) then
			
			ply = v;
				
		end
			
		if(string.find(v:Name(), name) != nil) then
			
			ply = v;
				
		end

		if( string.find(v:SteamID(), name) != nil ) then
		
			ply = v;
			
		end	
	end
	
	return ply;
	
end

function CAKE.GetCharSignature( ply )
	return ply:Nick() .. "@" .. ply:SteamID()
end

function CAKE.SignatureToPlayer( signature )

	local exp = string.Explode( signature, "@" )
	local ply = CAKE:FindPlayer( exp[2] )
	if ply then
		return ply
	end

	return false

end