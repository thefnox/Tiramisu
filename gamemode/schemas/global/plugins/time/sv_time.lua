/*Ticking away the moments that make up a dull day
You fritter and waste the hours in an offhand way
Kicking around on a piece of ground in your home town
Waiting for someone or something to show you the way

Time - Pink Floyd */


function CAKE.InitTime() -- Load the time from a text file or default value, this occurs on gamemode initialization.

	local clumpedtime = CAKE.DefaultTime
	
	if(file.Exists(CAKE.Name .. "/time.txt")) then
	
		clumpedtime = file.Read(CAKE.Name .. "/time.txt")
		
	else
	
		file.Write(CAKE.Name .. "/time.txt", clumpedtime )
		
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
	
	if CAKE.ClockYear
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
		
		SetGlobalString("time", CAKE.ClockMonth or 1 .. "/" .. CAKE.ClockDay or 1 .. "/" .. CAKE.ClockYear or 2011 .. " - " .. nHours .. ":" .. nMins .. timez)
	end
	
end

hook.Add( "InitPostEntity", "TiramisuInitTime", function()
	CAKE.InitTime()
end)