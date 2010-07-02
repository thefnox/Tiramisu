-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- hooks.lua
-- A hook system for plugins and other things.
-------------------------------

CAKE.Hooks = {  };
CAKE.TeamHooks = { };

function CAKE.CallTeamHook( hook_name, ply, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 ) -- Holy shit what a hacky method fo sho.
	
	local team = CAKE.NilFix(CAKE.Teams[ply:Team()], nil);
	if( team == nil ) then

		return; -- Team hasn't even been set yet!
		
	end
	
	-- Look through the Hooks table for any hooks that should be called
	for _, hook in pairs( CAKE.TeamHooks ) do
	
		if( hook.hook_name == hook_name and team.flag_key == hook.flag_key) then
			
			local unique = CAKE.NilFix(hook.unique_name, "");
			local func = CAKE.NilFix(hook.callback, function() end);
			
			CAKE.DayLog( "script.txt", "Running team hook " .. unique );
			
			local override = CAKE.NilFix(func( ply, CAKE.NilFix(arg1, nil), CAKE.NilFix(arg2, nil), CAKE.NilFix(arg3, nil), CAKE.NilFix(arg4, nil), CAKE.NilFix(arg5, nil), CAKE.NilFix(arg6, nil), CAKE.NilFix(arg7, nil), CAKE.NilFix(arg8, nil), CAKE.NilFix(arg9, nil), CAKE.NilFix(arg10, nil)), 1);
			
			if( override == 0 ) then return 0; end
			
		end
		
	end
	
	return 1;
	
end

function CAKE.AddTeamHook( hook_name, unique_name, callback, flagkey )
	
	local hook = {  };
	hook.hook_name = hook_name;
	hook.unique_name = unique_name;
	hook.callback = callback;
	hook.flag_key = flagkey;
	
	table.insert(CAKE.TeamHooks, hook);
	
	CAKE.DayLog( "script.txt", "Adding team hook " .. unique_name .. " ( " .. hook_name .. " | " .. flagkey .. " )" );
	
end

-- This is to be called within CAKE functions
-- It will basically run through a table of hooks and call those functions if it matches the hook name.
-- If the hook returns a value of 0, it will not call any more hooks.
function CAKE.CallHook( hook_name, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 ) -- Holy shit what a hacky method fo sho.
	
	-- Look through the Hooks table for any hooks that should be called
	for _, hook in pairs( CAKE.Hooks ) do
	
		if( hook.hook_name == hook_name ) then
			
			local unique = CAKE.NilFix(hook.unique_name, "");
			local func = CAKE.NilFix(hook.callback, function() end);
			
			CAKE.DayLog( "script.txt", "Running hook " .. unique );
			
			CAKE.NilFix(func( CAKE.NilFix(arg1, nil), CAKE.NilFix(arg2, nil), CAKE.NilFix(arg3, nil), CAKE.NilFix(arg4, nil), CAKE.NilFix(arg5, nil), CAKE.NilFix(arg6, nil), CAKE.NilFix(arg7, nil), CAKE.NilFix(arg8, nil), CAKE.NilFix(arg9, nil), CAKE.NilFix(arg10, nil)), 1);
			
			if( override == 0 ) then return 0; end
			
		end
		
	end
	
	return 1;
	
end

function CAKE.AddHook( hook_name, unique_name, callback )
	
	local hook = {  };
	hook.hook_name = hook_name;
	hook.unique_name = unique_name;
	hook.callback = callback;
	
	table.insert(CAKE.Hooks, hook);
	
	CAKE.DayLog( "script.txt", "Adding hook " .. unique_name .. " ( " .. hook_name .. " )" );
	
end
