PLUGIN.Name = "Weapon Systems" -- What is the plugin name
PLUGIN.Author = "Big Bang" -- Author of the plugin
PLUGIN.Description = "Handles weapon saving, modification and such" -- The description or purpose of the plugin

CAKE.Undroppable = {
	"hands",
	"weapon_physcannon",
	"gmod_tool",
	"weapon_physgun"
}

local meta = FindMetaTable( "Player" )

function CAKE.CreateWeaponItem( ply, weapon )

	if ValidEntity( weapon ) and weapon:IsWeapon() and !table.HasValue( CAKE.Undroppable, weapon:GetClass()) then
		local id = CAKE.CreateItemID()
		CAKE.SetUData( id, "model", weapon.WorldModel )
		CAKE.SetUData( id, "name", weapon:GetClass() )
		CAKE.SetUData( id, "description", "Custom Weapon" )
		CAKE.SetUData( id, "weaponclass", weapon:GetClass() )
		CAKE.SetUData( id, "holdtype", weapon:GetHoldType() )
		CAKE.SetUData( id, "creator", ply:Nick() .. ":" .. ply:Name() .. " (" .. ply:SteamID() .. ")" )
		ply:GiveItem( "weapon_base", id )
		return id
	end
	return false

end

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

--Calculates whether to give the equivalent item of a weapon to a player, or not.
hook.Add( "WeaponEquip", "Tiramisu.GetWeaponAsItem", function(wep)
	timer.Simple(0, function() 
 		local class = wep:GetClass()
		local ply = wep:GetOwner() -- no longer a null entity.
		if CAKE.ItemData[ class ] then
			if !ply:HasItem( class ) then
				ply:GiveItem( class )
			end
		else
			local haveit = false
			for k, v in pairs( CAKE.GetCharField(ply, "inventory" ) ) do
				if CAKE.GetUData( v[2], "weaponclass" ) == wep:GetClass() then
					haveit = true
					break
				end
			end
			if !haveit then
				CAKE.CreateWeaponItem( ply, wep )
			end
		end
		ply:SaveAmmo()
	end)
end)

hook.Add( "PlayerLoadout", "TiramisuWeaponsLoadout", function( ply )
	if ply:IsCharLoaded() then
		if(ply:GetNWInt("charactercreate", 0 ) != 1) then
			for k, v in pairs( CAKE.GetCharField( ply, "inventory" ) ) do
				if string.match( v[1], "weapon" ) then
					ply:Give( CAKE.GetUData(v[2], "weaponclass") or v[1] )
				end
			end
			ply:RemoveAllAmmo( )
			ply:RestoreAmmo()
		end
	end
end )

function PLUGIN.Init()

	CAKE.AddDataField( 2, "ammo", CAKE.ConVars[ "Default_Ammo" ] )
	
end