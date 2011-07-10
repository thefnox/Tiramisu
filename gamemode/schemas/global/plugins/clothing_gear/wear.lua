--Collective alias for gear and clothing items. Basically lets you wear any item with a single command.
concommand.Add( "rp_wearitem", function( ply, cmd, args )
	
	local item = args[1]
	local itemid = args[2]

	if string.match( item, "clothing_" ) then

		CAKE.SetClothing( ply, item, CAKE.GetCharField( ply, "helmet" ))
		CAKE.SetCharField( ply, "clothing", item )

	elseif string.match( item, "helmet_" ) then

		CAKE.SetClothing( ply, CAKE.GetCharField( ply, "clothing" ), item )
		CAKE.SetCharField( ply, "helmet", item )

	elseif CAKE.ItemData[ item ].Wearable or CAKE.GetUData( itemid, "wearable")  then

		CAKE.RemoveGearItemID( ply, itemid ) 
		CAKE.HandleGear( ply, item, CAKE.ItemData[ item ].Bone or CAKE.GetUData( itemid, "bone") or "head", itemid )
		CAKE.SaveGear( ply )
		CAKE.SendGearToClient( ply )

	end

end)

--Opposite as above. Collective alias for taking off any gear or clothing item.
concommand.Add( "rp_takeoffitem", function( ply, cmd, args )
	
	local item = args[1]
	local itemid = args[2]

	if string.match( item, "clothing_" ) then

		CAKE.SetClothing( ply, nil, CAKE.GetCharField( ply, "helmet" ) )
		CAKE.SetCharField( ply, "clothing", "none" )

	elseif string.match( item, "helmet_" ) then

		CAKE.RemoveHelmet( ply )
		CAKE.SetCharField( ply, "helmet", "none" )

	else

		CAKE.RemoveGearItemID( ply, itemid )
		CAKE.SaveGear( ply )
		CAKE.SendGearToClient( ply )

	end

end)