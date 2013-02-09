-- Anything that would be logged would be passed to this.
function CAKE.DayLog( outputfile, text )

	local month = os.date( "%m" )
	local day = os.date( "%d" )
	local year = os.date( "%Y" )

	local curdate = month .. "-" .. day .. "-" .. year

	local filedir = CAKE.Name .. "/logs/daylogs/" .. curdate .. "/" .. outputfile
	
	local hours = os.date( "%H" )
	local mins = os.date( "%M" )
	local secs = os.date( "%S" )
	
	local curtime = hours .. ":" .. mins .. ":" .. secs
	
	text = string.gsub(text, "\n", "") -- \n fix for all those basteds. >:O
	
	local filecontents = file.Read(filedir, "DATA") or ""
	
	-- file.Append( filedir,  "\n" .. curtime .. " " .. text )
	file.Write( filedir,  filecontents .. "\n" .. curtime .. " " .. text )
	
end

function CAKE.AdminLog(clr, str)

	local tbl = {}

	for k, v in pairs(player.GetAll()) do
		
		if CAKE.PlayerRank(v) >= 4 then
			
			CAKE.SendConsole(v, clr, str)

		end

	end

	-- MsgC(clr, str .. "\n")

end

function CAKE.CombatLog(clr, str)

	CAKE.AdminLog(clr, str)
	CAKE.DayLog("combat.txt", str)

end