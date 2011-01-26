-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- util.lua
-- Contains important server functions.
-------------------------------

CAKE.ClockStarted = false

-- Oh, don't mind me.. just adding a useful function.
function string.explode(str)

	local rets = {};
	
	for i=1, string.len(str) do
	
		rets[i] = string.sub(str, i, i);
		
	end
	
	return rets;

end

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

function CAKE.InitTime() -- Load the time from a text file or default value, this occurs on gamemode initialization.

	local clumpedtime = "1 1 2011 1"
	
	if(file.Exists(CAKE.Name .. "/time.txt")) then
	
		clumpedtime = file.Read(CAKE.Name .. "/time.txt")
		
	else
	
		file.Write(CAKE.Name .. "/time.txt", "1 1 2011 1")
		
	end

	if clumpedtime and clumpedtime != "" then
		local unclumped = string.Explode(" ", clumpedtime)
		CAKE.ClockDay = tonumber(unclumped[1] or 1)
		CAKE.ClockMonth = tonumber(unclumped[2] or 1)
		CAKE.ClockYear = tonumber(unclumped[3] or 2011)
		CAKE.ClockMins = tonumber(unclumped[4] or 1)

	else
		CAKE.ClockDay = 1
		CAKE.ClockMonth = 1
		CAKE.ClockYear = 2011
		CAKE.ClockMins = 1
	end
	
	SetGlobalString("time", "Loading..")

	CAKE.ClockStarted = true
	
end

function CAKE.SaveTime()

	local clumpedtime = CAKE.ClockDay .. " " .. CAKE.ClockMonth .. " " .. CAKE.ClockYear .. " " .. CAKE.ClockMins
	file.Write(CAKE.Name .. "/time.txt", clumpedtime)
	
end

function CAKE.SendTime()

	local nHours = string.format("%02.f", math.floor(CAKE.ClockMins / 60));
	local nMins = string.format("%02.f", math.floor(CAKE.ClockMins - (nHours*60)));
	
	if(tonumber(nHours) > 12) then 
	
		nHours = nHours - 12
		timez = "PM";
		
	else
	
		timez = "AM";
		
	end
	
	if(tonumber(nHours) == 0) then
	
		nHours = 12
		
	end
	
	if string.sub(tostring(nHours),1,1) == "0" then
		nHours = " " ..string.sub(tostring(nHours), 2, 2)
	end
	
	SetGlobalString("time", CAKE.ClockMonth .. "/" .. CAKE.ClockDay .. "/" .. CAKE.ClockYear .. " - " .. nHours .. ":" .. nMins .. timez)
	
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
			
	end
	
	return ply;
	
end

function CAKE.GetCharSignature( ply )
	return ply:Nick() .. CAKE.FormatText(ply:SteamID()) end
