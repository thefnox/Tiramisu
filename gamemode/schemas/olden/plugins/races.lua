PLUGIN.Name = "Race Loadouts"; -- What is the plugin name
PLUGIN.Author = "FNox"; -- Author of the plugin
PLUGIN.Description = "Controls what items do races get"; -- The description or purpose of the plugin

local RaceLoadout = {}
RaceLoadout[ "Kazuth" ] = {
	"gear_kazuthtail",
	"gear_kazuthear"
}
RaceLoadout[ "Aasimar" ] = {
	"gear_angelwing",
	"gear_angelwing_down"
}
RaceLoadout[ "Tiefling" ] = {
	"gear_demonwing",
	"gear_demonwing_down",
	"gear_horn1",
	"gear_horn2",
	"gear_horn3",
	"gear_tieflingtail"
}


local function GiveRaceLoadout( ply )
	local race = CAKE.GetCharField( ply, "race" )
	if RaceLoadout[ race ] then
		for k, v in pairs( RaceLoadout[ race ] ) do
			if !ply:HasItem( v ) then
				ply:GiveItem( v )
			end
		end
	end
end
hook.Add( "PlayerLoadout", "OldenRaceLoadout", GiveRaceLoadout )

function PLUGIN.Init()
	
end