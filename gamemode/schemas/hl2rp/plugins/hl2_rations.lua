PLUGIN.Name = "HL2 Rations"; -- What is the plugin name
PLUGIN.Author = "Nori"; -- Author of the plugin
PLUGIN.Description = "Combine can drop rations."; -- The description or purpose of the plugin

function RationDrop(ply, text)

	if(CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "iscombine" )) then
	
		CAKE.CreateItem( "ration", ply:CalcDrop( ), Angle( 0,0,0 ) );
		
	else

		CAKE.SendChat(ply, "You cannot drop rations!");
		
	end
	
	return "";
	
end

function Rations_ChangeTeamObject( team )

	team.rations = false;
	
end

function PLUGIN.Init()

	CAKE.ConVars["RationMoney"] = 80; -- How much money does each ration give
	CAKE.AddHook("CreateTeamObject", "rations_teaminit", Rations_ChangeTeamObject); -- Hook into the team object creation so we can give it our variable
	CAKE.ChatCommand("/ration", RationDrop)
	
end