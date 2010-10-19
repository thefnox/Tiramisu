CLPLUGIN.Name = "Semantics"
CLPLUGIN.Author = "F-Nox/Big Bang"

usermessage.Hook( "TiramisuSemanticsGesture", function( um )

	--LocalPlayer():AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, LocalPlayer():LookupSequence( um:ReadString() ))
	LocalPlayer():RestartGesture( LocalPlayer():LookupSequence( um:ReadString() ) )

end)

function CLPLUGIN.Init()
	
end