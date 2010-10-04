PLUGIN.Name = "Real Life RP Faction Templates"; -- What is the pugin name
PLUGIN.Author = "F-Nox/Big Bang"; -- Author of the plugin
PLUGIN.Description = "A collection of faction making functions."; -- The description or purpose of the plugin

function PLUGIN.Init( )
	
end

function CAKE.DefoTeam()
	local team = CAKE.TeamObject();
	
	team.name = "Citizen"
	team.color = Color(0, 255, 0, 255)
	team.model_path = ""
	team.default_model = false
	team.partial_model = false
	team.weapons = {}
	team.flag_key = "citizen"
	team.door_groups = { }
	team.radio_groups =  { }
	team.sound_groups = { 1 }
	team.item_groups = { }
	team.salary =  25
	team.public =  true
	team.business = false
	team.broadcast = false
	team.iscombine = false
	
	return team;
end

function CAKE.RLRPFaction( name, founder, ranks, flags, doorgroup, image )

	local tbl = {
	[ "Name" ]		= name,
	[ "Type" ]		= "faction",
	[ "Founder" ]	= founder,
	[ "Members" ]	= {},
	[ "Inventory" ]	= {},
	[ "Flags" ]		= flags,
	[ "Ranks" ]		= ranks,
	[ "Image" ]		= image,
	}
	
	local doorgroups = {
		["doorgroups"] = doorgroup
	}
	table.Merge( flags, doorgroups )
	
	CAKE.CreateGroup( name, tbl )
	
end