--[[
	Fancy wrapper that allows you to send user messages of arbitrary length, so no 255 byte limit! :O
	With the added bonus of a Lua implementation of all non-char value transfering in user messages. :3
		By Overv
]]--

if ( CLIENT ) then
	--[[
		Custom receive system
	]]--
	
	local ReadString = _R.bf_read.ReadString
	local ReadChar = _R.bf_read.ReadChar
	
	local _buffer = {}
	local _index = 1
	
	usermessage.Hook( "UM_C", function( um )		
		for i = 1, 200 do
			table.insert( _buffer, ReadChar( um ) )
		end
	end )
	
	usermessage.Hook( "UM_D", function( um )
		local id = ReadString( um )
		
		_index = 1
		usermessage.IncomingMessage( id, um )
		
		_buffer = {}
	end )

	--[[
		Custom type receiving
	]]--
	
	function _R.bf_read:ReadChar()
		_index = _index + 1
		return _buffer[_index-1]
	end
	
	function _R.bf_read:ReadAngle()
		return Angle( self:ReadFloat(), self:ReadFloat(), self:ReadFloat() )
	end
	
	function _R.bf_read:ReadBool()
		return self:ReadChar() == 1
	end
	
	function _R.bf_read:ReadEntity()
		return Entity( self:ReadShort() )
	end
	
	function _R.bf_read:ReadFloat()
		local a, b, c = self:ReadChar() + 128, self:ReadChar() + 128, self:ReadChar() + 128
		local e = self:ReadChar()
		
		local s = a * 65536 + b * 256 + c - 8388608
		
		if ( s > 0 ) then
			return tonumber( "0." .. s ) * 10^e
		else
			return tonumber( "-0." .. math.abs( s ) ) * 10^e
		end
	end
	
	function _R.bf_read:ReadLong()
		local a, b, c, d = self:ReadChar() + 128, self:ReadChar() + 128, self:ReadChar() + 128, self:ReadChar() + 128
		return a * 16777216 + b * 65536 + c * 256 + d - 2147483648
	end
	
	function _R.bf_read:ReadShort()
		return ( self:ReadChar() + 128 ) * 256 + self:ReadChar() + 128 - 32768
	end
	
	function _R.bf_read:ReadString()
		local s, b = "", self:ReadChar()
		
		while ( b != 0 ) do
			s = s .. string.char( b + 128 )
			b = self:ReadChar()
		end
		
		return s
	end
	
	function _R.bf_read:ReadVector()
		return Vector( self:ReadFloat(), self:ReadFloat(), self:ReadFloat() )
	end
	
	function _R.bf_read:ReadVectorNormal()
		return self:ReadVector()
	end
end