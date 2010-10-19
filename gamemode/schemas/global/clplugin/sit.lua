CLPLUGIN.Name = "Sitting System"
CLPLUGIN.Author = "F-Nox/Big Bang"

usermessage.Hook( "ToggleMouseOnSit", function( um )

	gui.EnableScreenClicker( um:ReadBool() )
	
end)

function CLPLUGIN.Init()
	
end