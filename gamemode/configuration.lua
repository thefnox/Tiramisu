-- You can change these in the schema definition file as well.

CAKE.ConVars = {  }

CAKE.ConVars[ "LinuxHotfix" ] = false -- TURN THIS ON ONLY IF YOUR SERVER USES LINUX. This is to turn off model swapping therefore disabling some animations. It's the only solution to a current bug in the SRCDS.
CAKE.ConVars[ "ForceJigglebones" ] = true --Forces jigglebones on all clients. Turns this off if you know it causes performance problems. 

CAKE.ConVars[ "Tiramisu" ] = "2"
CAKE.ConVars[ "Schema" ] = "hl2rp" -- What folder is schema data being loaded from?

--General config
CAKE.ConVars[ "PlayerInventoryRows" ] = 4 --Set to 0 for infinite. Each row holds 10 items
CAKE.ConVars[ "StaticInventory" ] = false --Set this to false to make the inventory expandable with containers
CAKE.ConVars[ "SpawnWithBlackScreen" ] = true --Set this to true if you want people to be welomed with a black screen.
CAKE.ConVars[ "WalkSpeed" ] = 80 -- How fast do they walk
CAKE.ConVars[ "RunSpeed" ] = 420 -- How fast do they run
CAKE.ConVars[ "TalkRange" ] = 300 -- This is the range of talking.
CAKE.ConVars[ "SuicideEnabled" ] = false -- Can players compulsively suicide by using kill
CAKE.ConVars[ "UnconciousTimer" ] = 5 --Time that must be spent unconcious before being able to wake up. Set to 0 to disable (not recommended)
CAKE.ConVars[ "DisplayClock" ] = false --Use the clock system?
CAKE.ConVars[ "DefaultTime" ] = "1 1 2012 1" --The initial time of the script's clock.
CAKE.ConVars[ "DefaultAmmo" ] = {  } --The default ammo table your character will have on spawn.
CAKE.ConVars[ "DefaultClothing" ] = { }--Clothing you can choose on startup
CAKE.ConVars[ "UseEnhancedCitizens" ] = false --Set this to false if you want to use the default models instead of Enhanced Citizens by Bloocobalt and Lt_Commander.
if CAKE.ConVars[ "UseEnhancedCitizens" ] then
	CAKE.ConVars[ "DefaultModels" ] = {
		Male = {
			"models/bloo_ltcom/citizens/male_01.mdl",
			"models/bloo_ltcom/citizens/male_02.mdl",
			"models/bloo_ltcom/citizens/male_03.mdl",
			"models/bloo_ltcom/citizens/male_04.mdl",
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
	CAKE.ConVars[ "DefaultModels" ] = {
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
CAKE.ConVars[ "NPCCanAttackRagdoll" ] = true --Can NPC's attack player ragdolls?
CAKE.ConVars[ "DamageWhileUnconcious" ] = true --Can players be damaged while unconcious?
CAKE.ConVars[ "Prop_Damage" ] = false --Set this to true if you want props to damage people.
CAKE.ConVars[ "LoseWeaponsOnDeath" ] = false --Set this to true if you want people to lose their guns once they die.
CAKE.ConVars[ "LoseItemsOnDeath" ] = false --Set this to true if you want people to lose their items once they die. LoseWeaponsOnDeath must be set to true for this to work
CAKE.ConVars[ "ReturnToSpawnOnDeath" ] = true --Set this to true if you want people to return to the spawn point every time they are killed.
CAKE.ConVars[ "FadeToBlackOnDeath" ] = true --Set this to false if you want to disable the fade to black that occurs 5 seconds before death.
CAKE.ConVars[ "Respawn_Timer" ] = 10 --Time in seconds that it takes for people to be allowed to respawn.
CAKE.ConVars[ "Instant_Respawn" ] = false --Respawn instantly or allow people to lay dead for a while.
CAKE.ConVars[ "DeathRagdoll_Linger" ] = 30 --Time in seconds that it takes for ragdolls to dissapear, set to 0 if you want corpses to stay forever
CAKE.ConVars[ "AllowRescaling" ] = true --Allows you to change the size of your current clothes.
CAKE.ConVars[ "AllowBodygroups" ] = true --Allows you to change the body group of your current clothes.

--Tooltrust
CAKE.ConVars[ "DefaultPhysgun" ] = false -- Are players banned from the physics gun when they first start.
CAKE.ConVars[ "DefaultGravgun" ] = false -- Are players banned from the gravity gun when they first start.
CAKE.ConVars[ "DefaultPropTrust" ] = true --Are players allowed to spawn props when they first start.
CAKE.ConVars[ "DefaultVehicles" ] = false --Are players allowed to spawn vehicles when they first start.
CAKE.ConVars[ "PropLimit" ] = 20
CAKE.ConVars[ "RagdollLimit" ] = 1
CAKE.ConVars[ "VehicleLimit" ] = 0
CAKE.ConVars[ "EffectLimit" ] = 1
CAKE.ConVars[ "DefaultToolTrust" ] = 0 -- Do players start with tooltrust on? Set to 1 for true

--Money
CAKE.ConVars[ "CurrencyName" ] = "Credit" --The formal name for your currency
CAKE.ConVars[ "CurrencySlang" ] = "credit" --A slang way of mentioning it (I.E: 'bucks', 'simoleons')
CAKE.ConVars[ "CurrencyAbr" ] = "$" --An abbreviated form of mentioning your currency, could be a symbol.
CAKE.ConVars[ "DefaultMoney" ] = 800 -- How much money do the characters start out with.

--Titles
CAKE.ConVars[ "DefaultTitle" ] = "Citizen" -- The default title when characters are created.
CAKE.ConVars[ "TitleFadeTime"] = 10 --If titles are to fade when someone has been around a player for too long, how long will that take?
CAKE.ConVars[ "TitleDrawDistance"] = CAKE.ConVars[ "TalkRange" ] --How far away from the local player should titles draw?
CAKE.ConVars[ "FadeTitles"] = 1 --Should titles fade away after some time?
CAKE.ConVars[ "FadeNames"] = 0 --Should names fade away after some time?


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
CAKE.ConVars[ "ChatFont" ] = "Sansation Bold" -- Main font used in chatting
CAKE.ConVars[ "EmoteFont" ] = "Sansation Italic" -- Change this to use a different font for "/me's" and such
CAKE.ConVars[ "OOCFont" ] = CAKE.ConVars[ "ChatFont" ] --Change this to change the OOC font.
CAKE.ConVars[ "WhisperFont" ] = CAKE.ConVars[ "ChatFont" ] --Font used in whispering.
CAKE.ConVars[ "YellFont" ] = CAKE.ConVars[ "ChatFont" ] --Font used when yelling.
CAKE.ConVars[ "NoteFont" ] = CAKE.ConVars[ "ChatFont" ]
CAKE.ConVars[ "NamesFont"] = CAKE.ConVars[ "ChatFont" ]
CAKE.ConVars[ "TitlesFont"] = CAKE.ConVars[ "ChatFont" ]
CAKE.BaseColor = Color( 50, 50, 50, 150 ) --The schema's default color. Can be set in game
CAKE.ConVars[ "MaxChatLines" ] = 200 --The maximum amount of chatlines the chatbox can hold. Reducing this number may increase FPS in clients.

--Groups
CAKE.ConVars[ "DoorsPurchaseable" ] = true --Set this to false to make everyone able to lock/unlock ungrouped doors.
CAKE.ConVars[ "InviteTimer" ] = 60 --Time that must pass before another invite can be sent. Stops invite harassment.
CAKE.ConVars[ "AllowGroupChat" ] = true --Disable this to turn off all OOC group chat.

--Intro
CAKE.ConVars[ "UseIntro" ] = true --Set this to false if you want the player to go directly into the character menu when they join
CAKE.ConVars[ "IntroText" ] = "Welcome to Tiramisu 2" -- Character menu and intro text. NOTE, the HL2RP scheme changes this
CAKE.ConVars[ "IntroSubtitle" ] = "A new era in roleplay" -- Character menu and intro subtitle. If you want this gone just set it to ""

--General
CAKE.ConVars[ "Webpage" ] = "http://www.facepunch.com/" --Set this to whatever you want to, it'll be accessible on the "Forums" tab

CAKE.ConVars[ "MenuTitle" ] = "Tiramisu" --Title for the main menu
