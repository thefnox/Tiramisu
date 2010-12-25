PLUGIN.Name = "Semantics"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles word and grammar detection"; -- The description or purpose of the plugin

CAKE.MaleGestures = {
	["shrugs;"] = "&sequence:G_what;models/Gustavio/maleanimtree.mdl"
}

CAKE.FemaleGestures = {
	["shrugs;"] = "&sequence:G_what;models/Gustavio/maleanimtree.mdl"
}

local speakgestures = {}

function CAKE.RunGesture( ply, id )
	
	
	local sequence = HandleSequence( ply, id )
	print( id )
	print( tostring( sequence ) )
	ply:SetNWString( "CustomGesture", id )
	ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence( "G_what" ) )
	ply:ResetSequence( ply:LookupSequence( "G_what" ) )
	
end

function CAKE.DetectGesture( ply, str )

	local exp
	local conditionmet = false
	local gesture
	
	if ply:GetGender() == "Female" then
		gesture = CAKE.FemaleGestures
	else
		gesture = CAKE.MaleGestures
	end
	
	for id,value in pairs( gesture ) do
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
			CAKE.RunGesture( ply, value )
			break
		end
	end

end

function PLUGIN.Init()
	
end