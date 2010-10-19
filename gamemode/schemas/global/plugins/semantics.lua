PLUGIN.Name = "Semantics"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles word and grammar detection"; -- The description or purpose of the plugin

CAKE.Gestures = {
	["shrugs;"] = "g_salute"
}

local speakgestures = {}

function CAKE.RunGesture( ply, id )

	print( "Running gesture " .. tostring(ply:LookupSequence( CAKE.Gestures[id] )))
	
	ply:RestartGesture( ply:LookupSequence( CAKE.Gestures[id] ))
	
	umsg.Start( "TiramisuSemanticsGesture", ply )
		umsg.String( CAKE.Gestures[id] )
	umsg.End()
	
	
end

function CAKE.DetectGesture( ply, str )

	local exp
	local conditionmet = false
	
	for id,lol in pairs( CAKE.Gestures ) do
		exp = string.Explode( ";", id )
		for _,keyword in pairs( exp ) do
			if string.match( string.lower( str ), string.lower( string.gsub( keyword, ";", "" ) )) then
				conditionmet = true
			else
				conditionmet = false
				break
			end
		end
		if conditionmet then
			CAKE.RunGesture( ply, id )
			break
		end
	end

end

function PLUGIN.Init()
	
end