--Makes items
concommand.Add( "rp_turnintoitem", function(ply, cmd, args)
	if !(args[1] and args[2]) then CAKE.SendChat(ply, "Invalid number of arguments!") return end
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ))
	local name = args[2]
	local pickable = util.tobool( args[3] )
	local wearable = util.tobool( args[4] )
	local bone = args[5] or "pelvis"
	if pickable then
		local id = CAKE.CreateItemID()
		CAKE.SetUData(id, "name", name)
		CAKE.SetUData(id, "model", entity:GetModel())
		if wearable then
			CAKE.SetUData(id, "wearable", true )
			CAKE.SetUData(id, "bone", bone)
		end
		CAKE.SetUData(id, "creator", ply:Nick() .. ":" .. ply:Name() .. " (" .. ply:SteamID() .. ")")
		CAKE.CreateItem( "propitem", entity:GetPos(), entity:GetAngles(), id )
		entity:Remove()
	else
		entity:SetNWString( "propdescription", name )
	end
end)

--Makes clothing
concommand.Add( "rp_turnintoclothing", function( ply, cmd, args )
	if !(args[1] and args[2]) then CAKE.SendChat(ply, "Invalid number of arguments!") return end
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ))
	if !entity.ply then
		local type = args[3]
		local name = args[2]
		local id = CAKE.CreateItemID()
		CAKE.SetUData(id, "name", name )
		CAKE.SetUData(id, "creator", ply:Nick() .. ":" .. ply:Name() .. " (" .. ply:SteamID() .. ")")
		CAKE.SetUData(id, "model", entity:GetModel())
		if type == "body" then
			print(util.tobool(args[4]))
			CAKE.SetUData(id, "nogloves", util.tobool(args[4]))
			CAKE.CreateItem( "clothing_base", entity:GetPos(), entity:GetAngles(), id )
			entity:Remove()
		elseif type == "head" then
			CAKE.CreateItem( "helmet_base", entity:GetPos(), entity:GetAngles(), id )
			entity:Remove()
		end
	end
end)