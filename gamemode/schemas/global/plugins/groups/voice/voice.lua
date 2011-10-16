PLUGIN.Name = "Player Voices"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "Enables players to say things"; -- The description or purpose of the plugin

CAKE.Voices = { }; -- I hear voices D:>

function ccVoice( ply, cmd, args ) -- People near you will hear the voice

	local id = args[ 1 ];
	
	if( CAKE.Voices[ id ] == nil ) then

		CAKE.SendConsole( ply, "This sound does not exist. Use rp_listvoices" );
		return;
		
	end

	local voice = CAKE.Voices[ id ];
	
	if( CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "soundgroup" ) and CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "soundgroup" ) == voice.soundgroup ) then
		
		local path = voice.path;
		
		if((string.find(string.lower(ply:GetModel()), "female") or string.lower(ply:GetModel()) == "models/alyx.mdl") and voice.femalealt != "") then
			path = voice.femalealt;
		end
			
		util.PrecacheSound( path );
		ply:EmitSound( path );
		ply:ConCommand( "say " .. voice.line .. "\n" );
		
	end
	
end
concommand.Add( "rp_voice", ccVoice );

function ccListVoice( ply, cmd, args ) -- LIST DA FUKKEN VOICES

	CAKE.SendConsole( ply, "---List of CakeScript Voices---" );
	CAKE.SendConsole( ply, "Please note, these are only for your current flag" );
	
	for _, voice in pairs(CAKE.Voices) do

		if( CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "soundgroup" ) and CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "soundgroup" ) == voice.soundgroup ) then
		
			CAKE.SendConsole( ply, _ .. " - " .. voice.line .. " - " .. voice.path );
			
		end
		
	end
	
end
concommand.Add( "rp_listvoices", ccListVoice );

function CAKE.AddVoice( id, path, soundgroup, text, fa) -- Registers a voice command. FA is the female alternative to the voice.

	local voice = { };
	voice.path = path;
	voice.soundgroup = CAKE.NilFix(soundgroup, 0);
	voice.line = CAKE.NilFix(text, "");
	voice.femalealt = CAKE.NilFix(fa, "");
	
	CAKE.Voices[ id ] = voice;
	
end
