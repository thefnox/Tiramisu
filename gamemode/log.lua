-- Anything that would be logged would be passed to this.
function CAKE.DayLog( outputfile, text )

	local month = os.date( "%m" );
	local day = os.date( "%d" );
	local year = os.date( "%Y" );

	local curdate = month .. "-" .. day .. "-" .. year;

	local filedir = CAKE.Name .. "/Logs/daylogs/" .. curdate .. "/" .. outputfile;

	local old = CAKE.NilFix(file.Read( filedir ), "");
	
	local hours = os.date( "%H" );
	local mins = os.date( "%M" );
	local secs = os.date( "%S" );
	
	local curtime = hours .. ":" .. mins .. ":" .. secs
	
	text = string.gsub(text, "\n", ""); -- \n fix for all those basteds. >:O
	
	file.Write( filedir, old .. "\n" .. curtime .. " " .. text );
	
end