SCHEMA.Name = "Real Life RP";
SCHEMA.Author = "FNox";
SCHEMA.Description = "Pretend you have a life!";
SCHEMA.Base = "global";


--Ok, so a little explanation of what goes on, on this files

--First argument is the group's name.
--Second is the groups author/creator/founder
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
--Then comes the image used by the group. This needs to point to a valid texture. Currently, all my textures are 128x128 pixels.
--And you're done! You can look into the bliss schema for a more extensive example.


function SCHEMA.SetUp( )
	
	CAKE.RLRPFaction( "Police",
	"The State Government",
	{ 	["recruit"] = { [ "formalname" ] = "Police Recruit", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 1 },
		["officer"] = { [ "formalname" ] = "Police Officer", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 2 },
		["sergeant"] = { [ "formalname" ] = "Police Sergeant", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 3 },
		["lieutenant"] = { [ "formalname" ] = "Police Lieutenant", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 4 },
		["captain"] = { [ "formalname" ] = "Police Captain", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 5, ["cankick"] = true },
		["chief"] = { [ "formalname" ] = "Police Chief", [ "loadout" ] = { "weapon_mad_stunstick", "clothing_police", "weapon_pistol", "helmet_police", "weapon_smg1", "weapon_zipties" }, [ "level" ] = 6, ["cankick"] = true, ["canpromote"] = true, ["canedit"] = true  }
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
	1
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
	2)
	
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
	3)
	
end
