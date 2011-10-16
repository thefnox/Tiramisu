function PlayLocalSound(data)
	playertoemit = data:ReadString()
	sound = data:ReadString()
	for k,v in pairs(player.GetAll()) do
		if v:Nick() == playertoemit then
			v:EmitSound(sound, 100, 100)
		end
	end
end
usermessage.Hook( "LocalSound", PlayLocalSound)