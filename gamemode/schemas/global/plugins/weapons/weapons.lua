PLUGIN.Name = "Weapon Systems"; -- What is the plugin name
PLUGIN.Author = "Big Bang"; -- Author of the plugin
PLUGIN.Description = "Handles weapon saving, modification and such"; -- The description or purpose of the plugin

CAKE.Undroppable = {
	"hands",
	"weapon_physcannon",
	"gmod_tool",
	"weapon_physgun"
}

--Calculates whether to give the equivalent item of a weapon to a player, or not.
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

--Utility to drop the player's currently active weapon as an item, if possible
function CAKE.DropWeapon( ply, wep )

	if( CAKE.ItemData[ wep ] != nil ) then
		if ply:HasItem( wep) then
			ply:TakeItem( wep )
		end
		CAKE.CreateItem( wep , ply:CalcDrop( ), Angle( 0,0,0 ) );
		local weapons = CAKE.GetCharField( ply, "weapons" )
		for k, v in pairs( weapons ) do
			if v == wep then
				table.remove( weapons, k )
			end
		end
		CAKE.SetCharField( ply, "weapons", weapons )
	end
	ply:StripWeapon( wep );
	
end

local meta = FindMetaTable( "Player" );

--Saves the entire ammo list.
function meta:SaveAmmo()
	
	local tbl = {}
	if( self:GetNWString( "model", "" ) != "" ) then
	tbl[ "AR2" ] = 120
	tbl[ "AlyxGun" ] = 120
	tbl[ "Pistol" ] = 120
	tbl[ "SMG1" ] = 120
	tbl[ "357" ] = 120
	tbl[ "XBowBolt" ] = 120
	tbl[ "Buckshot" ] = 120
	tbl[ "RPG_Round" ] = self:GetAmmoCount( "RPG_Round" )
	tbl[ "SMG1_Grenade" ] = self:GetAmmoCount( "SMG1_Grenade" )
	tbl[ "SniperRound" ] = 120
	tbl[ "SniperPenetratedRound" ] = 120
	tbl[ "Grenade" ] = self:GetAmmoCount( "Grenade" )
	tbl[ "Thumper" ] = self:GetAmmoCount( "Thumper" )
	tbl[ "Gravity" ] = self:GetAmmoCount( "Gravity" )
	tbl[ "Battery" ] = self:GetAmmoCount( "Battery" )
	tbl[ "GaussEnergy" ] = 120
	tbl[ "CombineCannon" ] = 120
	tbl[ "AirboatGun" ] = 120
	tbl[ "StriderMinigun" ] = 120
	tbl[ "HelicopterGun" ] = 120
	tbl[ "AR2AltFire" ] = 120
	tbl[ "slam" ] = self:GetAmmoCount( "slam" )
	CAKE.SetCharField( self, "ammo", tbl )
	end
	
end

--Gives the player all of his stored ammo.
function meta:RestoreAmmo()

	for k, v in pairs( CAKE.GetCharField( self, "ammo" ) ) do
		self:GiveAmmo( v, k, false )
	end

end


hook.Add( "PlayerLoadout", "TiramisuWeaponsLoadout", function( ply )

	if ply:IsCharLoaded() then
		if(ply:GetNWInt("charactercreate", 0 ) != 1) then
			for k, v in pairs( CAKE.GetCharField( ply, "weapons" ) ) do
				ply:Give( v )
			end
			for k, v in pairs( CAKE.GetCharField( ply, "inventory")) do
				if string.match( v, "weapon_" ) then
					ply:Give( v )
				end
			end
			ply:RemoveAllAmmo( )
			ply:RestoreAmmo()
		end
	end

end )

--AUtomatically saves a player's ammo.
hook.Add( "PlayerSpawn", "TiramisuAmmoSaveTimer", function( ply )

	if ply:IsCharLoaded() then
		timer.Create( "ammosavetimer" .. ply:Nick(), 15, 0, function()
			ply:SaveAmmo()
		end)
	end

end )

function ccDropWeapon( ply, cmd, args )
	
	local wep = ply:GetActiveWeapon( )
	if !table.HasValue( CAKE.Undroppable, wep:GetClass() ) then 
		CAKE.DropWeapon( ply, wep:GetClass() )
		CAKE.RemoveGearItem( ply, wep:GetClass() )
		if wep:Clip1() > 0 then
			ply:SetAmmo( math.Clamp( ply:GetAmmoCount( wep:GetPrimaryAmmoType( ) ) - wep:Clip1( ), 0, ply:GetAmmoCount( wep:GetPrimaryAmmoType( ) ) ), wep:GetPrimaryAmmoType( ) )
			ply:SaveAmmo()
		end
	end

	ply:SelectWeapon( "hands" )
	ply:RefreshInventory( )
	
end
concommand.Add( "rp_dropweapon", ccDropWeapon );



function PLUGIN.Init()

	CAKE.AddDataField( 2, "weapons", CAKE.ConVars[ "Default_Weapons" ] );
	CAKE.AddDataField( 2, "ammo", CAKE.ConVars[ "Default_Ammo" ] );
	
end