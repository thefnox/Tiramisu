-- You can change these in the schema definition file as well.

CAKE.ConVars = {  }

CAKE.ConVars[ "Tiramisu" ] = "2"
CAKE.ConVars[ "Schema" ] = "hl2rp" -- What folder is schema data being loaded from?

--General config
CAKE.ConVars[ "SpawnWithBlackScreen" ] = true --Set this to true if you want people to be welomed with a black screen.
CAKE.ConVars[ "WalkSpeed" ] = 80 -- How fast do they walk
CAKE.ConVars[ "RunSpeed" ] = 420 -- How fast do they run
CAKE.ConVars[ "TalkRange" ] = 300 -- This is the range of talking.
CAKE.ConVars[ "SuicideEnabled" ] = false -- Can players compulsively suicide by using kill
CAKE.ConVars[ "UnconciousTimer" ] = 5 --Time that must be spent unconcious before being able to wake up. Set to 0 to disable (not recommended)
CAKE.ConVars[ "DisplayClock" ] = false --Use the clock system?
CAKE.ConVars[ "DefaultTime" ] = "1 1 2012 1" --The initial time of the script's clock.
CAKE.ConVars[ "Default_Money" ] = 800 -- How much money do the characters start out with.
CAKE.ConVars[ "Default_Title" ] = "Citizen" -- What is their title when they create their character.
CAKE.ConVars[ "Default_Inventory" ] = {  } -- What inventory do characters start out with when they are first made. 
CAKE.ConVars[ "Default_Ammo" ] = {  } --The default ammo table your character will have on spawn.
CAKE.ConVars[ "Default_Clothing" ] = { }--Clothing you can choose on startup
CAKE.ConVars[ "Default_Models" ] = {
	Male = {
		"models/humans/group01/male_01.mdl",
		"models/humans/group01/male_02.mdl",
		"models/humans/group01/male_03.mdl",
		"models/humans/group01/male_04.mdl",
		"models/humans/group01/male_05.mdl",
		"models/humans/group01/male_06.mdl",
		"models/humans/group01/male_07.mdl",
		"models/humans/group01/male_08.mdl",
		"models/humans/group01/male_09.mdl"
	},
	Female = {

		"models/Humans/Group01/Female_01.mdl",
		"models/Humans/Group01/Female_02.mdl",
		"models/Humans/Group01/Female_03.mdl",
		"models/Humans/Group01/Female_04.mdl",
		"models/Humans/Group01/Female_06.mdl",
		"models/Humans/Group01/Female_07.mdl"
	}
}

--DEATH
CAKE.ConVars[ "Prop_Damage" ] = false --Set this to true if you want props to damage people.
CAKE.ConVars[ "LoseWeaponsOnDeath" ] = false --Set this to true if you want people to lose their guns once they die.
CAKE.ConVars[ "LoseItemsOnDeath" ] = false --Set this to true if you want people to lose their items once they die. LoseWeaponsOnDeath must be set to true for this to work
CAKE.ConVars[ "ReturnToSpawnOnDeath" ] = true --Set this to true if you want people to return to the spawn point every time they are killed.
CAKE.ConVars[ "FadeToBlackOnDeath" ] = true --Set this to false if you want to disable the fade to black that occurs 5 seconds before death.
CAKE.ConVars[ "Respawn_Timer" ] = 10 --Time in seconds that it takes for people to be allowed to respawn.
CAKE.ConVars[ "Instant_Respawn" ] = false --Respawn instantly or allow people to lay dead for a while.
CAKE.ConVars[ "DeathRagdoll_Linger" ] = 0 --Time in seconds that it takes for ragdolls to dissapear, set to 0 if you want corpses to stay forever

CAKE.ConVars[ "Default_Physgun" ] = 0 -- Are players banned from the physics gun when they first start.
CAKE.ConVars[ "Default_Gravgun" ] = 0 -- Are players banned from the gravity gun when they first start.
CAKE.ConVars[ "Default_PropTrust" ] = 0 --Are players allowed to spawn props when they first start.
CAKE.ConVars[ "PropLimit" ] = 20
CAKE.ConVars[ "RagdollLimit" ] = 1
CAKE.ConVars[ "VehicleLimit" ] = 0
CAKE.ConVars[ "EffectLimit" ] = 1
CAKE.ConVars[ "Default_Tooltrust" ] = 0 -- Do players start with tooltrust on?

--Stats for the fighting system, plus stamina

CAKE.Stats = {}

CAKE.Stats.Stamina = {}
CAKE.Stats.Stamina.BaseRegenRate = 2 --This is the percentage recovered per second.
CAKE.Stats.Stamina.BaseRunCost = 2 --The amount of stamina consumed per second of running. Set this to 0 to disable it.

CAKE.Stats.Health = {}
CAKE.Stats.Health.BaseRegenRate = 1 --This is the amount of health recovered per second. Sit this to 0 to disable health regeneration.
CAKE.Stats.Health.MaxRegenPerc = 60 --Percentage of health that can be regenerated. Set this to a lower amount if you wish for health to not fully regenerate
CAKE.Stats.Health.Max = 10000 --Maximum possible health amount.
CAKE.Stats.Health.Base = 100 --The base amount of health a player begins with.

--And finally, some clientside stuff.

--VGUI
CAKE.ConVars[ "MenuFont" ] = "Yanone Kaffeesatz Regular" -- The default font for the whole schema
CAKE.ConVars[ "MenuFont2" ] = "Yanone Kaffeesatz Bold" -- In case you want a different font for the bigger labels, change this to whatever you want.
CAKE.ConVars[ "ChatFont" ] = "ChatFont" -- Main font used in chatting
CAKE.ConVars[ "WhisperFont" ] = "DefaultSmallDropShadow" --Font used in whispering.
CAKE.ConVars[ "YellFont" ] = "Trebuchet18" --Font used when yelling.
CAKE.BaseColor = Color( 50, 50, 50, 150 ) --The schema's default color. Can be set in game

--Intro
CAKE.ConVars[ "UseIntro" ] = true --Set this to false if you want the player to go directly into the character menu when they join
CAKE.ConVars[ "IntroText" ] = "Welcome to Tiramisu" -- Character menu and intro text. NOTE, the HL2RP scheme changes this
CAKE.ConVars[ "IntroSubtitle" ] = "A ROLEPLAY REVOLUTION" -- Character menu and intro subtitle. If you want this gone just set it to ""

--General
CAKE.ConVars[ "Webpage" ] = "http://www.facepunch.com/" --Set this to whatever you want to, it'll be accessible on the "Forums" tab
