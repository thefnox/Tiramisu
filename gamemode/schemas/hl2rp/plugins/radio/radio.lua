--This is a demonstration on how you can override things from the global schema. Because this gets called before the whole global schema has been loaded, the default radio function used on the chat plugin will be  overriden, with this.
CAKE.ChatCommand( "/radio", function( ply, text )

	local players = player.GetAll()
	local heardit = {}
	local group = CAKE.GetCharField( ply, "group" )
	local color = CAKE.GetGroupFlag( group, "radiocolor" ) or Color( 255, 255, 255 )

	if !ply:IsCharLoaded() then return "" end
	if !CAKE.GroupExists( group ) then return "" end

	for _, target in pairs(player.GetAll()) do
		if target:IsCharLoaded() then
			if( CAKE.GetCharField( target, "group" ) == group or CAKE.GetGroupFlag( CAKE.GetCharField( target, "group" ), "radiogroup" ) == CAKE.GetGroupFlag( group, "radiogroup" ) ) then
				datastream.StreamToClients( target, "TiramisuAddToRadio", {
					["text"] = "<color=white>[RADIO]</color><color=" .. tostring( color.r ) .. "," .. tostring( color.b ) .. "," .. tostring( color.g ) .. ">" .. ply:Nick() .. "</color><color=white>: " .. text .. "</color>" 
				})
				table.insert(heardit, target)
			end
		end
	end

	for k, v in pairs(players) do
		
		if(!table.HasValue(heardit, v)) then
		
			local range = CAKE.ConVars[ "TalkRange" ]
			
			if( v:EyePos( ):Distance( ply:EyePos( ) ) <= range ) then
			
				CAKE.SendChat( v, ply:Nick() .. ": " .. text, "ChatFont", "IC" )
				
			end
			
		end
		
	end
	
	return ""

end)
