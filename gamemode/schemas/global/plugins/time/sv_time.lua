/*Ticking away the moments that make up a dull day
You fritter and waste the hours in an offhand way
Kicking around on a piece of ground in your home town
Waiting for someone or something to show you the way

Time - Pink Floyd */


function TIRA.InitTime() -- Load the time from a text file or default value, this occurs on gamemode initialization.

	local clumpedtime = TIRA.ConVars[ "DefaultTime" ]
	
	if(file.Exists(TIRA.Name .. "/time/" .. TIRA.ConVars[ "Schema" ] .. "/time.txt", "DATA")) then
	
		clumpedtime = file.Read(TIRA.Name .. "/time/" .. TIRA.ConVars[ "Schema" ] .. "/time.txt", "DATA")
		
	else
	
		file.Write(TIRA.Name .. "/time/" .. TIRA.ConVars[ "Schema" ] .. "/time.txt", clumpedtime )
		
	end

	if clumpedtime and clumpedtime != "" then
		local unclumped = string.Explode(" ", clumpedtime)
		TIRA.ClockDay = tonumber(unclumped[1] or 1)
		TIRA.ClockMonth = tonumber(unclumped[2] or 1)
		TIRA.ClockYear = tonumber(unclumped[3] or 2011)
		TIRA.ClockMins = tonumber(unclumped[4] or 1)

	else
		TIRA.ClockDay = 1
		TIRA.ClockMonth = 1
		TIRA.ClockYear = 2011
		TIRA.ClockMins = 1
	end
	
	SetGlobalString("time", "Loading..")

	TIRA.ClockStarted = true
	
end

--Saves time to a file
function TIRA.SaveTime()

	local clumpedtime = TIRA.ClockDay .. " " .. TIRA.ClockMonth .. " " .. TIRA.ClockYear .. " " .. TIRA.ClockMins
	file.Write(TIRA.Name .. "/time/" .. TIRA.ConVars[ "Schema" ] .. "/time.txt", clumpedtime)
	
end

--Sends the time to all clients.
function TIRA.SendTime()
	
	if TIRA.ClockYear then
		local nHours = string.format("%02.f", math.floor(TIRA.ClockMins / 60))
		local nMins = string.format("%02.f", math.floor(TIRA.ClockMins - (nHours*60)))
		
		if(tonumber(nHours) > 12) then 
		
			nHours = nHours - 12
			timez = "PM"
			
		else
		
			timez = "AM"
			
		end
		
		if(tonumber(nHours) == 0) then
		
			nHours = 12
			
		end
		
		if string.sub(tostring(nHours),1,1) == "0" then
			nHours = " " ..string.sub(tostring(nHours), 2, 2)
		end
		if TIRA.ConVars[ "DisplayClock" ] then
			SetGlobalString("time", TIRA.ClockMonth.. "/" .. TIRA.ClockDay .. "/" .. TIRA.ClockYear.. " - " .. nHours .. ":" .. nMins .. timez)
		else
			SetGlobalString("time", "")
		end
	end
	
end

local function AdminSetDate( ply, cmd, args )
	if #args < 3 then
		TIRA.SendConsole(ply, "Invalid number of arguments! ( rp_admin setdate monthnumber daynumber year )")
		return
	end
	TIRA.ClockMonth = math.Clamp( tonumber(args[1]),1, 12)
	TIRA.ClockYear = tonumber( args[3] )
	if TIRA.ClockMonth == 2 then
		if TIRA.IsLeapYear(TIRA.ClockYear) then --It measures ever since the Gregorian calendar was made lol.
			TIRA.ClockDay = math.Clamp( tonumber(args[2]), 1, 29 )
		else
			TIRA.ClockDay = math.Clamp( tonumber(args[2]), 1, 28 )
		end
	else
		TIRA.ClockDay = math.Clamp( tonumber(args[2]), 1, 31 )
	end
	TIRA.SendTime()
	TIRA.SaveTime()
end


function PLUGIN.Init()
	TIRA.InitTime()
	TIRA.AdminCommand( "setdate", AdminSetDate , "Sets the current date (month day year)", true, true, 3 )
end