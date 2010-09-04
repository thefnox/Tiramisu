PLUGIN.Name = "Model Changer"; -- What is the plugin name
PLUGIN.Author = "Kain"; -- Author of the plugin
PLUGIN.Description = "Allows for easy model-swapping."; -- The description or purpose of the plugin

function ccChangeModel( ply, cmd, args )

	local mdl = tostring(args[ 1 ]);
	local perma = util.tobool(args[2]) or false;
	local special = util.tobool( args[3] ) or false;
	local part = tonumber( args[4] ) or 0;

	
	if perma then
		if !special then
			if part > 0 then
				CAKE.HandleClothing( ply, mdl, part )
				if part == 1 then CAKE.SetCharField( ply, "clothing", mdl )
				elseif part == 2 then CAKE.SetCharField( ply, "helmet", mdl )
				elseif part == 3 then CAKE.SetCharField( ply, "gloves", mdl )
				end
			else
				CAKE.SetCharField( ply, "model", mdl )
				CAKE.SetClothing( ply, "none", "none", "none")
			end
			ply:SetNWBool( "specialmodel", false )
			CAKE.SetCharField( ply, "specialmodel", "none" )
		else
			ply:RemoveClothing()
			ply:SetModel( mdl )
			ply:SetNWBool( "specialmodel", true )
			CAKE.SetCharField( ply, "specialmodel", mdl )
		end
	else
		if !special then
			if part > 0 then
				CAKE.HandleClothing( ply, mdl, part )
			else
				CAKE.SetClothing( ply, mdl, mdl, mdl)
			end
			ply:SetNWBool( "specialmodel", false )
		else
			ply:RemoveClothing()
			ply:SetModel( mdl )
			ply:SetNWBool( "specialmodel", true )
		end
	end
	
end
concommand.Add( "rp_changemodel", ccChangeModel );

function PLUGIN.Init()
end