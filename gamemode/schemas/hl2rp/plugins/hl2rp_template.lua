PLUGIN.Name = "HL2RP Team Templates"; -- What is the pugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "A collection of team making functions."; -- The description or purpose of the plugin

function PLUGIN.Init( )
	
end

local function CombineDeath(ply, weapon, killer)
	
	if CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "iscombine" ) then
		for k, v in pairs( player.GetAll() ) do
			if CAKE.GetGroupFlag( CAKE.GetCharField( v, "group" ), "iscombine" ) then
				umsg.Start( "AddPingLine" , ply )
					umsg.String( "Lost biosignal for protection team unit " .. ply:Nick() .. "! Dispatch all available units to last location of the unit immediatly." )
					umsg.Short( 255 )
					umsg.Short( 0 )
					umsg.Short( 0 )
				umsg.End()
			end
		end
		util.PrecacheSound( "npc/metropolice/die2.wav" );
		util.PrecacheSound( "npc/overwatch/radiovoice/lostbiosignalforunit.wav" );
		
		ply:EmitSound( "npc/metropolice/die2.wav" );
		local function EmitThatShit()
			ply:EmitSound("npc/overwatch/radiovoice/lostbiosignalforunit.wav");
		end
		timer.Simple(3, EmitThatShit);
		timer.Simple(5, function()
			ply:EmitSound("npc/overwatch/radiovoice/off2.wav");
		end)
	end

end
hook.Add( "PlayerDeath", "HL2RPCombineDeath", CombineDeath )

function CAKE.HL2DefoTeam()
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

function CAKE.HL2RPFaction( name, founder, ranks, flags, doorgroup, buygroups, image, tags )

	local tbl = {
	[ "Name" ]		= name,
	[ "Type" ]		= "faction",
	[ "Founder" ]	= founder,
	[ "Members" ]	= {},
	[ "Inventory" ]	= {},
	[ "Flags" ]		= flags,
	[ "Ranks" ]		= ranks,
	[ "Image" ]		= image,
	[ "Tags" ]		= tags
	}
	
	local doorgroups = {
		["doorgroups"] = doorgroup
	}
	local buygroups = {
		["buygroups"] = buygroups
	}
	table.Merge( flags, doorgroups )
	table.Merge( flags, buygroups )
	
	CAKE.CreateGroup( name, tbl )
	
end