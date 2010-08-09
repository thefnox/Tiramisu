PLUGIN.Name = "Weapon Systems"; -- What is the plugin name
PLUGIN.Author = "Big Bang"; -- Author of the plugin
PLUGIN.Description = "Handles weapon saving, modification and such"; -- The description or purpose of the plugin

local function WeaponEquipItem( wep )

	timer.Simple(0.1, function() 
 
		local ply = wep:GetOwner() -- no longer a null entity.
		if CAKE.ItemData[ wep:GetClass( ) ] != nil and !table.HasValue( CAKE.GetCharField( ply, "inventory" ), wep:GetClass( ) ) then
			if !table.HasValue( CAKE.GetCharField( ply, "weapons" ), wep:GetClass( ) ) then
				local weapons = CAKE.GetCharField( ply, "weapons" )
				table.insert( weapons, wep:GetClass() )
				CAKE.SetCharField( ply, "weapons", weapons )
			end
			ply:GiveItem( wep:GetClass( ) )
		end 
 
	end)
 
end
hook.Add( "WeaponEquip", "GetWeaponAsItem", WeaponEquipItem )

function CAKE.DropWeapon( ply, wep )

	if( CAKE.ItemData[ wep:GetClass( ) ] != nil ) then
		CAKE.CreateItem( wep:GetClass( ), ply:CalcDrop( ), Angle( 0,0,0 ) );
		ply:TakeItem( wep:GetClass() )
		local weapons = CAKE.GetCharField( ply, "weapons" )
		for k, v in pairs( weapons ) do
			if v == wep:GetClass( ) then
				v = nil
			end
		end
		CAKE.SetCharField( ply, "weapons", weapons )
	end
	ply:StripWeapon( wep:GetClass( ) );
	
end

local meta = FindMetaTable( "Player" );

function meta:SaveAmmo()
	
	local tbl = {}
	if( self:GetNWString( "model", "" ) != "" ) then
	tbl[ "AR2" ] = self:GetAmmoCount( "AR2" )
	tbl[ "AlyxGun" ] = self:GetAmmoCount( "AlyxGun" )
	tbl[ "Pistol" ] = self:GetAmmoCount( "Pistol" )
	tbl[ "SMG1" ] = self:GetAmmoCount( "SMG1" )
	tbl[ "357" ] = self:GetAmmoCount( "357" )
	tbl[ "XBowBolt" ] = self:GetAmmoCount( "XBowBolt" )
	tbl[ "Buckshot" ] = self:GetAmmoCount( "Buckshot" )
	tbl[ "RPG_Round" ] = self:GetAmmoCount( "RPG_Round" )
	tbl[ "SMG1_Grenade" ] = self:GetAmmoCount( "SMG1_Grenade" )
	tbl[ "SniperRound" ] = self:GetAmmoCount( "SniperRound" )
	tbl[ "SniperPenetratedRound" ] = self:GetAmmoCount( "SniperPenetratedRound" )
	tbl[ "Grenade" ] = self:GetAmmoCount( "Grenade" )
	tbl[ "Thumper" ] = self:GetAmmoCount( "Thumper" )
	tbl[ "Gravity" ] = self:GetAmmoCount( "Gravity" )
	tbl[ "Battery" ] = self:GetAmmoCount( "Battery" )
	tbl[ "GaussEnergy" ] = self:GetAmmoCount( "GaussEnergy" )
	tbl[ "CombineCannon" ] = self:GetAmmoCount( "CombineCannon" )
	tbl[ "AirboatGun" ] = self:GetAmmoCount( "AirboatGun" )
	tbl[ "StriderMinigun" ] = self:GetAmmoCount( "StriderMinigun" )
	tbl[ "HelicopterGun" ] = self:GetAmmoCount( "HelicopterGun" )
	tbl[ "AR2AltFire" ] = self:GetAmmoCount( "AR2AltFire" )
	tbl[ "slam" ] = self:GetAmmoCount( "slam" )
	CAKE.SetCharField( self, "ammo", tbl )
	end
	
end

function meta:RestoreAmmo()

	for k, v in pairs( CAKE.GetCharField( self, "ammo" ) ) do
		self:GiveAmmo( v, k )
	end

end

/*
local function RemoveWeaponsAtDeath(ply)

	--CAKE.DeathMode(ply);
	local weapons = CAKE.GetCharField( ply, "weapons" )
	for k, v in pairs( weapons ) do
		ply:TakeItem( v )
	end
	ply:RemoveAllAmmo( )
	CAKE.SetCharField( ply, "ammo", {} )
	CAKE.SetCharField( ply, "weapons", {} )
	CAKE.CallHook("PlayerDeath", ply);
	CAKE.CallTeamHook("PlayerDeath", ply);
	
end
hook.Add( "PlayerDeath", "CakePlayerDeath", RemoveWeaponsAtDeath )*/

local function WeaponsLoadout( ply )
	
	if ply:IsCharLoaded() then
		if !ply.CheatedDeath then
			if(ply:GetNWInt("charactercreate") != 1) then
				for k, v in pairs( CAKE.GetCharField( ply, "weapons" ) ) do
					ply:Give( v )
				end
				ply:RemoveAllAmmo( )
				ply:RestoreAmmo()
				if ply.GetLoadout then
					local group = CAKE.GetCharField( ply, "group" )
					local rank = CAKE.GetCharField( ply, "grouprank" )
					ply.GetLoadout = false
					if CAKE.GetGroupFlag( group, "loadouts" ) then
						for k, v in pairs( CAKE.GetRankPermission( group, rank, "loadout" ) ) do
							if !ply:HasItem( v ) then
								ply:GiveItem( v )
							end
						end
					end
				end
			end
		else
			for k, v in pairs( CAKE.GetCharField( ply, "weapons" ) ) do
				ply:TakeItem( v )
			end
			for k, v in pairs( CAKE.GetCharField( ply, "inventory" ) ) do
				if string.match( v, "weapon" ) then 
					ply:TakeItem( v )
				end
			end
			ply:RemoveAllAmmo( )
			CAKE.SetCharField( ply, "weapons", {} )
			CAKE.SetCharField( ply, "ammo", {} )
		end
	end

end
hook.Add( "PlayerLoadout", "CakeWeaponsLoadout", WeaponsLoadout )

local function StartTimer( ply )
	if ply:IsCharLoaded() then
		timer.Create( "ammosavetimer" .. ply:Nick(), 15, 0, function()
			ply:SaveAmmo()
		end)
	end
end
hook.Add( "PlayerSpawn", "CakeAmmoSaveTimer", StartTimer )


function PLUGIN.Init()

	CAKE.AddDataField( 2, "weapons", CAKE.ConVars[ "Default_Weapons" ] );
	CAKE.AddDataField( 2, "ammo", CAKE.ConVars[ "Default_Ammo" ] );
	
end