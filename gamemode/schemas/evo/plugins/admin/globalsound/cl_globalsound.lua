function PlayGlobalSound(data)
	LocalPlayer():EmitSound(data:ReadString())
end
usermessage.Hook( "GlobalSound", PlayGlobalSound )