-- You can change these in the schema definition file as well.

TIRA.ConVars = {  }

--MySQL
--The SQL engine option allows you to change which SQL module to use within the script, for convenience.
--It defaults to SQLite, which is included within GMod.
--If you don't know what this is, don't change it, leave it as it is, and head to the end of the MySQL section
TIRA.ConVars["SQLEngine"] = "sqlite"
--Only change the following fields if you're using a MySQL module other than SQLite (Default)
TIRA.ConVars["SQLHostname"] = "localhost" --IP you're connecting from
TIRA.ConVars["SQLUsername"] = "root" --MySQL username to use for connecting
TIRA.ConVars["SQLPassword"] = "c0m1da" --Password for this username
TIRA.ConVars["SQLDatabase"] = "tiramisu" --Database to work on. (Must already exist)
TIRA.ConVars["SQLPort"] = 3306 --Port on which to connect on
--End of the MySQL section

TIRA.ConVars[ "LinuxHotfix" ] = false -- TURN THIS ON ONLY IF YOUR SERVER USES LINUX. This is to turn off model swapping therefore disabling some animations. It's the only solution to a current bug in the SRCDS.
TIRA.ConVars[ "ForceJigglebones" ] = true --Forces jigglebones on all clients. Turns this off if you know it causes performance problems. 

TIRA.ConVars[ "Tiramisu" ] = "3"
TIRA.ConVars[ "Schema" ] = "freeform" -- What folder is schema data being loaded from?

--General config
TIRA.ConVars[ "AllowVoices" ] = true --Set this to false to disable rp_voice. This is HL2 chatter, not actual microphone speech.
TIRA.ConVars[ "PlayerInventoryRows" ] = 4 --Set to 0 for infinite. Each row holds 10 items
TIRA.ConVars[ "StaticInventory" ] = false --Set this to false to make the inventory expandable with containers
TIRA.ConVars[ "SpawnWithBlackScreen" ] = true --Set this to true if you want people to be welomed with a black screen.
TIRA.ConVars[ "WalkSpeed" ] = 80 -- How fast do they walk
TIRA.ConVars[ "RunSpeed" ] = 420 -- How fast do they run
TIRA.ConVars[ "TalkRange" ] = 300 -- This is the range of talking.
TIRA.ConVars[ "SuicideEnabled" ] = false -- Can players compulsively suicide by using kill
TIRA.ConVars[ "UnconciousTimer" ] = 5 --Time that must be spent unconcious before being able to wake up. Set to 0 to disable (not recommended)
TIRA.ConVars[ "DisplayClock" ] = false --Use the clock system?
TIRA.ConVars[ "DefaultTime" ] = "1 1 2012 1" --The initial time of the script's clock.
TIRA.ConVars[ "DefaultAmmo" ] = {  } --The default ammo table your character will have on spawn.
TIRA.ConVars[ "DefaultClothing" ] = { }--Clothing you can choose on startup
TIRA.ConVars[ "UseEnhancedCitizens" ] = false --Set this to false if you want to use the default models instead of Enhanced Citizens by Bloocobalt and Lt_Commander.
if TIRA.ConVars[ "UseEnhancedCitizens" ] then
	TIRA.ConVars[ "DefaultModels" ] = {
		Male = {
			"models/bloo_ltcom/citizens/male_01.mdl",
			"models/bloo_ltcom/citizens/male_02.mdl",
			"models/bloo_ltcom/citizens/male_03.mdl",
			"models/bloo_ltcom/citizens/male_04.mdl",
			"models/bloo_ltcom/citizens/male_05.mdl",
			"models/bloo_ltcom/citizens/male_06.mdl",
			"models/bloo_ltcom/citizens/male_07.mdl",
			"models/bloo_ltcom/citizens/male_08.mdl",
			"models/bloo_ltcom/citizens/male_09.mdl",
			"models/bloo_ltcom/citizens/male_10.mdl",
			"models/bloo_ltcom/citizens/male_11.mdl",
		},
		Female = {
			"models/bloo_ltcom/citizens/female_01.mdl",
			"models/bloo_ltcom/citizens/female_02.mdl",
			"models/bloo_ltcom/citizens/female_03.mdl",
			"models/bloo_ltcom/citizens/female_04.mdl",
			"models/bloo_ltcom/citizens/female_06.mdl",
			"models/bloo_ltcom/citizens/female_07.mdl",
		}
	}
