// These functions are intended for developers to debug issues in Tiramisu.

local pMeta = FindMetaTable("Player")

CAKE.Developers = {
		
	"STEAM_0:1:11359814", // FNox
	"STEAM_0:1:36094947" // VorteX

}

function pMeta:IsTiraDeveloper()

	return table.HasValue(CAKE.Developers, self:SteamID())

end

// Some OS's may cause issues.
concommand.Add("tiramisu_debug_getos", function(ply, cmd, args)

	if !IsValid(ply) then return end
	if !ply:IsTiraDeveloper() then return end

	local osstr = "UNKNOWN"

	if system.IsWindows() then
		
		osstr = "Windows"

	elseif system.IsOSX() then
		
		osstr = "Mac OS X"

	elseif system.IsLinux() then

		osstr = "Linux"

	end

	CAKE.SendConsole(ply, "Operating System: " .. osstr)

end)

// Some addons cause conflicts.
concommand.Add("tiramisu_debug_getaddons", function(ply, cmd, args)

	if !IsValid(ply) then return end
	if !ply:IsTiraDeveloper() then return end

	local _, addondirs = file.Find("addons/*", "GAME")
	local workshop, _ = file.Find("addons/*.gm", "GAME")

	CAKE.SendConsole(ply, "Addons:")

	for k, v in pairs(addondirs) do
		
		CAKE.SendConsole(ply, v)

	end
	
	CAKE.SendConsole(ply, "---WORKSHOP---")
	
	for k, v in pairs(workshop) do
		
		CAKE.SendConsole(ply, "")

	end
	
	CAKE.SendConsole(ply, "-----")

end)