SCHEMA.Name = "Real Life RP";
SCHEMA.Author = "FNox";
SCHEMA.Description = "Pretend you have a life!";
SCHEMA.Base = "global";

function SCHEMA.SetUp( )

	--Ok, so a little explanation of what goes on, on this files

	--First argument is the group's name.
	--Second is the groups author/creator/founder. It doesn't havet to be a real player.
	--Third is a table containing the ranks, the key is the "script name", or the name taht you're gonna use in the rp_admin forcejoin command.
	--Each rank is a table containing a set of "flags", add more flags if you would like to do so, but the default ones are:
	--formalname: The name that shows up on the group screen.
	--loadout: The items ( PLEASE NOTE: ITEMS ) that are given to the player on spawn
	--level: How high is this rank inside the group. Two ranks can have the same level. People can only promote other people up to their level (IE; a level two guy can't promote you to level 3)
	--canpromote: Is this rank allowed to promote people within the group?
	--caninvite: Is this rank allowed to invite new people?
	--canbuy: Is this rank allowed to use the business menu?
	--buygroups: Groups of items this rank is allowed to buy from.

	--The next argument is flags. Most of them are self describing. You can add them, fetch them and edit them using the group commands defined in the global groups plugin.
	--The following argument is their doorgroup, AKA, the doors they can open, add them using rp_admin adddoor groupnumber while looking at a door
	--After that there's a little description of the group you can see in game.
	--And you're done!
	function CAKE.RLRPFaction( name, founder, ranks, flags, doorgroup, desc )

		if !CAKE.GroupExists( name ) then
			local tbl = {
			[ "Name" ]		= name,
			[ "Type" ]		= "faction",
			[ "Founder" ]	= founder,
			[ "Members" ]	= {},
			[ "Inventory" ]	= {},
			[ "Flags" ]		= flags,
			[ "Ranks" ]		= ranks,
			[ "Description" ] = desc or "None available."
			}
			
			local doorgroups = {
				["doorgroups"] = doorgroup
			}
			table.Merge( flags, doorgroups )
			
			CAKE.CreateGroup( name, tbl )
		end
		
	end
	
	CAKE.RLRPFaction( "Police",
	"The State Government",
	{ 	["recruit"] = { [ "formalname" ] = "Police Recruit", [ "loadout" ] = { "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 1 },
		["officer"] = { [ "formalname" ] = "Police Officer", [ "loadout" ] = { "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 2 },
		["sergeant"] = { [ "formalname" ] = "Police Sergeant", [ "loadout" ] = { "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 3 },
		["lieutenant"] = { [ "formalname" ] = "Police Lieutenant", [ "loadout" ] = { "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 4 },
		["captain"] = { [ "formalname" ] = "Police Captain", [ "loadout" ] = {  "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 5, ["cankick"] = true },
		["chief"] = { [ "formalname" ] = "Police Chief", [ "loadout" ] = { "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 6, ["cankick"] = true, ["canpromote"] = true, ["canedit"] = true  }
	},
	{
		[ "soundgroup" ] = 2,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "recruit",
		[ "radiocolor" ] = Color( 255, 255, 255 ),
		[ "ispolice" ] = true,
		[ "radiogroup" ] = 1
	},
	1,
	"The City's elite police force."
	)
	
	CAKE.RLRPFaction( "Mafia",
	"Ricky Ricardo",
	{ 	["recruit"] = { [ "formalname" ] = "Mafia Recruit", [ "loadout" ] = { "clothing_combat", "clothing_combatf", "weapon_glock" }, [ "level" ] = 1 },
		["thug"] = { [ "formalname" ] = "Mafia Thug", [ "loadout" ] = { "clothing_combat", "clothing_combatf", "weapon_ak47", "helmet_balaclava" }, [ "level" ] = 2 },
		["dealer"] = { [ "formalname" ] = "Mafia Dealer", [ "loadout" ] = { "clothing_formal2", "weapon_glock", "helmet_balaclava" }, [ "level" ] = 3, ["buygroups"] = { 2, 3 } },
		["boss"] = { [ "formalname" ] = "Mafia Boss", [ "loadout" ] = { "clothing_combat", "clothing_formal", "weapon_ak47", "helmet_balaclava", "weapon_zipties" }, [ "level" ] = 4, ["canedit"] = true, ["canpromote"] = true, ["cankick"] = true  }
	},
	{
		[ "soundgroup" ] = 1,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "recruit",
		[ "radiocolor" ] = Color( 255, 100, 100 ),
		[ "ispolice" ] = false,
		[ "radiogroup" ] = 2
	},
	2,
	"Baddest and biggest criminal group around. Booyakasha."
	)
	
	CAKE.RLRPFaction( "Syndicate",
	"The Workers",
	{ 	["worker"] = { [ "formalname" ] = "Syndicated Worker", [ "loadout" ] = {}, [ "level" ] = 1 },
		["salesman"] = { [ "formalname" ] = "Syndicated Salesperson", [ "loadout" ] = {}, [ "level" ] = 1, ["canbuy"] = true, ["buygroups"] = { 1, 3 } },
		["scientist"] = { [ "formalname" ] = "Syndicated Scientist", [ "loadout" ] = { "clothing_labcoat" }, [ "level" ] = 2 },
		["leader"] = { [ "formalname" ] = "Syndicate Leader", [ "loadout" ] = { "clothing_formal" }, [ "level" ] = 4, ["caninvite"] = true, ["canpromote"] = true  }
	},
	{
		[ "soundgroup" ] = 1,
		[ "canbroadcast" ] = true,
		[ "loadouts" ] = true,
		[ "doorgroup" ] = true,
		[ "primaryrank" ] = "recruit",
		[ "radiocolor" ] = Color( 255, 255, 255 ),
		[ "ispolice" ] = false,
		[ "radiogroup" ] = 1
	},
	3,
	"The main provider of jobs to the whole City.")
	
end
