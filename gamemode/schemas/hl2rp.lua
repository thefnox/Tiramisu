SCHEMA.Name = "Half Life 2 RP";
SCHEMA.Author = "FNox";
SCHEMA.Description = "Pretend you have a life!";
SCHEMA.Base = "global";

function SCHEMA.SetUp( )

	CAKE.ConVars["RationMoney"] = 15 -- How much money you get out of a ration
	CAKE.MaxRations = 60 -- The maximum amount of rations available
	CAKE.RationTimer = 10 --In minutes. The time it takes for rations to be resupplied

	SetGlobalInt( "rations", CAKE.MaxRations )

	--Here's an example on how to set up ranks in a more flag linke fashion, while still using the Groups system.
	function CAKE.AddMetroPoliceRank( name, formalname, loadout, level, canedit, cankick, canpromote )
		if !CAKE.GroupExists( "CCA") then
			local tbl = {
			[ "Name" ]		= "CCA",
			[ "Type" ]		= "faction",
			[ "Founder" ]	= "C17 Combine Command",
			[ "Members" ]	= {},
			[ "Inventory" ]	= {},
			[ "Flags" ]		= 	{
				[ "soundgroup" ] 	= 2,
				[ "canbroadcast" ] 	= true,
				[ "loadouts" ] 		= true,
				[ "doorgroup" ] 	= true,
				[ "primaryrank" ] 	= "rct",
				[ "doorgroups" ] 	= 1,
				[ "radiocolor" ] 	= Color( 220, 220, 220 ),
				[ "iscombine" ]		= true,
				[ "radiogroup" ] 	= 1
			},
			[ "Ranks" ]		= {},
			[ "Description" ] = "The Combine's elite police force, based on City " .. CAKE.CityNumber
			}
			
			CAKE.CreateGroup( "CCA", tbl )
		end

		if CAKE.RankExists( "CCA", name ) then
			CAKE.SetRankField( "CCA", name, "formalname", formalname or "none")
			CAKE.SetRankField( "CCA", name, "loadout", loadout or {})
			CAKE.SetRankField( "CCA", name, "level", level or 1)
			CAKE.SetRankField( "CCA", name, "canedit", canedit )
			CAKE.SetRankField( "CCA", name, "cankick", cankick )
			CAKE.SetRankField( "CCA", name, "cankick", canpromote )
		else
			CAKE.CreateRank( "CCA", name, {
				[ "formalname" ] = formalname or "none",
				[ "loadout" ] = loadout or {},
				[ "level" ] = level or 1,
				[ "canedit" ] = canedit,
				[ "cankick" ] = cankick,
				[ "canpromote" ] = canpromote
			})
		end
	end

	function CAKE.AddOverwatchRank( name, formalname, loadout, level, canedit, cankick, canpromote )
		if !CAKE.GroupExists( "Combine Overwatch") then
			local tbl = {
			[ "Name" ]		= "Combine Overwatch",
			[ "Type" ]		= "faction",
			[ "Founder" ]	= "Combine High Command",
			[ "Members" ]	= {},
			[ "Inventory" ]	= {},
			[ "Flags" ]		= 	{
				[ "soundgroup" ] 	= 2,
				[ "canbroadcast" ] 	= true,
				[ "loadouts" ] 		= true,
				[ "doorgroup" ] 	= true,
				[ "primaryrank" ] 	= "ow",
				[ "doorgroups" ] 	= 1,
				[ "radiocolor" ] 	= Color( 100, 100, 220 ),
				[ "iscombine" ]		= true,
				[ "radiogroup" ] 	= 1
			},
			[ "Ranks" ]		= {},
			[ "Description" ] = "The fearsome Overwatch, the Combine's trans-human military force"
			}
			
			CAKE.CreateGroup( "Combine Overwatch", tbl )
		end

		if CAKE.RankExists( "Combine Overwatch", name ) then
			CAKE.SetRankField( "Combine Overwatch", name, "formalname", formalname or "none")
			CAKE.SetRankField( "Combine Overwatch", name, "loadout", loadout or {})
			CAKE.SetRankField( "Combine Overwatch", name, "level", level or 1)
			CAKE.SetRankField( "Combine Overwatch", name, "canedit", canedit )
			CAKE.SetRankField( "Combine Overwatch", name, "cankick", cankick )
			CAKE.SetRankField( "Combine Overwatch", name, "cankick", canpromote )
		else
			CAKE.CreateRank( "Combine Overwatch", name, {
				[ "formalname" ] = formalname or "none",
				[ "loadout" ] = loadout or {},
				[ "level" ] = level or 1,
				[ "canedit" ] = canedit,
				[ "cankick" ] = cankick,
				[ "canpromote" ] = canpromote
			})
		end
	end

	function CAKE.AddResistanceRank( name, formalname, loadout, level, canedit, cankick, canpromote, buygroup )
		if !CAKE.GroupExists( "Resistance") then
			local tbl = {
			[ "Name" ]		= "Resistance",
			[ "Type" ]		= "faction",
			[ "Founder" ]	= "The Citizens of C17",
			[ "Members" ]	= {},
			[ "Inventory" ]	= {},
			[ "Flags" ]		= 	{
				[ "soundgroup" ] 	= 1,
				[ "canbroadcast" ] 	= false,
				[ "loadouts" ] 		= true,
				[ "doorgroup" ] 	= true,
				[ "primaryrank" ] 	= "rookie",
				[ "doorgroups" ] 	= 2,
				[ "radiocolor" ] 	= Color( 220, 20, 20 ),
				[ "radiogroup" ] 	= 2
			},
			[ "Ranks" ]		= {},
			[ "Description" ] = "Members of the civil insurgence, fighting for human liberation."
			}
			
			CAKE.CreateGroup( "Resistance", tbl )
		end

		if CAKE.RankExists( "Resistance", name ) then
			CAKE.SetRankField( "Resistance", name, "formalname", formalname or "none")
			CAKE.SetRankField( "Resistance", name, "loadout", loadout or {})
			CAKE.SetRankField( "Resistance", name, "level", level or 1)
			CAKE.SetRankField( "Resistance", name, "canedit", canedit )
			CAKE.SetRankField( "Resistance", name, "cankick", cankick )
			CAKE.SetRankField( "Resistance", name, "cankick", canpromote )
			CAKE.SetRankField( "Resistance", name, "buygroups", buygroup )
			print( CAKE.GetRankField( "Resistance", name, "buygroups" ) )
		else
			CAKE.CreateRank( "Resistance", name, {
				[ "formalname" ] = formalname or "none",
				[ "loadout" ] = loadout or {},
				[ "level" ] = level or 1,
				[ "canedit" ] = canedit,
				[ "cankick" ] = cankick,
				[ "canpromote" ] = canpromote,
				[ "buygroups" ] = buygroups
			})
		end
	end

	--Civil Protection
	--Recruit
	CAKE.AddMetroPoliceRank( "rct", "Civil Protection Recruit", {"clothing_police", "weapon_zipties", "weapon_stunstick" }, 1)
	--CP-1
	CAKE.AddMetroPoliceRank( "cp1", "Civil Protection Officer Rank 1", {"clothing_police", "helmet_police", "weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1" },2)
	--CP-2
	CAKE.AddMetroPoliceRank( "cp2", "Civil Protection Officer Rank 2", {"clothing_police", "helmet_police", "weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1" },3)
	--CP-3
	CAKE.AddMetroPoliceRank( "cp3", "Civil Protection Officer Rank 3", {"clothing_police", "helmet_police", "weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1" },4)
	--TL
	CAKE.AddMetroPoliceRank( "tl", "Civil Protection Team Leader", {"clothing_police", "helmet_police", "weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1", "weapon_shotgun" }, 5, false, true, true )
	--Medic
	CAKE.AddMetroPoliceRank( "m", "Civil Protection Medical Specialist", {"clothing_police", "helmet_police", "weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1", "firstaidkit", "small_medikit", "small_medikit", "small_medikit" },3)
	--Engineer
	CAKE.AddMetroPoliceRank( "en", "Civil Protection Engineer", {"clothing_police", "helmet_police", "helmet_elite", "weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1" }, 3)
	--Division Leader
	CAKE.AddMetroPoliceRank( "dl", "Civil Protection Division Leader", {"clothing_police", "helmet_police", "weapon_zipties", "weapon_stunstick", "weapon_pistol", "weapon_smg1", "weapon_shotgun" }, 6, true, true, true )

	--Overwatch
	--OW
	CAKE.AddOverwatchRank( "ow", "Overwatch Soldier", {"clothing_soldier", "helmet_soldier", "weapon_zipties", "weapon_stunstick", "weapon_smg1", "weapon_shotgun" }, 1)
	--Airwatch
	CAKE.AddOverwatchRank( "aw", "Airwatch Soldier", {"clothing_soldier", "helmet_soldier", "weapon_zipties", "weapon_stunstick", "weapon_smg1", "weapon_shotgun" }, 1)
	--Commander
	CAKE.AddOverwatchRank( "cw", "Overwatch Squad Commander", {"clothing_soldier", "helmet_soldier", "weapon_zipties", "weapon_stunstick", "weapon_ar2", "weapon_smg1", "weapon_shotgun" }, 2, false, true, true )
	--Elite
	CAKE.AddOverwatchRank( "ew", "Overwatch Elite Soldier", {"clothing_elite", "helmet_elite", "weapon_zipties", "weapon_stunstick", "weapon_ar2", "weapon_smg1", "weapon_shotgun" }, 2, false, true, true )

	--Lambda Rebels
	--Recruit
	CAKE.AddResistanceRank( "rookie", "Resistance Rookie", {"clothing_combat"}, 1 )
	--Regular members
	CAKE.AddResistanceRank( "member", "Resistance Member", { "clothing_combat", "helmet_balaclava", "weapon_smg1" }, 2 )
	--Medics
	CAKE.AddResistanceRank( "medic", "Resistance Medic", { "clothing_combat", "clothing_medic", "helmet_balaclava", "weapon_smg1" }, 2 )
	--Dealer
	CAKE.AddResistanceRank( "dealer", "Resistance Supplier", { "clothing_combat", "helmet_balaclava", "weapon_smg1" }, 2, false, false, false, {1,2,3} )
	--Leader
	CAKE.AddResistanceRank( "leader", "Resistance Leader", { "clothing_combat", "helmet_balaclava", "weapon_smg1","weapon_357"}, 3, true, true, true, {1,2,3} )

end
