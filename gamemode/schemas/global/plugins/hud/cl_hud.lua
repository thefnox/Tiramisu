CLPLUGIN.Name = "Core HUD"
CLPLUGIN.Author = "F-Nox/Big Bang"

hook.Add( "HUDPaint", "TiramisuMessages,Clock and TargetInfo", function()
	derma.SkinHook( "Paint", "DeathMessage" ) --Messages displayed when dead/unconcious
	derma.SkinHook( "Paint", "TiramisuClock" ) --The clock and title display
	derma.SkinHook( "Paint", "TargetInfo" ) 
end)