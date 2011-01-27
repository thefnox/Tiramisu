--CHRISASTER MADE THIS AND FOR THAT WE'RE ETERNALLY GRATEFUL

require("sourcenet3")

	NET_CHANNELS = {}
	NET_HOOKS = NET_HOOKS || { attach = {}, detach = {} }

	function HookNetChannel( ... )
		for k, v in pairs( { ... } ) do
			local name = v.name:gsub( "::", "_" )

			local exists = false
			
			for k, v in pairs( NET_HOOKS.attach ) do	
				if ( v.name == name ) then
					exists = true
					
					break
				end
			end
			
			if ( !exists ) then
				table.insert( NET_HOOKS.attach, { name = name, hook = _G[ "Attach__" .. name ], func = v.func, args = v.args, nochan = v.nochan } )
				table.insert( NET_HOOKS.detach, { name = name, hook = _G[ "Detach__" .. name ], func = v.func, args = v.args, nochan = v.nochan } )
			end
		end
		
		local function StandardNetHook( netchan, nethook )
			local args = {}

			if ( nethook.func ) then
				table.insert( args, nethook.func( netchan ) )
			elseif ( !nethook.nochan ) then
				table.insert( args, netchan )
			end
			
			if ( nethook.args ) then
				for k, v in pairs( nethook.args ) do
					table.insert( args, v )
				end
			end

			nethook.hook( unpack( args ) )
		end

		local function AttachNetChannel( netchan )
			if ( !netchan ) then return false end

			Attach__CNetChan_Shutdown( netchan )

			for k, v in pairs( NET_HOOKS.attach ) do
				StandardNetHook( netchan, v )
			end

			return true
		end

		local function DetachNetChannel( netchan )
			if ( !netchan ) then return false end

			Detach__CNetChan_Shutdown( netchan )

			for k, v in pairs( NET_HOOKS.detach ) do
				StandardNetHook( netchan, v )
			end

			return true
		end

		local attached = false

		for i = 1, 255 do
			local netchan = CNetChan( i )
			
			if ( netchan ) then
				if ( !attached ) then
					AttachNetChannel( netchan )
					
					attached = true
				end
				
				table.insert( NET_CHANNELS, netchan )
			end
		end

		hook.Add( "PlayerConnect", "CreateNetChannel", function( name, address )
			if ( address == "none" ) then return end -- Bots don't have a net channel

			local indices = {}

			for k, v in pairs( player.GetAll() ) do
				table.insert( indices, v:EntIndex() )
			end
				
			local index

			if ( #indices > 0 ) then
				for i = 1, 255 do
					if ( !table.HasValue( indices, i ) ) then
						index = i
							
						break
					end
				end
			else
				index = 1 -- If there are no bots or players then the index will be 1
			end
				
			print( "Predicted index for " .. address .. " = " .. index )

			local netchan = CNetChan( index )

			if ( netchan ) then
				if ( #NET_CHANNELS == 0 ) then
					AttachNetChannel( netchan )
				end

				table.insert( NET_CHANNELS, netchan )
			end
		end )

		hook.Add( "PreNetChannelShutdown", "DetachHooks", function( netchan, reason )
			for k, v in pairs( NET_CHANNELS ) do
				if ( netchan:GetAddress():ToString() == v:GetAddress():ToString() ) then
					table.remove( NET_CHANNELS, k )
					
					break
				end
			end
			
			if ( #NET_CHANNELS == 0 ) then
				DetachNetChannel( netchan )
			end
		end )
		
		hook.Add( "ShutDown", "DetachHooks", function()
			if ( #NET_CHANNELS > 0 ) then
				DetachNetChannel( NET_CHANNELS[1] )
			end
		end )
	end