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

--Finds a player based on its OOC name, its IC name or its SteamID
function CAKE.FindPlayer(name)

	local ply = nil
	local count = 0

	name = name:lower()
	
	for _, ply in pairs(player.GetAll()) do
		if string.lower(ply:Nick()):match(name) or string.lower(ply:Name()):match(name) or string.lower(ply:SteamID()):match(name) or CAKE.FormatText(ply:SteamID()) == name then
			return ply
		end	
	end
	
	return false
	
end

--Fetches a player's character signature.
function CAKE.GetCharSignature( ply )
	return ply:Nick() .. "@" .. ply:SteamID()
end