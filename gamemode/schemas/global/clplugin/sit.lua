CLPLUGIN.Name = "Sitting System"
CLPLUGIN.Author = "F-Nox/Big Bang"

usermessage.Hook( "ToggleFreescroll", function( um )

	local bool = um:ReadBool()

	gui.EnableScreenClicker( bool )
	CAKE.ForceFreeScroll = bool
	CAKE.FreeScroll = bool
	
end)

function CLPLUGIN.Init()
	
end