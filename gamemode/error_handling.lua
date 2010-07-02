-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- error_handling.lua
-- This helps with errors, and catches them before they break the script.
-------------------------------

function ErrorHandler( func, args, ret, errcode )
	
	CAKE.CallHook( "ErrorHandler", func, args, ret, errcode);
	
	local s = func .. "() failed: " .. func .. "(" .. table.concat( args, "," ) .. ") failed with error " .. errcode .. ": " .. CAKE.NilFix(ErrorCodes[errcode], "Invalid Error Code");
	
	CAKE.DayLog( "errors.txt", s);
	print(s);
	
	return ret;
	
end

ErrorCodes = {};

function AddCode(id, text)

	ErrorCodes[id] = text;
	
end

-- Error Codes
AddCode(1, "Attempted to call hook while gamemode is not fully loaded");
AddCode(2, "Hook is missing a unique name");
AddCode(3, "Hook is missing a callback");
AddCode(4, "Could not retrieve player SteamID");
AddCode(5, "Character does not exist");
AddCode(6, "Invalid field");
AddCode(7, "Field not found");
AddCode(8, "Data file corrupted");
