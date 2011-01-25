	-- Utils
		
	local function FixSlashes( str )
		return str:gsub( "\\" , "/" )
	end

	-- Globals

	TRANSFER_QUEUE = {}
		
	if SERVER then
		-- Client resources
		-- Server includes

		include( "sn3_base_sv.lua" )

		-- sourcenet3

		HookNetChannel( { name = "CNetChan::ProcessPacket" } )

		local history = { begin = {}, finish = {} }

		local function ValidTransferFile( filename )
			for k, v in pairs( TRANSFER_QUEUE ) do
				if ( v.name == filename ) then
					return true
				end
			end
			
			return false
		end

		local function RemoveBZ2( str )
			local ext = string.GetExtensionFromFilename( str )
			
			if ( ext == "bz2" ) then
				return string.sub( str, 1, string.len( str ) - 4 )
			else
				return str
			end
		end
		
		local function CompareAddress( a, b )
			return a:GetIP() == b:GetIP() && a:GetPort() == b:GetPort()
		end
		
		local function HistoryExists( t, adr, name )
			for k, v in pairs( t ) do
				if ( CompareAddress( v.adr, adr ) ) then
					if ( v.name == name ) then
						return true
					end
				end
			end
			
			return false
		end
		
		local function AddHistory( t, adr, name )
			table.insert( t, { adr = adr, name = name } )
		end
		
		local function ClearHistory( t, adr )
			for k, v in pairs( t ) do
				if ( CompareAddress( v.adr, adr ) ) then
					t[k] = nil
				end
			end
		end

		local function PlayerFromChannel( netchan )
			for k, v in pairs( player.GetAll() ) do
				if ( v:IPAddress() == netchan:GetAddress():ToString() ) then
					return v
				end
			end
		end

		local function FileStreamNotification( notice, netchan, filename )
			local ply = PlayerFromChannel( netchan )
							
			if ( ply ) then
				umsg.Start( notice, ply )
					umsg.String( RemoveBZ2( filename ) )
				umsg.End()
			end	
		end

		local function FileStreamBegin( netchan, filename, id )
			if ( !HistoryExists( history.begin, netchan:GetAddress(), filename ) ) then
				hook.Call( "FileStreamBegin", nil, netchan, filename, id )

				FileStreamNotification( "resourcex_filestreambegin", netchan, filename )

				AddHistory( history.begin, netchan:GetAddress(), filename )
			end
		end

		local function FileStreamFinish( netchan, filename, id )
			if ( !HistoryExists( history.finish, netchan:GetAddress(), filename ) ) then
				hook.Call( "FileStreamFinish", nil, netchan, filename, id )
				
				FileStreamNotification( "resourcex_filestreamfinish", netchan, filename )

				AddHistory( history.finish, netchan:GetAddress(), filename )
			end
		end

		hook.Add( "PreProcessPacket", "TransferStatus", function( netchan )
			netchan:SetBackgroundMode( false )

			for i = 0, MAX_STREAMS - 1 do
				for j = 0, netchan:GetOutgoingQueueSize( i ) - 1 do
					local fragments = netchan:GetOutgoingQueueFragments( i, j )
					local filename = fragments:GetFileName()

					if ( filename != "" && ValidTransferFile( filename ) ) then
						local id = fragments:GetFileTransferID()

						if ( fragments:GetProgress() == 0 && fragments:GetNum() > 0 ) then
							FileStreamBegin( netchan, filename, id )
						end
						
						if ( fragments:GetProgress() + fragments:GetNum() >= fragments:GetTotal() ) then
							FileStreamFinish( netchan, filename, id )						
						end
					end
				end
			end
		end )

		hook.Add( "PreNetChannelShutdown", "ClearHistory", function( netchan )
			ClearHistory( history.begin, netchan:GetAddress() )
			ClearHistory( history.finish, netchan:GetAddress() )
		end )

		-- server->client

		TRANSFER_ID = 10000

		local function QueueFile( netchan, filename )
			if ( netchan:SendFile( filename, TRANSFER_ID ) ) then
				TRANSFER_ID = TRANSFER_ID + 1
			end
		end

		-- Stream handshake

		concommand.Add( "resourcex_requestfiles", function( ply, cmd, args )
			if ( !ValidEntity( ply ) ) then return end
			if ( ply.RequestedFiles ) then return end

			local netchan = CNetChan( ply:EntIndex() )
			
			if ( !netchan ) then return end

			ply.RequestedFiles = true

			for k, v in pairs( TRANSFER_QUEUE ) do
				umsg.Start( "resourcex_offerfile", ply )
					umsg.String( RemoveBZ2( v.name ) )
					umsg.Bool( v.display )
				umsg.End()
				
				--print( "[ResourceX] Offered client '" .. v.name .. "' (display=" .. tostring(v.display) .. ")" )
			end
		end )

		concommand.Add( "resourcex_acceptfile", function( ply, cmd, args )
			if ( !ValidEntity( ply ) ) then return end
			if ( !args[1] ) then return end
			
			local netchan = CNetChan( ply:EntIndex() )
			
			if ( !netchan ) then return end

			netchan:SetBackgroundMode( false )

			if ( ValidTransferFile( args[1] ) ) then
				QueueFile( netchan, args[1] )
				
				--print( "[ResourceX] Client accepted '" .. args[1] .. "'" )
			end
		end )
		
		-- Resource hacks

		concommand.Add( "resourcex_reloadmodel", function( ply, cmd, args )
			if ( !ValidEntity( ply ) ) then return end
			if ( #args < 2 ) then return end
			
			local mdl = FixSlashes( args[1] )
			local pid = tonumber( args[2] )
			
			if ( !ValidTransferFile( mdl ) ) then return end
			
			ply.ReloadedModels = ply.ReloadedModels || {}
			
			if ( table.HasValue( ply.ReloadedModels, mdl ) ) then return end
			
			table.insert( ply.ReloadedModels, mdl )

			for k, v in pairs( ents.GetAll() ) do
				local emdl = v:GetModel()

				if ( emdl ) then
					if ( string.lower( FixSlashes( emdl ) ) == mdl ) then
						umsg.Start( "resourcex_reloadmodel", ply )
							umsg.Entity( v )
							umsg.Short( pid )
						umsg.End()
					end
				end
			end
		end )

		-- Interface

		resourcex = {}

		function resourcex.AddSingleFile( name, display )
			if ( display == nil ) then
				display = true
			end

			name = string.lower( FixSlashes( name ) )

			if ( file.Exists( name .. ".bz2", true ) ) then
				name = name .. ".bz2"
			end

			if ( file.Size( "../" .. name ) <= ( GetConVarNumber( "net_maxfilesize" ) * 2^20 ) ) then			
				if ( file.Exists( name, true ) ) then
					if ( !ValidTransferFile( name ) ) then
						table.insert( TRANSFER_QUEUE, { name = name, display = display } )
						
						print( "[ResourceX] Added '" .. name .. "' to resource queue" )
					end
				else
					print( "[ResourceX] File '" .. name .. "' doesn't exist" )
				end
			else
				print( "[ResourceX] File '" .. name .. "' exceeds net_maxfilesize" )
			end
		end

		function resourcex.AddFile( name, display )
			local ext = string.lower( string.GetExtensionFromFilename( name ) )
			local raw = string.sub( name, 1, string.len( name ) - 3 )

			if ( ext == "mdl" ) then
				resourcex.AddSingleFile( raw .. "vvd", display )
				resourcex.AddSingleFile( raw .. "ani", display )
				resourcex.AddSingleFile( raw .. "dx80.vtx", display )
				resourcex.AddSingleFile( raw .. "dx90.vtx", display )
				resourcex.AddSingleFile( raw .. "sw.vtx", display )
				resourcex.AddSingleFile( raw .. "phy", display )
				resourcex.AddSingleFile( raw .. "jpg", display )
			elseif ( ext == "vmt" ) then
				resourcex.AddSingleFile( raw .. "vtf", display )
			end

			resourcex.AddSingleFile( name, display )
		end
	else
		-- Resource hacks

		-- Models

		MODEL_POOL = {}

		local function FormatModelPath( path )
			path = FixSlashes( path )
		
			if ( table.HasValue( MODEL_POOL, path ) ) then
				path = path .. "."
			end
			
			return path
		end

		Entity_SetModel = _R.Entity.SetModel

		function _R.Entity:SetModel( mdl )
			return Entity_SetModel( self, FormatModelPath( mdl ) )
		end
		
		usermessage.Hook( "resourcex_reloadmodel", function( um )
			local ent = um:ReadEntity()
			
			if ( !ValidEntity( ent ) ) then return end

			local mdl = MODEL_POOL[um:ReadShort()]
			
			if ( !mdl ) then return end

			print( "[ResourceX] Setting " .. tostring(ent) .. "'s model to '" .. mdl .. "'" )
			
			ent:SetModel( mdl )
		end )

		-- Sounds
		
		SOUND_LIST = {}

		local function FormatSoundPath( path )
			path = FixSlashes( path )

			if ( table.HasValue( SOUND_LIST, "sound/" .. path ) ) then
				path = "../sound/" .. path
			end
			
			return path
		end

		Entity_EmitSound = _R.Entity.EmitSound

		function _R.Entity:EmitSound( path, volume, pitch )		
			return Entity_EmitSound( self, FormatSoundPath( path ), volume, pitch )
		end
		
		surface_PlaySound = surface.PlaySound
		
		function surface.PlaySound( path )
			return surface_PlaySound( FormatSoundPath( path ) )
		end
		
		_G_WorldSound = WorldSound
		
		function WorldSound( path, origin, amplitude, pitch )
			return _G_WorldSound( FormatSoundPath( path ), origin, amplitude, pitch )
		end
		
		SOUND_PATCHES = {}

		local function InvalidSoundPatch( patch )
			for k, v in pairs( SOUND_PATCHES ) do
				if ( v.patch == patch ) then
					return k
				end
			end
		end
		
		local function ValidSoundPath( path )
			local ext = string.GetExtensionFromFilename( path )

			return ext == "mp3" || ext == "wav"
		end

		local function ValidSoundFile( path )
			if ( ValidSoundPath( path ) ) then
				if ( file.Exists( "sound/" .. path, true ) ) then
					return true
				end
			end
			
			return false
		end
		
		_G_CreateSound = CreateSound
		
		function CreateSound( ent, path )
			path = FormatSoundPath( path )

			local patch = _G_CreateSound( ent, path )

			if ( ValidSoundPath( path ) ) then
				if ( !file.Exists( "sound/" .. path, true ) ) then
					table.insert( SOUND_PATCHES, { patch = patch, path = path, ent = ent } )
				end
			end

			return patch
		end

		CSoundPatch_ChangePitch = _R.CSoundPatch.ChangePitch
		
		function _R.CSoundPatch:ChangePitch( pitch )
			local k = InvalidSoundPatch( self )

			if ( k ) then
				if ( !SOUND_PATCHES[k].new ) then
					SOUND_PATCHES[k].pitch = pitch
					
					return
				end
				
				self = SOUND_PATCHES[k].new
			end

			return CSoundPatch_ChangePitch( self, pitch )
		end
		
		CSoundPatch_ChangeVolume = _R.CSoundPatch.ChangeVolume
		
		function _R.CSoundPatch:ChangeVolume( volume )
			local k = InvalidSoundPatch( self )

			if ( k ) then
				if ( !SOUND_PATCHES[k].new ) then
					SOUND_PATCHES[k].volume = volume
					
					return
				end
				
				self = SOUND_PATCHES[k].new
			end

			return CSoundPatch_ChangeVolume( self, volume )
		end

		CSoundPatch_FadeOut = _R.CSoundPatch.FadeOut
		
		function _R.CSoundPatch:FadeOut( seconds )
			local k = InvalidSoundPatch( self )

			if ( k ) then
				if ( !SOUND_PATCHES[k].new ) then
					return
				end
			
				self = SOUND_PATCHES[k].new
			end
			
			return CSoundPatch_FadeOut( self, seconds )
		end

		CSoundPatch_Stop = _R.CSoundPatch.Stop

		function _R.CSoundPatch:Stop()
			local k = InvalidSoundPatch( self )

			if ( k ) then
				if ( !SOUND_PATCHES[k].new ) then
					return
				end
			
				self = SOUND_PATCHES[k].new
			end
			
			return CSoundPatch_Stop( self )
		end

		CSoundPatch_Play = _R.CSoundPatch.Play
		
		function _R.CSoundPatch:Play()
			local k = InvalidSoundPatch( self )

			if ( k ) then
				if ( !ValidSoundFile( SOUND_PATCHES[k].path ) ) then
					return
				end

				if ( !SOUND_PATCHES[k].new ) then
					SOUND_PATCHES[k].new = _G_CreateSound( SOUND_PATCHES[k].ent, SOUND_PATCHES[k].path )

					if ( SOUND_PATCHES[k].pitch ) then
						CSoundPatch_ChangePitch( self, SOUND_PATCHES[k].pitch )
					end
						
					if ( SOUND_PATCHES[k].volume ) then
						CSoundPatch_ChangeVolume( self, SOUND_PATCHES[k].volume )
					end
						
					if ( SOUND_PATCHES[k].soundlevel ) then
						CSoundPatch_SetSoundLevel( self, SOUND_PATCHES[k].soundlevel )
					end
				end
					
				self = SOUND_PATCHES[k].new
			end
			
			return CSoundPatch_Play( self )
		end
		
		CSoundPatch_PlayEx = _R.CSoundPatch.PlayEx
		
		function _R.CSoundPatch:PlayEx( volume, pitch )
			local k = InvalidSoundPatch( self )

			if ( k ) then
				if ( !ValidSoundFile( SOUND_PATCHES[k].path ) ) then
					return
				end

				if ( !SOUND_PATCHES[k].new ) then
					SOUND_PATCHES[k].new = _G_CreateSound( SOUND_PATCHES[k].ent, SOUND_PATCHES[k].path )

					CSoundPatch_ChangePitch( self, pitch )
					CSoundPatch_ChangeVolume( self, volume )

					if ( SOUND_PATCHES[k].soundlevel ) then
						CSoundPatch_SetSoundLevel( self, SOUND_PATCHES[k].soundlevel )
					end
				end
					
				self = SOUND_PATCHES[k].new
			end

			return CSoundPatch_PlayEx( self, volume, pitch )
		end

		CSoundPatch_SetSoundLevel = _R.CSoundPatch.SetSoundLevel
		
		function _R.CSoundPatch:SetSoundLevel( soundlevel )
			local k = InvalidSoundPatch( self )

			if ( k ) then
				if ( !SOUND_PATCHES[k].new ) then
					SOUND_PATCHES[k].soundlevel = soundlevel
					
					return
				end
				
				self = SOUND_PATCHES[k].new
			end
			
			return CSoundPatch_SetSoundLevel( self, soundlevel )
		end

		CSoundPatch_IsPlaying = _R.CSoundPatch.IsPlaying
		
		function _R.CSoundPatch:IsPlaying()
			local k = InvalidSoundPatch( self )

			if ( k ) then
				if ( !SOUND_PATCHES[k].new ) then
					return false
				end
				
				self = SOUND_PATCHES[k].new
			end

			return CSoundPatch_IsPlaying( self )
		end

		CSoundPatch__gc = _R.CSoundPatch.__gc
		
		function _R.CSoundPatch:__gc()
			local k = InvalidSoundPatch( self )
			
			if ( k ) then
				table.remove( SOUND_PATCHES, k )
			end
			
			return CSoundPatch__gc( self )
		end
		
		-- Handler

		local function HandleGameResource( name )
			local ext = string.GetExtensionFromFilename( name )

			if ( ext == "mdl" ) then
				local pid = table.insert( MODEL_POOL, name )

				RunConsoleCommand( "resourcex_reloadmodel", name, pid )
			elseif ( ext == "wav" || ext == "mp3" ) then
				table.insert( SOUND_LIST, name )
			end
		end

		-- Stream notifications

		include( "menu/content_downloads.lua" )

		function GetOverlayPanel() end

		usermessage.Hook( "resourcex_filestreambegin", function( um )
			local name = um:ReadString()
			
			for k, v in pairs( TRANSFER_QUEUE ) do
				if ( v.name == name ) then
					print( "[ResourceX] Downloading " .. v.name )
					
					v.start_time = CurTime()
					
					break
				end
			end
			
			hook.Call( "FileStreamBegin", nil, name )
		end )

		usermessage.Hook( "resourcex_filestreamfinish", function( um )
			local name = um:ReadString()

			for k, v in pairs( TRANSFER_QUEUE ) do
				if ( v.name == name ) then
					print( "[ResourceX] Downloaded " .. v.name .. " after " .. math.floor( CurTime() - v.start_time ) .. " seconds" )

					if ( v.display ) then
						UpdatePackageDownloadStatus( v.id, v.name, 255, "success", 0 )
					end
					
					table.remove( TRANSFER_QUEUE, k )
		
					break			
				end
			end

			hook.Call( "FileStreamFinish", nil, name )

			HandleGameResource( name )
		end )
		
		hook.Add( "Think", "UpdateDownloads", function()
			for k, v in pairs( TRANSFER_QUEUE ) do
				if ( v.display ) then
					UpdatePackageDownloadStatus( v.id, v.name, 255, nil, 0 )
				end
			end
		end )

		-- Stream handshake

		TRANSFER_ID = 0

		usermessage.Hook( "resourcex_offerfile", function( um )
			local name = um:ReadString()
			local display = um:ReadBool()

			if ( !file.Exists( name, true ) ) then
				RunConsoleCommand( "resourcex_acceptfile", name )
				
				TRANSFER_ID = TRANSFER_ID + 1

				table.insert( TRANSFER_QUEUE, { id = TRANSFER_ID, name = name, display = display } )
			end
		end )
		
		hook.Add( "InitPostEntity", "ClientReady", function()
			RunConsoleCommand( "resourcex_requestfiles" )
		end )
	end