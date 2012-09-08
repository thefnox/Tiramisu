TIRA.ClockStarted = false

--Fix for certain tables not loading right.
function TIRA.ReferenceFix(data)

	if(type(data) == "table") then
	
		return table.Copy(data)
		
	else
	
		return data
		
	end
	
end

--If the value provided to it is not valid, then it returns the default.
function TIRA.NilFix(val, default)

	return val or default
	
end

--Fetches a player's character signature.
function TIRA.GetCharSignature( ply )
	return ply:Nick() .. "@" .. ply:SteamID()
end