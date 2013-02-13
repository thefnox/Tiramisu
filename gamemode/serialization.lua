include("glon.lua") // include glon
include("honsolo.lua") // include HON

CAKE._Serialization = false

local function hondeserialize(str)
	
	RunString("z = " .. str)
	local tbl = table.Copy(z)
	z = nil
	return tbl
	
end

function CAKE.Serialize(tbl)
	
	return honsolo.encode(tbl)
	
end

function CAKE.Deserialize(str)
	
	if string.sub(str, 1, 1) != "{" then
		
		CAKE._Serialization = true
		return glon.decode(str)
		
	else
		
		CAKE._Serialization = false
		return hondeserialize(str)
		
	end
	
end

function CAKE.SerializeFile(filename, tbl)
	
	file.Write(filename, CAKE.Serialize(tbl))
	
end

function CAKE.DeserializeFile(filename)
	
	local filec = file.Read(filename, "DATA")
	local tbl = CAKE.Deserialize(filec)
	
	if CAKE._Serialization then // ok so the file uses glon
		
		MsgC(Color(255, 0, 0), "Fixing file: " .. filename .. "\n")
		file.Write(filename, CAKE.Serialize(tbl))
		
	end
	
	return tbl
	
end