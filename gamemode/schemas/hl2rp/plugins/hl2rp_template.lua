PLUGIN.Name = "HL2RP Team Templates"; -- What is the pugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "A collection of team making functions."; -- The description or purpose of the plugin

function PLUGIN.Init( )
	
end

function CombineDeath(ply)

	util.PrecacheSound( "npc/metropolice/die2.wav" );
	util.PrecacheSound( "npc/overwatch/radiovoice/lostbiosignalforunit.wav" );
	
	ply:EmitSound( "npc/metropolice/die2.wav" );
	local function EmitThatShit()
		ply:EmitSound("npc/overwatch/radiovoice/lostbiosignalforunit.wav");
	end
	timer.Simple(3, EmitThatShit);

end

function CAKE.HL2Team(name, color, model_path, default_model, partial_model, weapons, flag_key, door_groups, radio_groups, sound_groups, item_groups, salary, public, business, broadcast, iscombine)

	local team = CAKE.TeamObject();
	
	team.name = CAKE.NilFix(name, "Citizen");
	team.color = CAKE.NilFix(color, Color(0, 255, 0, 255));
	team.model_path = CAKE.NilFix(model_path, "");
	team.default_model = CAKE.NilFix(default_model, false);
	team.partial_model = CAKE.NilFix(partial_model, false);
	team.weapons = CAKE.NilFix(weapons, {});
	team.flag_key = CAKE.NilFix(flag_key, "citizen");
	team.door_groups = CAKE.NilFix(door_groups, { });
	team.radio_groups = CAKE.NilFix(radio_groups, { });
	team.sound_groups = CAKE.NilFix(sound_groups, { 1 });
	team.item_groups = CAKE.NilFix(item_groups, { });
	team.salary = CAKE.NilFix(salary, 25);
	team.public = CAKE.NilFix(public, true);
	team.business = CAKE.NilFix(business, false);
	team.broadcast = CAKE.NilFix(broadcast, false);
	team.iscombine = CAKE.NilFix(iscombine, false);
	
	if(team.iscombine == true) then
	
		CAKE.AddTeamHook("PlayerDeath", team.flag_key .. "_combinedeath", CombineDeath, team.flag_key);
		
	end
	
	return team;
	
end