else
	TIRA.ConVars[ "DefaultModels" ] = {
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
end 
--DEATH
TIRA.ConVars[ "NPCCanAttackRagdoll" ] = true --Can NPC's attack player ragdolls?
TIRA.ConVars[ "DamageWhileUnconcious" ] = true --Can players be damaged while unconcious?
TIRA.ConVars[ "Prop_Damage" ] = false --Set this to true if you want props to damage people.
TIRA.ConVars[ "LoseWeaponsOnDeath" ] = false --Set this to true if you want people to lose their guns once they die.
TIRA.ConVars[ "LoseItemsOnDeath" ] = false --Set this to true if you want people to lose their items once they die. LoseWeaponsOnDeath must be set to true for this to work
TIRA.ConVars[ "ReturnToSpawnOnDeath" ] = true --Set this to true if you want people to return to the spawn point every time they are killed.
TIRA.ConVars[ "FadeToBlackOnDeath" ] = true --Set this to false if you want to disable the fade to black that occurs 5 seconds before death.
TIRA.ConVars[ "Respawn_Timer" ] = 10 --Time in seconds that it takes for people to be allowed to respawn.
TIRA.ConVars[ "Instant_Respawn" ] = false --Respawn instantly or allow people to lay dead for a while.
TIRA.ConVars[ "DeathRagdoll_Linger" ] = 30 --Time in seconds that it takes for ragdolls to dissapear, set to 0 if you want corpses to stay forever
TIRA.ConVars[ "AllowRescaling" ] = true --Allows you to change the size of your current clothes.
TIRA.ConVars[ "AllowBodygroups" ] = true --Allows you to change the body group of your current clothes.

--Tooltrust
TIRA.ConVars[ "DefaultPhysgun" ] = false -- Are players banned from the physics gun when they first start.
TIRA.ConVars[ "DefaultGravgun" ] = false -- Are players banned from the gravity gun when they first start.
TIRA.ConVars[ "DefaultPropTrust" ] = true --Are players allowed to spawn props when they first start.
TIRA.ConVars[ "DefaultVehicles" ] = false --Are players allowed to spawn vehicles when they first start.
TIRA.ConVars[ "PropLimit" ] = 20
TIRA.ConVars[ "RagdollLimit" ] = 1
TIRA.ConVars[ "VehicleLimit" ] = 0
TIRA.ConVars[ "EffectLimit" ] = 1
TIRA.ConVars[ "DefaultToolTrust" ] = 0 -- Do players start with tooltrust on? Set to 1 for true

--Money
TIRA.ConVars[ "CurrencyName" ] = "Credit" --The formal name for your currency
TIRA.ConVars[ "CurrencySlang" ] = "credit" --A slang way of mentioning it (I.E: 'bucks', 'simoleons')
TIRA.ConVars[ "CurrencyAbr" ] = "$" --An abbreviated form of mentioning your currency, could be a symbol.
TIRA.ConVars[ "DefaultMoney" ] = 800 -- How much money do the characters start out with.

--Titles
TIRA.ConVars[ "DefaultTitle" ] = "Citizen" -- The default title when characters are created.
TIRA.ConVars[ "TitleFadeTime"] = 10 --If titles are to fade when someone has been around a player for too long, how long will that take?
TIRA.ConVars[ "TitleDrawDistance"] = TIRA.ConVars[ "TalkRange" ] --How far away from the local player should titles draw?
TIRA.ConVars[ "FadeTitles"] = 1 --Should titles fade away after some time?
TIRA.ConVars[ "FadeNames"] = 0 --Should names fade away after some time?


--Stats for the fighting system, plus stamina. Currently it's just health and stamina.
TIRA.Stats = {}

TIRA.Stats.Stamina = {}
TIRA.Stats.Stamina.BaseRegenRate = 2 --This is the percentage recovered per second.
TIRA.Stats.Stamina.BaseRunCost = 2 --The amount of stamina consumed per second of running. Set this to 0 to disable it.

TIRA.Stats.Health = {}
TIRA.Stats.Health.BaseRegenRate = 1 --This is the amount of health recovered per second. Sit this to 0 to disable health regeneration.
TIRA.Stats.Health.MaxRegenPerc = 60 --Percentage of health that can be regenerated. Set this to a lower amount if you wish for health to not fully regenerate
TIRA.Stats.Health.Max = 10000 --Maximum possible health amount.
TIRA.Stats.Health.Base = 100 --The base amount of health a player begins with.

--And finally, some clientside stuff.

--VGUI
TIRA.ConVars[ "MenuFont" ] = "Yanone Kaffeesatz Regular" -- The default font for the whole schema
TIRA.ConVars[ "MenuFont2" ] = "Yanone Kaffeesatz Bold" -- In case you want a different font for the bigger labels, change this to whatever you want.
TIRA.ConVars[ "ChatFont" ] = "Sansation Bold" -- Main font used in chatting
TIRA.ConVars[ "EmoteFont" ] = "Sansation Italic" -- Change this to use a different font for "/me's" and such
TIRA.ConVars[ "OOCFont" ] = TIRA.ConVars[ "ChatFont" ] --Change this to change the OOC font.
TIRA.ConVars[ "WhisperFont" ] = TIRA.ConVars[ "ChatFont" ] --Font used in whispering.
TIRA.ConVars[ "YellFont" ] = TIRA.ConVars[ "ChatFont" ] --Font used when yelling.
TIRA.ConVars[ "NoteFont" ] = TIRA.ConVars[ "ChatFont" ]
TIRA.ConVars[ "NamesFont"] = TIRA.ConVars[ "ChatFont" ]
TIRA.ConVars[ "TitlesFont"] = TIRA.ConVars[ "ChatFont" ]
TIRA.BaseColor = Color( 50, 50, 50, 150 ) --The schema's default color. Can be set in game
TIRA.ConVars[ "MaxChatLines" ] = 100 --The maximum amount of chatlines the chatbox can hold. Reducing this number may increase FPS in clients.

--Groups
TIRA.ConVars[ "DoorsPurchaseable" ] = true --Set this to false to make everyone able to lock/unlock ungrouped doors.
TIRA.ConVars[ "InviteTimer" ] = 60 --Time that must pass before another invite can be sent. Stops invite harassment.
TIRA.ConVars[ "AllowGroupChat" ] = true --Disable this to turn off all OOC group chat.

--Intro
TIRA.ConVars[ "UseIntro" ] = true --Set this to false if you want the player to go directly into the character menu when they join
TIRA.ConVars[ "IntroText" ] = "Welcome to Tiramisu 3" -- Character menu and intro text. NOTE, the HL2RP scheme changes this
TIRA.ConVars[ "IntroSubtitle" ] = "GMod 13 Edition" -- Character menu and intro subtitle. If you want this gone just set it to ""

--General
TIRA.ConVars[ "Webpage" ] = "http://www.google.com/" --Set this to whatever you want to, it'll be accessible on the "Forums" tab

TIRA.ConVars[ "MenuTitle" ] = "Tiramisu 3" --Title for the main menu
