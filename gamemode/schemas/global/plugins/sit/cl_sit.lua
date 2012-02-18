CLPLUGIN.Name = "Sitting System"
CLPLUGIN.Author = "F-Nox/Big Bang"

usermessage.Hook( "Tiramisu.Freescroll", function( um )

	local bool = um:ReadBool()

	CAKE.ForceFreeScroll = bool
	CAKE.FreeScroll = bool
	
end)

function CLPLUGIN.Init()
	
end