--Collective alias for gear and clothing items. Basically lets you wear any item with a single command.
concommand.Add( "rp_wearitem", function( ply, cmd, args )
	
	local item = args[1]
	local itemid = args[2]

	if string.match( item, "clothing_" ) then

		TIRA.SetClothing( ply, item, TIRA.GetCharField( ply, "helmet" ), itemid, TIRA.GetCharField( ply, "helmetid" ))
		TIRA.SetCharField( ply, "clothing", item )
		TIRA.SetCharField( ply, "clothingid", itemid )

	elseif string.match( item, "helmet_" ) then

		TIRA.SetClothing( ply, TIRA.GetCharField( ply, "clothing" ), item, TIRA.GetCharField( ply, "clothingid" ), itemid )
		TIRA.SetCharField( ply, "helmet", item )
		TIRA.SetCharField( ply, "helmetid", itemid )

	elseif TIRA.ItemData[ item ].Wearable or TIRA.GetUData( itemid, "wearable")  then

		TIRA.RemoveGearItemID( ply, itemid ) 
		TIRA.HandleGear( ply, item, args[3] or TIRA.ItemData[ item ].Bone or TIRA.GetUData( itemid, "bone") or "head", itemid )
		TIRA.SaveGear( ply )
		TIRA.SendGearToClient( ply )

	end

end)

--Opposite as above. Collective alias for taking off any gear or clothing item.
concommand.Add( "rp_takeoffitem", function( ply, cmd, args )
	
	local item = args[1]
	local itemid = args[2]

	if string.match( item, "clothing_" ) or string.match( item, "helmet_" ) then
		TIRA.RemoveClothingID( ply, itemid )
		TIRA.SendClothingToClient( ply )
	else
		TIRA.RemoveGearItemID( ply, itemid )
		TIRA.SaveGear( ply )
		TIRA.SendGearToClient( ply )
	end

end)

concommand.Add( "rp_takeoffallgear", function( ply, cmd, args )
	TIRA.SetCharField( ply, "gear", {} )
	TIRA.RestoreGear( ply )
end)

concommand.Add( "rp_takeoffallclothing", function( ply, cmd, args )
	TIRA.SetCharField( ply, "clothing", "none" )
	TIRA.SetCharField( ply, "clothingid", "none" )
	TIRA.SetCharField( ply, "helmet", "none" )
	TIRA.SetCharField( ply, "helmetid", "none" )
	TIRA.RestoreClothing( ply )
	TIRA.SendClothingToClient( ply )
end)