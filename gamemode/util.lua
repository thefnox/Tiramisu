CAKE.ClockStarted = false

--Fix for certain tables not loading right.
function CAKE.ReferenceFix(data)

	if(type(data) == "table") then
	
		return table.Copy(data);
		
	else
	
		return data;
		
	end
	
end

--If the value provided to it is not valid, then it returns the default.
function CAKE.NilFix(val, default)

	if(val == nil) then
	
		return default;
	
	else
	
		return val;
		
	end
	
end

--Finds a player based on its OOC name, its IC name or its SteamID
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

--Fetches a player's character signature.
function CAKE.GetCharSignature( ply )
	return ply:Nick() .. "@" .. ply:SteamID()
end