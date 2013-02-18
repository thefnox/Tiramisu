include("glon.lua") // include glon
include("honsolo.lua") // include HON

CAKE._Serialization = {}

local function hondeserialize(str)
	CAKE._Serialization = {}
	RunString("CAKE._Serialization = " .. str)
	return CAKE._Serialization
	
end

function CAKE.Serialize(tbl)
	
	return honsolo.encode(tbl)
	
end

function CAKE.Deserialize(str)
	
	if string.sub(str, 1, 1) != "{" then
		
		return glon.decode(str), true
		
	else
		return hondeserialize(str), false
		
	end
	
end

function CAKE.SerializeFile(filename, tbl)
	
	file.Write(filename, CAKE.Serialize(tbl))
	
end

function CAKE.DeserializeFile(filename)
	
	local filec = file.Read(filename, "DATA")
	local tbl, serialized = CAKE.Deserialize(filec)
	
	if serialized then // ok so the file uses glon
		
		MsgC(Color(255, 0, 0), "Fixing file: " .. filename .. "\n")
		file.Write(filename, CAKE.Serialize(tbl))
		
	end
	
	return tbl
	
end