-- Anything that would be logged would be passed to this.
function TIRA.DayLog( outputfile, text )

	local month = os.date( "%m" )
	local day = os.date( "%d" )
	local year = os.date( "%Y" )

	local curdate = month .. "-" .. day .. "-" .. year

	local filedir = TIRA.Name .. "/logs/daylogs/" .. curdate .. "/" .. outputfile
	
	local hours = os.date( "%H" )
	local mins = os.date( "%M" )
	local secs = os.date( "%S" )
	
	local curtime = hours .. ":" .. mins .. ":" .. secs
	
	text = string.gsub(text, "\n", "") -- \n fix for all those basteds. >:O
	
	file.Append( filedir,  "\n" .. curtime .. " " .. text )
	
end