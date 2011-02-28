PLUGIN.Name = "Real Life RP Faction Templates"; -- What is the pugin name
PLUGIN.Author = "F-Nox/Big Bang"; -- Author of the plugin
PLUGIN.Description = "A collection of faction making functions."; -- The description or purpose of the plugin

function PLUGIN.Init( )
	
end

function CAKE.RLRPFaction( name, founder, ranks, flags, doorgroup, desc )

	if !CAKE.GroupExists( name ) then
		local tbl = {
		[ "Name" ]		= name,
		[ "Type" ]		= "faction",
		[ "Founder" ]	= founder,
		[ "Members" ]	= {},
		[ "Inventory" ]	= {},
		[ "Flags" ]		= flags,
		[ "Ranks" ]		= ranks,
		[ "Description" ] = desc or "None available."
		}
		
		local doorgroups = {
			["doorgroups"] = doorgroup
		}
		table.Merge( flags, doorgroups )
		
		CAKE.CreateGroup( name, tbl )
	end
	
end