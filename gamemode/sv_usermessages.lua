--[[
	Fancy wrapper that allows you to send user messages of arbitrary length, so no 255 byte limit! :O
	With the added bonus of a Lua implementation of all non-char value transfering in user messages. :3
		By Overv
]]--

AddCSLuaFile( "autorun/cl_umsg.lua" )

if ( SERVER ) then
	--[[
		Custom transfer system
	]]--
	
	umsg.PoolString( "UM_C" )
	umsg.PoolString( "UM_D" )
	
	local _id, _filter
	local _size = 0
	local _buffer = {}
	
	local Char = umsg.Char
	local String = umsg.String
	
	local Start = umsg.Start
	local End = umsg.End
	
	function umsg.Start( id, filter )
		_id = id
		_filter  = filter
		_buffer = {}
	end
	
	local function flushBuffer()
		if ( #_buffer == 0 ) then return end
		
		Start( "UM_C", _filter )
			for i = 1, 200 do
				Char( _buffer[i] )
			end
		End()
		
		_buffer = {}
	end
	
	function umsg.End()
		flushBuffer()
		
		Start( "UM_D", _filter )
			String( _id )
		End()
	end
	
	--[[
		Custom type sending
	]]--
	
	function umsg.Char( c )
		_size = _size + 1
		table.insert( _buffer, c )
		
		if ( #_buffer == 200 ) then
			flushBuffer()
		end
	end
	
	function umsg.Angle( a )
		umsg.Float( a.p )
		umsg.Float( a.y )
		umsg.Float( a.r )
	end
	
	function umsg.Bool( b )
		if ( b ) then
			umsg.Char( 1 )
		else
			umsg.Char( 0 )
		end
	end
	
	function umsg.Entity( e )
		umsg.Short( e:EntIndex() )
	end
	
	function umsg.Float( f )
		f = f or 0
		
		local neg = f < 0
		f = math.abs( f )
		
		-- Extract significant digits and exponent
		local e = 0
		if ( f >= 1 ) then
			while ( f >= 1 ) do
				f = f / 10
				e = e + 1
			end
		else
			while ( f < 0.1 ) do
				f = f * 10
				e = e - 1
			end
		end
		
		-- Discard digits
		local s = tonumber( string.sub( f, 3, 9 ) )
		
		-- Negate if the original number was negative
		if ( neg ) then s = -s end
		
		-- Convert to unsigned
		s = s + 8388608
		
		-- Send significant digits as 3 byte number
		
		local a = math.modf( s / 65536 ) s = s - a * 65536
		local b = math.modf( s / 256 ) s = s - b * 256
		local c = s
		
		umsg.Char( a - 128 )
		umsg.Char( b - 128 )
		umsg.Char( c - 128 )
		
		-- Send exponent
		umsg.Char( e )
	end
	
	function umsg.Long( l )
		-- Convert to unsigned
		l = l + 2147483648
		
		local a = math.modf( l / 16777216 ) l = l - a * 16777216
		local b = math.modf( l / 65536 ) l = l - b * 65536
		local c = math.modf( l / 256 ) l = l - c * 256
		local d = l
		
		umsg.Char( a - 128 )
		umsg.Char( b - 128 )
		umsg.Char( c - 128 )
		umsg.Char( d - 128 )
	end
	
	function umsg.Short( s )
		-- Convert to unsigned
		s = ( s or 0 ) + 32768
		
		local a = math.modf( s / 256 )
		
		umsg.Char( a - 128 )
		umsg.Char( s - a * 256 - 128 )
	end
	
	function umsg.String( s )
		for i = 1, #s do
			umsg.Char( s:sub( i, i ):byte() - 128 )
		end
		umsg.Char( 0 )
	end
	
	function umsg.Vector( v )
		umsg.Float( v.x )
		umsg.Float( v.y )
		umsg.Float( v.z )
	end
	
	function umsg.VectorNormal( v )
		umsg.Vector( v )
	end
end