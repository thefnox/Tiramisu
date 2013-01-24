CAKE.ClockStarted = false

--Fix for certain tables not loading right.
function CAKE.ReferenceFix(data)

	if(type(data) == "table") then
	
		return table.Copy(data)
		
	else
	
		return data
		
	end
	
end

--If the value provided to it is not valid, then it returns the default.
function CAKE.NilFix(val, default)

	return val or default
	
end

--Fetches a player's character signature.
function CAKE.GetCharSignature( ply )
	return ply:Nick() .. "@" .. ply:SteamID()
end